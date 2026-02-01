# PowerShell script to install Nerd Fonts on Windows from WSL
# Installs fonts at user-level (no admin required)

param(
    [string]$FontsPath = "$env:USERPROFILE\Downloads\NerdFonts_Zsh_Setup"
)

Write-Host "==================================="
Write-Host "Windows Nerd Fonts Installer"
Write-Host "==================================="
Write-Host ""

# Verifica che la directory esista
if (-not (Test-Path $FontsPath)) {
    Write-Host "Errore: Directory $FontsPath non trovata" -ForegroundColor Red
    exit 1
}

# Directory font utente (no admin)
$userFontsDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

# Crea directory se non esiste
if (-not (Test-Path $userFontsDir)) {
    New-Item -Path $userFontsDir -ItemType Directory -Force | Out-Null
}

# Trova tutti i font
$fonts = Get-ChildItem -Path $FontsPath -Include *.ttf,*.otf -Recurse -File
$totalFonts = $fonts.Count
$installedCount = 0
$skippedCount = 0
$errorCount = 0

Write-Host "Trovati $totalFonts font da installare..."
Write-Host ""

foreach ($font in $fonts) {
    $fontName = $font.Name
    $fontBaseName = $font.BaseName
    $fontDestination = Join-Path $userFontsDir $fontName

    try {
        # Controlla se già installato nel registry
        $existingFont = Get-ItemProperty -Path $registryPath -Name "*$fontBaseName*" -ErrorAction SilentlyContinue

        if ($existingFont -and (Test-Path $fontDestination)) {
            Write-Host "[SKIP] $fontName (già installato)" -ForegroundColor Yellow
            $skippedCount++
        } else {
            # Copia font nella directory utente
            Copy-Item -Path $font.FullName -Destination $fontDestination -Force

            # Registra nel Registry (usa il nome del file come chiave)
            $registryName = "$fontBaseName (TrueType)"
            if ($font.Extension -eq ".otf") {
                $registryName = "$fontBaseName (OpenType)"
            }

            New-ItemProperty -Path $registryPath `
                             -Name $registryName `
                             -Value $fontName `
                             -PropertyType String `
                             -Force | Out-Null

            Write-Host "[OK] $fontName" -ForegroundColor Green
            $installedCount++
        }
    } catch {
        Write-Host "[ERROR] $fontName : $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
Write-Host "==================================="
Write-Host "Installazione completata!"
Write-Host "==================================="
Write-Host "Installati: $installedCount" -ForegroundColor Green
Write-Host "Saltati:    $skippedCount" -ForegroundColor Yellow
Write-Host "Errori:     $errorCount" -ForegroundColor Red
Write-Host ""
Write-Host "NOTA: Riavvia Windows Terminal per vedere i nuovi font!" -ForegroundColor Cyan
Write-Host ""
