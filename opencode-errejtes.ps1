# Opencode feladat-értesítő wrapper szkript
#
# Futtatja az `opencode` parancsot átadott argumentumokkal, és ha a feladat
# befejeződött, push értesítést küld az iPhone-ra az ntfy.sh szolgáltatáson keresztül.
#
# Használat:
#   ./opencode-errejtes.ps1 [opencode argumentumok]
#
# Beállítás előtt:
#   1. Telepítse az ntfy appot az iPhone-ra (App Store)
#   2. Feliratkozzon egy témára, pl. "ai-ertesites-opencode"
#   3. Állítsa be a NTFY_TOPIC környezeti változót a kívánt témára
#      (pl. $env:NTFY_TOPIC = "ai-ertesites-opencode")
#   4. Vagy szerkessze az alábbiany $defaultTopic változót

param(
    [Parameter(Mandatory=$false)]
    [string[]]$Args
)

# Alapértelmezett ntfy.sh téma - módosítsa igény szerint
$defaultTopic = "ai-ertesites-opencode"
$topic = $env:NTFY_TOPIC -ne $null -and $env:NTFY_TOPIC -ne "" ? $env:NTFY_TOPIC : $defaultTopic
$ntfyUrl = "https://ntfy.sh/$topic"

Write-Host "Opencode futtatása wrapper-rel..." -ForegroundColor Cyan
Write-Host "Értesítési téma: $topic" -ForegroundColor Cyan
Write-Host ""

# Opencode futtatása átadott argumentumokkal
$exitCode = 0
try {
    & opencode @Args
    $exitCode = $LASTEXITCODE
} catch {
    Write-Error "Az opencode futtatása során hiba történt: $_"
    $exitCode = 1
}

# Értesítés összeállítása a kilépési kód alapján
if ($exitCode -eq 0) {
    $title = "✅ Opencode feladat befejeződött"
    $message = "Az opencode parancs sikeresen lefutott."
    $priority = "default"
    $tags = "white_check_mark"
} else {
    $title = "❌ Opencode feladat hibával végződött"
    $message = "Az opencode parancs kilépési kódja: $exitCode"
    $priority = "high"
    $tags = "warning"
}

Write-Host ""
Write-Host "Kilépési kód: $exitCode" -ForegroundColor Cyan

# Push értesítés küldése ntfy.sh-en keresztül
try {
    $body = @{
        title   = $title
        message = $message
        priority = $priority
        tags    = $tags
    } | ConvertTo-Json -Depth 3

    $response = Invoke-RestMethod -Uri $ntfyUrl -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
    Write-Host "Push értesítés elküldve az iPhone-ra." -ForegroundColor Green
} catch {
    Write-Warning "Push értesítés küldése sikertelen: $_"
    Write-Host "Győződjön meg arról, hogy az ntfy app fut az iPhone-on és feliratkozott a témára: $topic" -ForegroundColor Yellow
}

exit $exitCode
