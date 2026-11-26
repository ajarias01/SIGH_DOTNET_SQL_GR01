# SIGH GR01 en .NET

Aplicación unificada ASP.NET MVC 5 sobre .NET Framework 4.7.2 con login del subsistema de Seguridad y CRUD de departamentos del subsistema de Personal.

## Abrir y ejecutar

Abre `SIGH_DOTNET_GR01.slnx` en Visual Studio Insiders, o abre `SighDotNet.csproj`. Requiere el componente de desarrollo web, .NET Framework 4.7.2 Developer Pack e IIS Express. Restaura NuGet si falta alguna dependencia y ejecuta con F5. La dirección configurada es `http://localhost:5080/`.

La carpeta contiene un único proyecto con `Controllers`, `Models`, `Views`, `Content`, `Scripts`, `Resources` y `App_Data`. Ambos módulos comparten la conexión `SighBD` de `Web.config` y una cookie de autenticación de 20 minutos.

## Base de datos

En SQL Server usa `sigh_gr01`. Si necesitas preparar la base, ejecuta desde SSMS, en este orden, `App_Data/sigh_gr01_login_sqlserver.sql` y `App_Data/sigh_gr01_departamentos_sqlserver.sql`. Los scripts conservan las tablas y cuentas existentes. El script de departamentos carga los datos iniciales solo al crear la tabla.

Configura `Data Source` en `Web.config` con tu instancia. La configuración actual usa autenticación de Windows. El usuario que ejecuta IIS Express necesita acceso a la base.

El acceso conserva la verificación PBKDF2 de `XEUSU_USUAR`, con las columnas `XEUSU_LOGIN`, `XEUSU_SALT` y `XEUSU_PASWD` del login .NET anterior. El catálogo conserva las consultas parametrizadas de `PEDEP_DEPAR` del CRUD .NET anterior.

## Recorrido

1. Abre `/` e inicia sesión. La cuenta de prueba preparada por el script es `sullivan` con contraseña `Sulley2026!`.
2. En `/inicio`, selecciona «Administrar departamentos».
3. En `/departamentos` puedes listar, crear, editar y eliminar con confirmación. El código admite de uno a tres caracteres alfanuméricos y la descripción es opcional, hasta 50 caracteres.
4. Usa «Inicio» para volver o «Cerrar sesión» para salir. El acceso directo a departamentos y sus operaciones requiere autenticación.

## Verificar

Con IIS Express y SQL Server disponibles, ejecuta `Tests/Probar-Web.ps1`. Revisa login, navegación al catálogo, protección de operaciones, validación y cierre de sesión. Las pruebas de mantenimiento crean registros temporales y los eliminan al terminar. Para una dirección distinta, pasa `-Url http://localhost:PUERTO/`.

La referencia Java del RAR incluye además cargos, personas, fotos y reportes. La aplicación incorpora además el mantenimiento de cargos con filtro por departamento. La ficha de personas con pestañas y fotos también está incorporada.

## Cargos y filtro por departamento

Desde Inicio selecciona «Consultar cargos por departamento» para abrir `/cargos`. La pantalla sigue la referencia Java, con el catálogo y su filtro a la izquierda y el formulario de mantenimiento a la derecha. El selector es desplegable y aplica el filtro al cambiar la selección. Sin JavaScript se usa el botón Filtrar.

Selecciona el departamento en «Nuevo cargo» para ver el siguiente código. El servidor asigna el correlativo de tres cifras al guardar dentro de una transacción, desde `001` en cada departamento. La vista previa puede cambiar si otro usuario registra un cargo antes. La descripción es opcional y admite hasta 50 caracteres. Editar conserva el departamento y código del registro, y permite actualizar su descripción. Eliminar abre una confirmación y respeta las relaciones de SQL Server. Se conserva el filtro al guardar, cancelar y navegar entre operaciones.

Ejecuta `App_Data/sigh_gr01_cargos_sqlserver.sql` después del script de departamentos para preparar una base nueva. Las consultas usan parámetros y el acceso al catálogo y sus operaciones requiere sesión. La opción «Todos los departamentos» restaura el listado completo y el botón Reporte PDF mantiene el filtro seleccionado.

## TABPAGE · Ficha de personas

En Inicio selecciona «Mantenimiento de personal» para abrir `/persona`. La cabecera mantiene código, apellidos, nombres y foto visibles. Las pestañas «Datos generales» e «Identificación y contacto» organizan los demás datos. Se pueden activar con el ratón o con las flechas, Inicio y Fin del teclado. La pestaña activa se conserva durante la navegación y ante errores de validación. Sin JavaScript, ambos grupos permanecen visibles.

Pulsa «Nuevo» para habilitar una ficha vacía o «Listar» para seleccionar una persona. «Guardar» crea un código `PER-000001` correlativo dentro de una transacción. «Actualizar» guarda ambas pestañas. «Borrar» pide confirmación y respeta las relaciones con otras tablas. Primero, Anterior, Siguiente y Último permiten recorrer los registros por código.

Ejecuta `App_Data/sigh_gr01_personas_sqlserver.sql` después del script de login al preparar la base. Agrega solo los valores faltantes de sexo y estado civil del DML. Se reutiliza `PEPER_PERSO` con la columna `PEESC_CODIGO` de la base actual.

Las fotos admiten PNG/JPG de hasta 2 MB y 4000 × 4000 píxeles. Se valida su contenido y se almacenan con nombres aleatorios en `App_Data/Fotos`, servidas por una acción que exige sesión. Una actualización sin foto conserva la anterior. Las fotos históricas de otra instalación deben migrarse junto con sus archivos para mostrarlas. La ficha usa un avatar cuando no encuentra una foto disponible. Incluye `App_Data/Fotos` en los respaldos junto con SQL Server.

`Tests/Probar-Web.ps1` comprueba ahora también crear, listar, seleccionar, actualizar, navegar y eliminar una persona temporal. Verifica documentos y fotos inválidas, tamaño máximo, carga y conservación de foto, y acceso protegido. La persona temporal se elimina al terminar.

## Reportes RDLC con SQL Server

Los cuatro reportes se generan como PDF desde la acción MVC `/reporte` con Microsoft ReportViewer en modo local. Requieren sesión. Reutilizan las consultas parametrizadas de los módulos existentes y la conexión `SighBD`. No necesitan un servidor de Reporting Services.

- Departamentos, botón «Reporte PDF» en el catálogo. Incluye código, descripción y total.
- Cargos, botón «Reporte PDF» en la consulta. Respeta el departamento seleccionado en el filtro, agrupa por departamento y muestra subtotales y total.
- Personas, botón «Listado PDF» en mantenimiento. Incluye los datos de identificación, sexo, estado civil y nacimiento, ordenados por apellidos y nombres. Formato A4 horizontal.
- Ficha, enlace «Imprimir ficha PDF» al seleccionar una persona. Incluye sus datos, foto disponible y espacios para firmas. Formato A4 vertical.

Los documentos muestran fecha y hora de Ecuador, usuario que genera el reporte y numeración de páginas. Los PDF se abren en otra pestaña del navegador y permiten guardar o imprimir desde su visor. Un departamento válido sin cargos genera el mensaje «No hay datos para mostrar» y total cero. Una ficha inexistente devuelve 404 y un filtro de departamento inválido devuelve 400.

Las plantillas editables están en `Reportes/Departamentos.rdlc`, `Cargos.rdlc`, `Personas.rdlc` y `FichaPersona.rdlc`. Para editarlas visualmente, instala la extensión **Microsoft RDLC Report Designer 2022+** compatible con tu versión de Visual Studio desde [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ProBITools.MicrosoftRdlcReportDesignerforVisualStudio2022). Las plantillas ya incluidas funcionan sin instalar el diseñador.

Se agregaron los paquetes oficiales `Microsoft.ReportingServices.ReportViewerControl.WebForms` 150.1781.0 y su dependencia `Microsoft.SqlServer.Types` 14.0.1016.290 a `packages.config`. En otro equipo, restaura los paquetes NuGet antes de compilar. Las referencias se resuelven desde la carpeta `packages` del proyecto. Incluye las plantillas RDLC al publicar la aplicación.

Las fotos del reporte se cargan únicamente desde `App_Data/Fotos` con el nombre validado que usa la ficha. La imagen se incorpora a los datos del reporte, sin aceptar rutas externas de la solicitud. Cuando no hay una foto disponible, se indica «Sin foto registrada».

La prueba `Tests/Probar-Web.ps1` verifica los reportes generales, el filtro MED, el caso vacío SOP, la ficha con y sin foto, los parámetros inválidos y el acceso protegido. Guarda los PDF de prueba en `obj/PruebasReportes`. Los casos MED, SOP y PER-DEMO01 corresponden a la base de desarrollo del proyecto.
