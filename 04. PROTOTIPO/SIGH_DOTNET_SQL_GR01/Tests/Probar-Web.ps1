param([string]$Url = 'http://localhost:5080/')
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Net.Http
$handler = [System.Net.Http.HttpClientHandler]::new()
$handler.AllowAutoRedirect = $false
$client = [System.Net.Http.HttpClient]::new($handler)
$client.BaseAddress = $Url
$client.Timeout = [TimeSpan]::FromSeconds(40)

function Test-Status($respuesta, $esperado, $caso) {
    if ([int]$respuesta.StatusCode -ne $esperado) { throw "$caso : HTTP $([int]$respuesta.StatusCode)" }
    Write-Output "OK: $caso (HTTP $esperado)"
}
function Get-Token($respuesta) {
    $html = $respuesta.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    $token = [regex]::Match($html, 'name="__RequestVerificationToken" type="hidden" value="([^"]+)"').Groups[1].Value
    if (-not $token) { throw 'No se encontró el token del formulario.' }
    return [System.Net.WebUtility]::HtmlDecode($token)
}
function Post-Form($ruta, $campos) {
    $diccionario = [System.Collections.Generic.Dictionary[string,string]]::new()
    foreach ($campo in $campos.Keys) { $diccionario.Add($campo, $campos[$campo]) }
    $contenido = [System.Net.Http.FormUrlEncodedContent]::new($diccionario)
    try { return $client.PostAsync($ruta, $contenido).GetAwaiter().GetResult() }
    finally { $contenido.Dispose() }
}
function Test-Pdf($ruta, $nombre) {
    $respuesta = $client.GetAsync($ruta).GetAwaiter().GetResult()
    Test-Status $respuesta 200 "PDF $nombre"
    if ($respuesta.Content.Headers.ContentType.MediaType -ne 'application/pdf') { throw "Tipo incorrecto en $nombre" }
    $bytes = $respuesta.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult()
    if ($bytes.Length -lt 500 -or [Text.Encoding]::ASCII.GetString($bytes,0,5) -ne '%PDF-') { throw "PDF inválido en $nombre" }
    if (-not $respuesta.Headers.CacheControl.NoStore) { throw 'El PDF debe impedir almacenamiento en caché.' }
    $carpeta = Join-Path (Split-Path -Parent $PSScriptRoot) 'obj/PruebasReportes'
    New-Item -ItemType Directory -Path $carpeta -Force | Out-Null
    [IO.File]::WriteAllBytes((Join-Path $carpeta ($nombre+'.pdf')), $bytes)
}
function Post-PersonaFoto($campos, [byte[]]$bytes) {
    $contenido = [System.Net.Http.MultipartFormDataContent]::new()
    try {
        foreach ($campo in $campos.Keys) { $contenido.Add([System.Net.Http.StringContent]::new([string]$campos[$campo]), $campo) }
        $archivo = [System.Net.Http.ByteArrayContent]::new($bytes)
        $archivo.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::new('image/png')
        $contenido.Add($archivo, 'foto', 'prueba.png')
        return $client.PostAsync('persona', $contenido).GetAwaiter().GetResult()
    }
    finally { $contenido.Dispose() }
}
try {
    Test-Status ($client.GetAsync('inicio').GetAwaiter().GetResult()) 302 'inicio protegido'
    Test-Status ($client.GetAsync('departamentos').GetAwaiter().GetResult()) 302 'departamentos protegidos'
    Test-Status (Post-Form 'departamentos' @{modo='crear';codigo='ZZZ';descripcion='No autorizado'}) 302 'operaciones protegidas sin sesión'
    Test-Status ($client.GetAsync('cargos').GetAwaiter().GetResult()) 302 'cargos protegidos sin sesión'
    Test-Status ($client.GetAsync('persona').GetAwaiter().GetResult()) 302 'personas protegidas sin sesión'
    Test-Status ($client.GetAsync('reporte?r=departamentos').GetAwaiter().GetResult()) 302 'reportes protegidos sin sesión'
    Test-Status (Post-Form 'cargos' @{modo='crear';departamento='FIN'}) 302 'cargos protegidos al guardar sin sesión'
    $formulario = $client.GetAsync('').GetAwaiter().GetResult()
    Test-Status $formulario 200 'formulario disponible'
    $token = Get-Token $formulario
    Test-Status (Post-Form 'login' @{nombre='sullivan';clave='Sulley2026!'}) 400 'login sin token rechazado'
    $incorrecta = Post-Form 'login' @{nombre='sullivan';clave='incorrecta';__RequestVerificationToken=$token}
    Test-Status $incorrecta 200 'contraseña incorrecta muestra el formulario'
    $mensaje = [System.Net.WebUtility]::HtmlDecode($incorrecta.Content.ReadAsStringAsync().GetAwaiter().GetResult())
    if (-not $mensaje.Contains('Usuario o contraseña incorrectos.')) {
        throw 'Falta mensaje de credenciales incorrectas.'
    }
    $correcta = Post-Form 'login' @{nombre='sullivan';clave='Sulley2026!';__RequestVerificationToken=(Get-Token $incorrecta)}
    Test-Status $correcta 302 'login correcto redirige'
    $inicio = $client.GetAsync('inicio').GetAwaiter().GetResult()
    Test-Status $inicio 200 'sesión autenticada'
    if (-not $inicio.Content.ReadAsStringAsync().GetAwaiter().GetResult().Contains('sullivan')) {
        throw 'Falta el usuario autenticado.'
    }
    $departamentos = $client.GetAsync('departamentos').GetAwaiter().GetResult()
    Test-Status $departamentos 200 'catálogo accesible después del login'
    $html = $departamentos.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    if (-not $html.Contains('Departamentos registrados') -or ([regex]::Matches($html, '<!doctype html>').Count -ne 1)) {
        throw 'La vista de departamentos no se integró correctamente.'
    }
    Test-Status (Post-Form 'departamentos' @{modo='crear';codigo='ZZZ'}) 400 'operación sin token rechazada'
    Test-Status (Post-Form 'departamentos' @{modo='crear';codigo='!!!!';__RequestVerificationToken=(Get-Token $departamentos)}) 400 'código inválido rechazado'
    $listado = $client.GetAsync('cargos').GetAwaiter().GetResult()
    Test-Status $listado 200 'cargos consultados desde SQL Server'
    $todos = $listado.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    $listbox = [regex]::Match($todos, '<select[^>]*id="filtro"[^>]*>([\s\S]*?)</select>')
    if (-not $listbox.Success -or $listbox.Value -match 'size=|multiple') {
        throw 'Falta el selector desplegable de departamentos.'
    }
    $opciones = [regex]::Matches($listbox.Groups[1].Value, '<option value="([A-Z0-9]{1,3})"')
    if ($opciones.Count -eq 0) { throw 'No se cargaron los departamentos en el selector.' }
    foreach ($opcion in $opciones) {
        $departamento = $opcion.Groups[1].Value
        $resultado = $client.GetAsync("cargos?filtro=$departamento").GetAwaiter().GetResult()
        Test-Status $resultado 200 "filtro $departamento"
        $filtrado = $resultado.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        $filas = [regex]::Matches($filtrado, '<tr data-departamento="([^"]+)">')
        $esperadas = [regex]::Matches($todos, '<tr data-departamento="' + $departamento + '">').Count
        if ($filas.Count -ne $esperadas) { throw "Cantidad incorrecta para $departamento." }
        foreach ($fila in $filas) {
            if ($fila.Groups[1].Value -ne $departamento) { throw 'El filtro mezcló departamentos.' }
        }
        if ($filtrado -notmatch ('<option value="' + $departamento + '" selected="selected"')) {
            throw 'No se conservó la selección del filtro.'
        }
        if ($esperadas -eq 0 -and -not $filtrado.Contains('No se encontraron cargos')) {
            throw 'Falta el mensaje de lista vacía.'
        }
    }
    Test-Status ($client.GetAsync('cargos?filtro=NOEXISTE').GetAwaiter().GetResult()) 400 'departamento inexistente rechazado'
    Test-Status ($client.GetAsync('cargos?filtro=%27%20OR%201%3D1--').GetAwaiter().GetResult()) 400 'filtro manipulado rechazado'
    $restaurado = $client.GetAsync('cargos?filtro=').GetAwaiter().GetResult()
    Test-Status $restaurado 200 'todos los departamentos restaurados'
    if ([regex]::Matches($restaurado.Content.ReadAsStringAsync().GetAwaiter().GetResult(), '<tr data-departamento=').Count -ne [regex]::Matches($todos, '<tr data-departamento=').Count) {
        throw 'Ver todos no restauró los resultados.'
    }
    $departamentoTemporal = $null
    $codigoDepartamento = (0..99 | ForEach-Object { 'Z' + $_.ToString('D2') } | Where-Object { $_ -notin @($opciones | ForEach-Object { $_.Groups[1].Value }) } | Select-Object -First 1)
    if (-not $codigoDepartamento) { throw 'No hay departamento libre para la prueba temporal.' }
    $tokenCargo = Get-Token $listado
    try {
        Test-Status (Post-Form 'departamentos' @{modo='crear';codigo=$codigoDepartamento;descripcion='Prueba temporal cargos';__RequestVerificationToken=$tokenCargo}) 302 'departamento temporal para cargos creado'
        $departamentoTemporal=$codigoDepartamento
        $pagina = $client.GetAsync("cargos?filtro=$departamentoTemporal").GetAwaiter().GetResult()
        $vista = $pagina.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        if (-not $vista.Contains('Nuevo cargo') -or $vista -notmatch 'id="codigo" value="001"') { throw 'Falta el formulario o código inicial 001.' }
        Test-Status (Post-Form 'cargos' @{modo='crear';departamento=$departamentoTemporal;descripcion='sin token'}) 400 'crear cargo sin token rechazado'
        Test-Status (Post-Form 'cargos' @{modo='crear';departamento='INVALIDO';descripcion='no';__RequestVerificationToken=$tokenCargo}) 400 'departamento de cargo inválido rechazado'
        Test-Status (Post-Form 'cargos' @{modo='crear';departamento=$departamentoTemporal;descripcion=('a'*51);__RequestVerificationToken=$tokenCargo}) 400 'descripción de cargo larga rechazada'
        $nuevo = Post-Form 'cargos' @{modo='crear';departamento=$departamentoTemporal;codigo='999';descripcion='Cargo temporal';filtro=$departamentoTemporal;__RequestVerificationToken=$tokenCargo}
        Test-Status $nuevo 302 'cargo creado con código asignado por servidor'
        if (-not $nuevo.Headers.Location.ToString().Contains("filtro=$departamentoTemporal")) { throw 'Se perdió el filtro al guardar.' }
        $pagina = $client.GetAsync("cargos?filtro=$departamentoTemporal").GetAwaiter().GetResult()
        $vista = $pagina.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        if (-not $vista.Contains($departamentoTemporal+'001') -or $vista -notmatch 'id="codigo" value="002"') { throw 'El código correlativo no avanzó.' }
        Test-Status (Post-Form 'cargos' @{modo='crear';departamento=$departamentoTemporal;filtro=$departamentoTemporal;__RequestVerificationToken=$tokenCargo}) 302 'cargo con descripción opcional creado'
        $editar = $client.GetAsync("cargos?modo=editar&depto=$departamentoTemporal&codigo=001&filtro=$departamentoTemporal").GetAwaiter().GetResult()
        Test-Status $editar 200 'formulario de editar cargo'
        if (-not $editar.Content.ReadAsStringAsync().GetAwaiter().GetResult().Contains('Editar cargo')) { throw 'Falta formulario de edición.' }
        Test-Status (Post-Form 'cargos' @{modo='editar';departamento=$departamentoTemporal;codigo='001';descripcion='Cargo actualizado';filtro=$departamentoTemporal;__RequestVerificationToken=$tokenCargo}) 302 'cargo actualizado'
        $pagina = $client.GetAsync("cargos?filtro=$departamentoTemporal").GetAwaiter().GetResult()
        if (-not $pagina.Content.ReadAsStringAsync().GetAwaiter().GetResult().Contains('Cargo actualizado')) { throw 'La edición no se guardó.' }
        $confirmar = $client.GetAsync("cargos?modo=eliminar&depto=$departamentoTemporal&codigo=001&filtro=$departamentoTemporal").GetAwaiter().GetResult()
        Test-Status $confirmar 200 'confirmación previa a eliminar cargo'
        if (-not $confirmar.Content.ReadAsStringAsync().GetAwaiter().GetResult().Contains('Confirmar eliminación')) { throw 'Falta confirmación de eliminación.' }
        Test-Status (Post-Form 'cargos' @{modo='eliminar';departamento=$departamentoTemporal;codigo='001';filtro=$departamentoTemporal;__RequestVerificationToken=$tokenCargo}) 302 'cargo eliminado'
        Test-Status ($client.GetAsync("cargos?modo=editar&depto=$departamentoTemporal&codigo=001").GetAwaiter().GetResult()) 404 'cargo eliminado ya no existe'
        $restante = $client.GetAsync("cargos?modo=editar&depto=$departamentoTemporal&codigo=002").GetAwaiter().GetResult()
        Test-Status $restante 200 'el segundo cargo permanece'
    }
    finally {
        if ($departamentoTemporal) {
            foreach ($codigoCargo in @('001','002')) {
                $limpiezaCargo = Post-Form 'cargos' @{modo='eliminar';departamento=$departamentoTemporal;codigo=$codigoCargo;__RequestVerificationToken=$tokenCargo}
                if ([int]$limpiezaCargo.StatusCode -notin @(302,404)) { throw 'No se pudo limpiar un cargo temporal.' }
            }
            Test-Status (Post-Form 'departamentos' @{modo='eliminar';codigo=$departamentoTemporal;__RequestVerificationToken=$tokenCargo}) 302 'departamento temporal eliminado'
        }
    }
    Test-Pdf 'reporte?r=departamentos' 'departamentos'
    Test-Pdf 'reporte?r=cargos' 'cargos'
    Test-Pdf 'reporte?r=cargos&departamento=MED' 'cargos-MED'
    Test-Pdf 'reporte?r=cargos&departamento=SOP' 'cargos-vacio'
    Test-Pdf 'reporte?r=personas' 'personas'
    Test-Pdf 'reporte?r=ficha&codigo=PER-DEMO01' 'ficha-sin-foto'
    Test-Status ($client.GetAsync('reporte?r=noexiste').GetAwaiter().GetResult()) 404 'reporte desconocido rechazado'
    Test-Status ($client.GetAsync('reporte?r=ficha&codigo=ZZZ').GetAwaiter().GetResult()) 404 'ficha inexistente rechazada'
    Test-Status ($client.GetAsync('reporte?r=cargos&departamento=INVALIDO').GetAwaiter().GetResult()) 400 'filtro de reporte inválido rechazado'
    $personaTemporal = $null
    $marca = 'Tabpage' + [Guid]::NewGuid().ToString('N').Substring(0,8)
    $nueva = $client.GetAsync('persona?modo=nuevo&tab=identificacion').GetAwaiter().GetResult()
    Test-Status $nueva 200 'nueva ficha con pestañas'
    $fichaHtml = $nueva.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    if (-not $fichaHtml.Contains('role="tablist"') -or [regex]::Matches($fichaHtml, 'role="tabpanel"').Count -ne 2) { throw 'Faltan las dos pestañas.' }
    $datos = @{
        'Datos.Codigo'=''; 'Datos.Apellidos'=$marca; 'Datos.Nombres'='Prueba temporal';
        'Datos.Genero'='F'; 'Datos.EstadoCivil'='C'; 'Datos.FechaNacimiento'='2000-01-15';
        'Datos.CargasFamiliares'='2'; 'Datos.Discapacidad'='true';
        'Datos.TipoDocumento'='PASAPORTE'; 'Datos.Documento'='TESTTAB001'; 'Datos.Email'='tab@example.test';
        accion='guardar';tab='identificacion';__RequestVerificationToken=(Get-Token $nueva)
    }
    try {
        Test-Status (Post-Form 'persona' @{accion='guardar'}) 400 'persona sin token rechazada'
        $invalida = $datos.Clone(); $invalida['Datos.Documento']='!!!'
        $rechazada = Post-Form 'persona' $invalida
        Test-Status $rechazada 400 'documento inválido rechazado'
        if (-not $rechazada.Content.ReadAsStringAsync().GetAwaiter().GetResult().Contains('value="identificacion"')) { throw 'No se conserva la pestaña del error.' }
        $creada = Post-Form 'persona' $datos
        Test-Status $creada 302 'persona temporal creada'
        $lista = $client.GetAsync('persona?modo=listar').GetAwaiter().GetResult()
        Test-Status $lista 200 'personas listadas'
        $coincidencia = [regex]::Match($lista.Content.ReadAsStringAsync().GetAwaiter().GetResult(), '<th scope="row">(PER-[0-9]{6})</th><td>' + $marca + '</td>')
        $personaTemporal = $coincidencia.Groups[1].Value
        if (-not $personaTemporal) { throw 'No se encontró la persona creada.' }
        $ficha = $client.GetAsync("persona?codigo=$personaTemporal&tab=identificacion").GetAwaiter().GetResult()
        Test-Status $ficha 200 'persona seleccionada'
        $html = $ficha.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        if (-not $html.Contains('TESTTAB001') -or -not $html.Contains('value="identificacion"')) { throw 'Faltan los datos o la pestaña seleccionada.' }
        Test-Status ($client.GetAsync("persona/foto?codigo=$personaTemporal").GetAwaiter().GetResult()) 200 'foto predeterminada disponible'
        $datos['Datos.Codigo']=$personaTemporal
        $datos['Datos.Nombres']='Actualizada'
        $datos['Datos.TipoDocumento']='CEDULA'
        $datos['Datos.Documento']='1234567890'
        Test-Status (Post-Form 'persona' $datos) 302 'persona actualizada'
        $actual = $client.GetAsync("persona?codigo=$personaTemporal").GetAwaiter().GetResult()
        $html = $actual.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        if (-not $html.Contains('Actualizada') -or -not $html.Contains('1234567890') -or $html.Contains('TESTTAB001')) { throw 'No se actualizaron los datos.' }
        Test-Status (Post-PersonaFoto $datos ([byte[]](1,2,3,4))) 400 'foto falsa rechazada'
        Test-Status (Post-PersonaFoto $datos ([byte[]]::new(2 * 1024 * 1024 + 1))) 400 'foto mayor a 2 MB rechazada'
        Add-Type -AssemblyName System.Drawing
        $imagen = [System.Drawing.Bitmap]::new(8,8)
        $memoria = [System.IO.MemoryStream]::new()
        try {
            $grafico = [System.Drawing.Graphics]::FromImage($imagen)
            try { $grafico.Clear([System.Drawing.Color]::Teal) }
            finally { $grafico.Dispose() }
            $imagen.Save($memoria, [System.Drawing.Imaging.ImageFormat]::Png)
            Test-Status (Post-PersonaFoto $datos $memoria.ToArray()) 302 'foto PNG guardada'
        }
        finally { $imagen.Dispose(); $memoria.Dispose() }
        $fotoGuardada = $client.GetAsync("persona/foto?codigo=$personaTemporal").GetAwaiter().GetResult()
        Test-Status $fotoGuardada 200 'foto guardada recuperada'
        if ($fotoGuardada.Content.Headers.ContentType.MediaType -ne 'image/png') { throw 'No se recuperó la foto cargada.' }
        Test-Pdf "reporte?r=ficha&codigo=$personaTemporal" 'ficha-con-foto'
        Test-Status (Post-Form 'persona' $datos) 302 'actualización sin reemplazar la foto'
        $fotoConservada = $client.GetAsync("persona/foto?codigo=$personaTemporal").GetAwaiter().GetResult()
        if ($fotoConservada.Content.Headers.ContentType.MediaType -ne 'image/png') { throw 'Se perdió la foto al actualizar.' }
        foreach ($nav in @('primero','anterior','siguiente','ultimo')) {
            Test-Status ($client.GetAsync("persona?codigo=$personaTemporal&nav=$nav&tab=identificacion").GetAwaiter().GetResult()) 200 "navegación $nav"
        }
        $borrar = Post-Form 'persona' @{'Datos.Codigo'=$personaTemporal;accion='borrar';tab='generales';__RequestVerificationToken=(Get-Token $actual)}
        Test-Status $borrar 302 'persona temporal eliminada'
        Test-Status ($client.GetAsync("persona?codigo=$personaTemporal").GetAwaiter().GetResult()) 404 'persona eliminada ya no existe'
        $personaTemporal=$null
    }
    finally {
        if ($personaTemporal) {
            $limpieza = Post-Form 'persona' @{'Datos.Codigo'=$personaTemporal;accion='borrar';__RequestVerificationToken=$datos.__RequestVerificationToken}
            Test-Status $limpieza 302 'limpieza de persona temporal'
        }
    }
    Test-Status (Post-Form 'salir' @{__RequestVerificationToken=(Get-Token $inicio)}) 302 'cierre de sesión'
    Test-Status ($client.GetAsync('inicio').GetAwaiter().GetResult()) 302 'inicio protegido después de salir'
    Test-Status ($client.GetAsync('departamentos').GetAwaiter().GetResult()) 302 'departamentos protegidos después de salir'
    Test-Status ($client.GetAsync('cargos').GetAwaiter().GetResult()) 302 'cargos protegidos después de salir'
    Test-Status ($client.GetAsync('persona').GetAwaiter().GetResult()) 302 'personas protegidas después de salir'
    Test-Status ($client.GetAsync('reporte?r=personas').GetAwaiter().GetResult()) 302 'reportes protegidos después de salir'
}
finally { $client.Dispose(); $handler.Dispose() }
