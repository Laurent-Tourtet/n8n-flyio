# Script de déploiement initial pour n8n sur Fly.io
# Usage: .\deploy.ps1

param(
    [string]$AppName = "n8n-laurent",
    [string]$Region = "cdg"
)

Write-Host "🚀 Déploiement de n8n sur Fly.io" -ForegroundColor Cyan
Write-Host ""

# Vérifier si flyctl est installé
if (-not (Get-Command fly -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Flyctl n'est pas installé. Installez-le depuis: https://fly.io/docs/hands-on/install-flyctl/" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Flyctl détecté" -ForegroundColor Green

# Vérifier l'authentification
Write-Host "Vérification de l'authentification..." -ForegroundColor Yellow
fly auth whoami
if ($LASTEXITCODE -ne 0) {
    Write-Host "Veuillez vous connecter à Fly.io:" -ForegroundColor Yellow
    fly auth login
}

# Vérifier si le volume existe
Write-Host ""
Write-Host "Vérification du volume de données..." -ForegroundColor Yellow
$volumeExists = fly volumes list --app $AppName 2>$null | Select-String "n8n_data"

if (-not $volumeExists) {
    Write-Host "Création du volume n8n_data..." -ForegroundColor Yellow
    fly volumes create n8n_data --size 1 --region $Region --app $AppName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Volume créé avec succès" -ForegroundColor Green
    } else {
        Write-Host "❌ Erreur lors de la création du volume" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✓ Volume n8n_data existe déjà" -ForegroundColor Green
}

# Vérifier les secrets
Write-Host ""
Write-Host "Vérification des secrets..." -ForegroundColor Yellow
$secrets = fly secrets list --app $AppName 2>$null

if (-not ($secrets | Select-String "N8N_ENCRYPTION_KEY")) {
    Write-Host "⚠️  La clé de chiffrement n'est pas définie" -ForegroundColor Yellow
    $setEncryption = Read-Host "Voulez-vous définir une clé de chiffrement maintenant? (O/N)"
    
    if ($setEncryption -eq "O" -or $setEncryption -eq "o") {
        # Générer une clé aléatoire
        $bytes = New-Object byte[] 32
        [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
        $encryptionKey = [BitConverter]::ToString($bytes).Replace("-", "").ToLower()
        
        fly secrets set N8N_ENCRYPTION_KEY=$encryptionKey --app $AppName
        Write-Host "✓ Clé de chiffrement définie" -ForegroundColor Green
    }
}

if (-not ($secrets | Select-String "N8N_BASIC_AUTH_ACTIVE")) {
    Write-Host ""
    Write-Host "⚠️  L'authentification basique n'est pas configurée" -ForegroundColor Yellow
    $setAuth = Read-Host "Voulez-vous configurer l'authentification maintenant? (O/N)"
    
    if ($setAuth -eq "O" -or $setAuth -eq "o") {
        $username = Read-Host "Nom d'utilisateur"
        $password = Read-Host "Mot de passe" -AsSecureString
        $passwordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
        
        fly secrets set N8N_BASIC_AUTH_ACTIVE=true --app $AppName
        fly secrets set N8N_BASIC_AUTH_USER=$username --app $AppName
        fly secrets set N8N_BASIC_AUTH_PASSWORD=$passwordPlain --app $AppName
        
        Write-Host "✓ Authentification configurée" -ForegroundColor Green
    }
}

# Déploiement
Write-Host ""
Write-Host "🚀 Déploiement de l'application..." -ForegroundColor Cyan
fly deploy --app $AppName

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Déploiement réussi!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Votre instance n8n est accessible à:" -ForegroundColor Cyan
    Write-Host "https://$AppName.fly.dev" -ForegroundColor White
    Write-Host ""
    Write-Host "Commandes utiles:" -ForegroundColor Yellow
    Write-Host "  fly logs --app $AppName           # Voir les logs"
    Write-Host "  fly open --app $AppName           # Ouvrir dans le navigateur"
    Write-Host "  fly ssh console --app $AppName    # SSH dans le container"
    Write-Host "  fly status --app $AppName         # Voir le statut"
} else {
    Write-Host ""
    Write-Host "❌ Erreur lors du déploiement" -ForegroundColor Red
    Write-Host "Consultez les logs avec: fly logs --app $AppName" -ForegroundColor Yellow
    exit 1
}
