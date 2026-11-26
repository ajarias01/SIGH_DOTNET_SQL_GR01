$ErrorActionPreference = 'Stop'
$proyecto = Split-Path -Parent $PSScriptRoot
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (-not (Test-Path -LiteralPath $vswhere)) {
    throw 'No se encontró Visual Studio Installer (vswhere.exe).'
}
$instalacion = & $vswhere -latest -prerelease -products '*' -requires Microsoft.VisualStudio.Component.Web -property installationPath
if (-not $instalacion) { throw 'Instala Visual Studio con el componente de desarrollo web.' }
$msbuild = Join-Path $instalacion 'MSBuild\Current\Bin\MSBuild.exe'
$compilador = Join-Path $instalacion 'MSBuild\Current\Bin\Roslyn\csc.exe'
& $msbuild (Join-Path $proyecto 'SighDotNet.csproj') /t:Build /p:Configuration=Debug /verbosity:minimal /nologo
if ($LASTEXITCODE -ne 0) { throw 'No se pudo compilar el proyecto.' }

$salida = Join-Path $proyecto 'obj\PruebasSqlServer'
New-Item -ItemType Directory -Path $salida -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $proyecto 'bin\SighDotNet.dll') -Destination $salida
Copy-Item -LiteralPath (Join-Path $proyecto 'Web.config') -Destination (Join-Path $salida 'Pruebas.exe.config')
$ejecutable = Join-Path $salida 'Pruebas.exe'
& $compilador /nologo /target:exe "/out:$ejecutable" /reference:System.Configuration.dll /reference:System.Data.dll "/reference:$salida\SighDotNet.dll" (Join-Path $PSScriptRoot 'AutenticacionBD.Integracion.cs')
if ($LASTEXITCODE -ne 0) { throw 'No se pudieron compilar las pruebas.' }
& $ejecutable
if ($LASTEXITCODE -ne 0) { throw 'Fallaron las pruebas de integración.' }
