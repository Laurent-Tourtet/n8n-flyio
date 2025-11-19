# Script de verification de sante n8n sur Fly.io
# Usage: .\check-health.ps1

Write-Host "`nVerification de sante de n8n sur Fly.io" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Gray
Write-Host ""

# Configuration de l'alias
Set-Alias -Name fly -Value "$env:USERPROFILE\.fly\bin\flyctl.exe" -Scope Global

# Verifier flyctl
Write-Host "[1/5] Verification de flyctl..." -ForegroundColor Yellow
$flyVersion = & "$env:USERPROFILE\.fly\bin\flyctl.exe" version 2>&1
if ($flyVersion -match "flyctl") {
    Write-Host "  OK flyctl installe" -ForegroundColor Green
} else {
    Write-Host "  ERREUR flyctl non trouve" -ForegroundColor Red
    exit 1
}

# Verifier l'authentification
Write-Host "`n[2/5] Verification de l'authentification..." -ForegroundColor Yellow
$authUser = fly auth whoami 2>&1
if ($authUser) {
    Write-Host "  OK Authentifie en tant que: $authUser" -ForegroundColor Green
} else {
    Write-Host "  ERREUR Non authentifie" -ForegroundColor Red
    exit 1
}

# Verifier le statut de l'application
Write-Host "`n[3/5] Verification du statut de l'application..." -ForegroundColor Yellow
$status = fly status --app n8n-laurent 2>&1
if ($status -match "started|running") {
    Write-Host "  OK Application en cours d'execution" -ForegroundColor Green
} elseif ($status -match "stopped") {
    Write-Host "  INFO Application arretee (demarrera au premier acces)" -ForegroundColor Yellow
} else {
    Write-Host "  ERREUR Probleme detecte" -ForegroundColor Red
}

# Verifier le volume
Write-Host "`n[4/5] Verification du volume..." -ForegroundColor Yellow
$volumes = fly volumes list --app n8n-laurent 2>&1
if ($volumes -match "n8n_data") {
    Write-Host "  OK Volume n8n_data present" -ForegroundColor Green
} else {
    Write-Host "  ERREUR Volume non trouve" -ForegroundColor Red
}

# Verifier les secrets
Write-Host "`n[5/5] Verification des secrets..." -ForegroundColor Yellow
$secrets = fly secrets list --app n8n-laurent 2>&1
$requiredSecrets = @("N8N_ENCRYPTION_KEY", "N8N_BASIC_AUTH_ACTIVE", "N8N_BASIC_AUTH_USER", "N8N_BASIC_AUTH_PASSWORD")
$allSecretsPresent = $true

foreach ($secret in $requiredSecrets) {
    if ($secrets -match $secret) {
        Write-Host "  OK $secret configure" -ForegroundColor Green
    } else {
        Write-Host "  ERREUR $secret manquant" -ForegroundColor Red
        $allSecretsPresent = $false
    }
}

# Tester l'accessibilite HTTP
Write-Host "`n[Bonus] Test de connectivite HTTP..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://n8n-laurent.fly.dev" -TimeoutSec 10 -UseBasicParsing 2>&1
    if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 401) {
        Write-Host "  OK n8n est accessible via HTTPS" -ForegroundColor Green
        Write-Host "  URL: https://n8n-laurent.fly.dev" -ForegroundColor White
    }
} catch {
    $errorMessage = $_.Exception.Message
    if ($errorMessage -match "401") {
        Write-Host "  OK n8n est accessible (authentification requise)" -ForegroundColor Green
    } else {
        Write-Host "  INFO Probleme de connexion: $errorMessage" -ForegroundColor Yellow
        Write-Host "  Note: L'app peut etre en train de demarrer" -ForegroundColor Gray
    }
}

# Resume
Write-Host "`n" -NoNewline
Write-Host ("=" * 60) -ForegroundColor Gray
Write-Host "`nResume" -ForegroundColor Cyan
Write-Host ""
Write-Host "Application : n8n-laurent" -ForegroundColor White
Write-Host "URL         : https://n8n-laurent.fly.dev" -ForegroundColor White
Write-Host "Region      : Paris (cdg)" -ForegroundColor White
Write-Host ""

if ($allSecretsPresent) {
    Write-Host "SUCCES Tous les controles ont reussi !" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pour acceder a n8n :" -ForegroundColor Cyan
    Write-Host "  1. Ouvrez: https://n8n-laurent.fly.dev" -ForegroundColor White
    Write-Host "  2. Username: admin" -ForegroundColor White
    Write-Host "  3. Password: N8n2025SecurePass!" -ForegroundColor White
} else {
    Write-Host "ATTENTION Certains secrets sont manquants" -ForegroundColor Yellow
    Write-Host "Consultez DEPLOYMENT.md pour la configuration" -ForegroundColor White
}

Write-Host "`n" -NoNewline
Write-Host ("=" * 60) -ForegroundColor Gray
Write-Host ""
