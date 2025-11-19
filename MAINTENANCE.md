# Maintenance n8n sur Fly.io

## Configuration Fly.io Helper

Pour faciliter l'utilisation de flyctl dans PowerShell, ajoutez cet alias au début de chaque session :

```powershell
Set-Alias -Name fly -Value "$env:USERPROFILE\.fly\bin\flyctl.exe" -Scope Global
```

Ou ajoutez-le à votre profil PowerShell de façon permanente :

```powershell
Add-Content $PROFILE "`nSet-Alias -Name fly -Value `"$env:USERPROFILE\.fly\bin\flyctl.exe`""
```

## Tâches courantes

### Redéployer après modifications

```powershell
fly deploy --app n8n-laurent
```

### Changer le mot de passe administrateur

```powershell
fly secrets set N8N_BASIC_AUTH_PASSWORD=NouveauMotDePasse --app n8n-laurent
```

### Ajouter un utilisateur différent

```powershell
fly secrets set N8N_BASIC_AUTH_USER=nouveauuser --app n8n-laurent
fly secrets set N8N_BASIC_AUTH_PASSWORD=nouveaupass --app n8n-laurent
```

### Augmenter la mémoire (si nécessaire)

```powershell
fly scale memory 2048 --app n8n-laurent
```

### Augmenter le volume de stockage

```powershell
fly volumes extend vol_4m893nldxyjp6g3r --size 3 --app n8n-laurent
```

### Sauvegarder les données

```powershell
# Se connecter en SSH
fly ssh console --app n8n-laurent

# Dans le container, créer une sauvegarde
tar -czf /tmp/n8n-backup.tar.gz /data

# Depuis PowerShell, récupérer la sauvegarde
fly ssh sftp get /tmp/n8n-backup.tar.gz ./n8n-backup-$(Get-Date -Format 'yyyy-MM-dd').tar.gz --app n8n-laurent
```

### Restaurer des données

```powershell
# Envoyer la sauvegarde
fly ssh sftp shell --app n8n-laurent
put n8n-backup.tar.gz /tmp/

# Se connecter en SSH et restaurer
fly ssh console --app n8n-laurent
tar -xzf /tmp/n8n-backup.tar.gz -C /
```

### Activer PostgreSQL (recommandé pour la production)

```powershell
# Créer une base de données
fly postgres create --name n8n-db --region cdg

# Attacher à l'app
fly postgres attach n8n-db --app n8n-laurent

# Configurer n8n
fly secrets set DB_TYPE=postgresdb --app n8n-laurent
fly secrets set DB_POSTGRESDB_DATABASE=n8n --app n8n-laurent
fly secrets set DB_POSTGRESDB_HOST=n8n-db.internal --app n8n-laurent
fly secrets set DB_POSTGRESDB_PORT=5432 --app n8n-laurent

# Redéployer
fly deploy --app n8n-laurent
```

### Configurer les emails SMTP (notifications)

```powershell
fly secrets set N8N_EMAIL_MODE=smtp --app n8n-laurent
fly secrets set N8N_SMTP_HOST=smtp.gmail.com --app n8n-laurent
fly secrets set N8N_SMTP_PORT=587 --app n8n-laurent
fly secrets set N8N_SMTP_USER=votre-email@gmail.com --app n8n-laurent
fly secrets set N8N_SMTP_PASS=votre-mot-de-passe-app --app n8n-laurent
fly secrets set N8N_SMTP_SENDER=votre-email@gmail.com --app n8n-laurent
```

### Mettre à jour n8n vers la dernière version

```powershell
# Le Dockerfile utilise déjà :latest, il suffit de redéployer
fly deploy --app n8n-laurent
```

### Surveiller les performances

```powershell
# Métriques en temps réel
fly dashboard --app n8n-laurent

# Utilisation des ressources
fly machine status 874de7f0615638 --app n8n-laurent
```

### Dépannage

```powershell
# Logs en temps réel
fly logs --app n8n-laurent -f

# SSH dans le container
fly ssh console --app n8n-laurent

# Redémarrer la machine
fly machine restart 874de7f0615638 --app n8n-laurent

# Vérifier l'état
fly status --app n8n-laurent
```

## Variables d'environnement importantes

### Déjà configurées dans fly.toml

- `N8N_PORT=5678`
- `N8N_PROTOCOL=https`
- `WEBHOOK_URL=https://n8n-laurent.fly.dev`
- `GENERIC_TIMEZONE=Europe/Paris`
- `N8N_LOG_LEVEL=info`

### Configurées comme secrets

- `N8N_ENCRYPTION_KEY` (ne jamais changer après le premier déploiement)
- `N8N_BASIC_AUTH_ACTIVE=true`
- `N8N_BASIC_AUTH_USER=admin`
- `N8N_BASIC_AUTH_PASSWORD=N8n2025SecurePass!`

## Structure des fichiers

```
n8n-flyio/
├── dockerfile              # Configuration Docker
├── fly.toml                # Configuration Fly.io
├── .dockerignore           # Fichiers exclus du build
├── .gitignore              # Fichiers exclus de Git
├── .env.example            # Exemples de variables d'environnement
├── deploy.ps1              # Script de déploiement automatique
├── README.md               # Documentation principale
├── DEPLOYMENT.md           # Guide de déploiement
├── INSTALLATION_COMPLETE.md # Confirmation d'installation
├── MAINTENANCE.md          # Ce fichier
└── .github/workflows/
    └── deploy.yml          # CI/CD automatique
```

## Checklist de sécurité

- [ ] Mot de passe admin changé
- [ ] Clé de chiffrement sauvegardée de façon sécurisée
- [ ] Sauvegardes régulières configurées
- [ ] PostgreSQL configuré pour la production
- [ ] Monitoring activé
- [ ] Limites de ressources ajustées selon l'usage

## Ressources utiles

- [Documentation n8n](https://docs.n8n.io/)
- [Documentation Fly.io](https://fly.io/docs/)
- [Variables d'environnement n8n](https://docs.n8n.io/hosting/configuration/environment-variables/)
- [Communauté n8n](https://community.n8n.io/)
