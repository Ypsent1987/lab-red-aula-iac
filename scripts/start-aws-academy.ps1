# ============================================================
# AWS Academy - Preparacion de sesion local
# Laboratorio Red Aula IaC
#
# Uso:
# 1. Iniciar AWS Academy Learner Lab.
# 2. Ir a AWS Details / AWS CLI / Show.
# 3. Copiar el bloque COMPLETO de credenciales.
# 4. Ejecutar este script en la terminal actual:
#
#    Set-ExecutionPolicy -Scope Process Bypass -Force
#    . .\scripts\start-aws-academy.ps1
#
# IMPORTANTE:
# - No guarda credenciales en archivos.
# - No modifica provider.tf.
# - No ejecuta aws configure.
# - Las credenciales existen solo en esta sesion de terminal.
# ============================================================

$previousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Stop"

try {

    Write-Host ""
    Write-Host "==============================================="
    Write-Host " AWS Academy - Preparacion de sesion local"
    Write-Host "==============================================="
    Write-Host ""

    # --------------------------------------------------------
    # 1. Priorizar AWS CLI instalada para el usuario
    # --------------------------------------------------------

    $awsCliUserPath = Join-Path `
        $env:LOCALAPPDATA `
        "Programs\Amazon\AWSCLIV2"

    $awsCliUserExe = Join-Path `
        $awsCliUserPath `
        "aws.exe"

    if (Test-Path $awsCliUserExe) {

        $currentPathEntries = $env:PATH -split ";"

        if ($currentPathEntries -notcontains $awsCliUserPath) {
            $env:PATH = "$awsCliUserPath;$env:PATH"
        }

        Write-Host "AWS CLI local encontrada."
    }
    else {
        Write-Host "Usando AWS CLI disponible en PATH."
    }

    # Comprobar que aws exista
    $awsCommand = Get-Command aws -ErrorAction SilentlyContinue

    if (-not $awsCommand) {
        throw "AWS CLI no esta disponible. Instale AWS CLI v2 antes de continuar."
    }

    Write-Host -NoNewline "AWS CLI: "
    aws --version
    Write-Host ""

    # --------------------------------------------------------
    # 2. Leer bloque AWS Academy desde el portapapeles
    # --------------------------------------------------------
Write-Host "Abra AWS Academy Learner Lab."
Write-Host ""
Write-Host "Vaya a:"
Write-Host "AWS Details -> AWS CLI -> Show"
Write-Host ""
Write-Host "Copie el BLOQUE COMPLETO de credenciales."
Write-Host ""
Read-Host "Cuando ya lo haya copiado, presione ENTER para continuar"

    $clipboard = Get-Clipboard -Raw

    if ([string]::IsNullOrWhiteSpace($clipboard)) {
        throw @"
El portapapeles esta vacio.

Copie primero el bloque completo desde:
AWS Academy -> AWS Details -> AWS CLI -> Show
"@
    }

    # Reemplazar espacio no separable por espacio normal
    $clipboard = $clipboard -replace [char]0x00A0, " "

    # --------------------------------------------------------
    # 3. Funcion para extraer credenciales
    # --------------------------------------------------------

    function Get-AwsCredentialValue {

        param(
            [Parameter(Mandatory = $true)]
            [string[]]$Names
        )

        $lines = $clipboard -split "`r?`n"

        foreach ($line in $lines) {

            $cleanLine = $line.Trim()

            if ([string]::IsNullOrWhiteSpace($cleanLine)) {
                continue
            }

            # Ignorar encabezados como [default]
            if ($cleanLine -match '^\s*\[.+\]\s*$') {
                continue
            }

            # Formato Linux/macOS:
            # export AWS_ACCESS_KEY_ID=...
            $cleanLine = $cleanLine -replace `
                '^(?i:export)\s+', `
                ''

            # Formato CMD:
            # set AWS_ACCESS_KEY_ID=...
            $cleanLine = $cleanLine -replace `
                '^(?i:set)\s+', `
                ''

            # Formato PowerShell:
            # $env:AWS_ACCESS_KEY_ID=...
            $cleanLine = $cleanLine -replace `
                '^(?i:\$env:)', `
                ''

            foreach ($name in $Names) {

                $escapedName = [regex]::Escape($name)

                $match = [regex]::Match(
                    $cleanLine,
                    "^\s*$escapedName\s*=\s*(.+?)\s*$",
                    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
                )

                if ($match.Success) {

                    $value = $match.Groups[1].Value.Trim()

                    # Eliminar ; final si existe
                    $value = $value.TrimEnd(";").Trim()

                    # Eliminar comillas externas
                    if (
                        ($value.StartsWith('"') -and $value.EndsWith('"')) -or
                        ($value.StartsWith("'") -and $value.EndsWith("'"))
                    ) {
                        if ($value.Length -ge 2) {
                            $value = $value.Substring(
                                1,
                                $value.Length - 2
                            )
                        }
                    }

                    return $value.Trim()
                }
            }
        }

        return $null
    }

    # --------------------------------------------------------
    # 4. Extraer las tres credenciales temporales
    # --------------------------------------------------------

    $accessKey = Get-AwsCredentialValue -Names @(
        "AWS_ACCESS_KEY_ID",
        "aws_access_key_id"
    )

    $secretKey = Get-AwsCredentialValue -Names @(
        "AWS_SECRET_ACCESS_KEY",
        "aws_secret_access_key"
    )

    $sessionToken = Get-AwsCredentialValue -Names @(
        "AWS_SESSION_TOKEN",
        "aws_session_token"
    )

    if (
        [string]::IsNullOrWhiteSpace($accessKey) -or
        [string]::IsNullOrWhiteSpace($secretKey) -or
        [string]::IsNullOrWhiteSpace($sessionToken)
    ) {
        throw @"
No se encontraron las tres credenciales temporales.

Copie nuevamente el bloque COMPLETO desde:
AWS Academy -> AWS Details -> AWS CLI -> Show

El script acepta formatos como:

[default]
aws_access_key_id=...
aws_secret_access_key=...
aws_session_token=...

o:

export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
"@
    }

    # --------------------------------------------------------
    # 5. Cargar credenciales SOLO en esta sesion
    # --------------------------------------------------------

    $env:AWS_ACCESS_KEY_ID = $accessKey
    $env:AWS_SECRET_ACCESS_KEY = $secretKey
    $env:AWS_SESSION_TOKEN = $sessionToken

    $env:AWS_REGION = "us-east-1"
    $env:AWS_DEFAULT_REGION = "us-east-1"

    # Eliminar variables auxiliares con secretos
    $accessKey = $null
    $secretKey = $null
    $sessionToken = $null
    $clipboard = $null

    # --------------------------------------------------------
    # 6. Limpiar portapapeles
    # --------------------------------------------------------

try {
    Set-Clipboard -Value ([string]::Empty)
    Write-Host "Portapapeles limpiado."
}
catch {
    try {
        cmd.exe /c "echo.|clip"
        Write-Host "Portapapeles limpiado."
    }
    catch {
        Write-Warning "No fue posible limpiar automaticamente el portapapeles. Limpielo manualmente antes de continuar."
    }
}

    Write-Host ""
    Write-Host "Credenciales temporales cargadas."
    Write-Host "Region configurada: $env:AWS_REGION"
    Write-Host ""

    # --------------------------------------------------------
    # 7. Validar autenticacion sin mostrar credenciales
    # --------------------------------------------------------

    Write-Host "Verificando conexion con AWS Academy..."
    Write-Host ""

    $stsResult = & aws sts get-caller-identity --output json 2>&1
    $stsExitCode = $LASTEXITCODE

    if ($stsExitCode -ne 0) {

        Write-Host "AWS devolvio un error:"
        Write-Host ""

        $stsResult | ForEach-Object {
            Write-Host $_
        }

        Write-Host ""

        throw @"
La autenticacion no pudo validarse.

Si la sesion de AWS Academy cambio o expiro:
1. Abra nuevamente AWS CLI -> Show.
2. Copie el nuevo bloque completo.
3. Ejecute otra vez este script.
"@
    }

    # --------------------------------------------------------
    # 8. Resultado exitoso
    # --------------------------------------------------------

    Write-Host "==============================================="
    Write-Host " SESION AWS ACADEMY VALIDADA CORRECTAMENTE"
    Write-Host "==============================================="
    Write-Host ""

    Write-Host "AWS CLI       : disponible"
    Write-Host "Autenticacion : valida"
    Write-Host "Region         : $env:AWS_REGION"
    Write-Host ""
    Write-Host "La terminal esta lista para AWS CLI y Terraform."
    Write-Host ""
}
catch {

    Write-Host ""
    Write-Host "==============================================="
    Write-Host " NO FUE POSIBLE PREPARAR LA SESION"
    Write-Host "==============================================="
    Write-Host ""
    Write-Host $_.Exception.Message
    Write-Host ""

}
finally {

    # Restaurar comportamiento original de PowerShell.
    $ErrorActionPreference = $previousErrorActionPreference
}