# 🚀 Guide de déploiement rapide - n8n sur Fly.io

## Étapes à suivre

### 1. Vérifier que Flyctl est installé

```powershell
fly version
```

Si non installé, téléchargez depuis : https://fly.io/docs/hands-on/install-flyctl/

### 2. Se connecter à Fly.io

```powershell
fly auth login
```

### 3. Créer le volume de données (une seule fois)

```powershell
fly volumes create n8n_data --size 1 --region cdg --app n8n-laurent
```

### 4. Configurer les secrets (IMPORTANT - une seule fois)

#### Générer une clé de chiffrement (PowerShell)
```powershell
$bytes = New-Object byte[] 32
[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$key = [BitConverter]::ToString($bytes).Replace("-", "").ToLower()
fly secrets set N8N_ENCRYPTION_KEY=$key --app n8n-laurent
```

#### Configurer l'authentification
```powershell
fly secrets set N8N_BASIC_AUTH_ACTIVE=true --app n8n-laurent
fly secrets set N8N_BASIC_AUTH_USER=admin --app n8n-laurent
fly secrets set N8N_BASIC_AUTH_PASSWORD=VotreMotDePasse123 --app n8n-laurent
```

### 5. Déployer l'application

```powershell
fly deploy --app n8n-laurent
```

### 6. Vérifier le déploiement

```powershell
fly status --app n8n-laurent
fly logs --app n8n-laurent
```

### 7. Accéder à n8n

Ouvrir dans le navigateur : https://n8n-laurent.fly.dev

---

## ⚡ Déploiement automatique (méthode rapide)

Utilisez le script PowerShell fourni :

```powershell
.\deploy.ps1
```

Ce script :
- ✅ Vérifie l'installation de Flyctl
- ✅ Crée le volume si nécessaire
- ✅ Configure les secrets (avec prompts interactifs)
- ✅ Déploie l'application
- ✅ Affiche l'URL finale

---

## 📋 Commandes utiles

```powershell
# Voir les logs en temps réel
fly logs --app n8n-laurent

# Ouvrir l'application dans le navigateur
fly open --app n8n-laurent

# Voir le statut
fly status --app n8n-laurent

# SSH dans le container
fly ssh console --app n8n-laurent

# Lister les secrets
fly secrets list --app n8n-laurent

# Lister les volumes
fly volumes list --app n8n-laurent

# Augmenter la mémoire si nécessaire
fly scale memory 2048 --app n8n-laurent

# Redémarrer l'application
fly apps restart n8n-laurent
```

---

## 🔧 Résolution des problèmes

### L'app ne démarre pas
```powershell
fly logs --app n8n-laurent
```

### Vérifier que le volume existe
```powershell
fly volumes list --app n8n-laurent
```

### Vérifier les secrets
```powershell
fly secrets list --app n8n-laurent
```

### Recréer l'app depuis zéro
```powershell
fly apps destroy n8n-laurent
fly launch --no-deploy
# Puis refaire les étapes 3, 4, 5
```

---

## 🎯 Configuration avancée

### Utiliser PostgreSQL (recommandé pour la production)

```powershell
# Créer une base de données
fly postgres create --name n8n-db --region cdg

# Attacher à l'app
fly postgres attach n8n-db --app n8n-laurent

# Configurer n8n pour utiliser Postgres
fly secrets set DB_TYPE=postgresdb --app n8n-laurent
fly secrets set DB_POSTGRESDB_DATABASE=n8n --app n8n-laurent
fly secrets set DB_POSTGRESDB_HOST=n8n-db.internal --app n8n-laurent
fly secrets set DB_POSTGRESDB_PORT=5432 --app n8n-laurent
```

### Configurer les emails SMTP (pour notifications)

```powershell
fly secrets set N8N_EMAIL_MODE=smtp --app n8n-laurent
fly secrets set N8N_SMTP_HOST=smtp.gmail.com --app n8n-laurent
fly secrets set N8N_SMTP_PORT=587 --app n8n-laurent
fly secrets set N8N_SMTP_USER=votre-email@gmail.com --app n8n-laurent
fly secrets set N8N_SMTP_PASS=votre-mot-de-passe-app --app n8n-laurent
```

---

## ✅ Checklist de déploiement

- [ ] Flyctl installé et authentifié
- [ ] Volume `n8n_data` créé
- [ ] Secret `N8N_ENCRYPTION_KEY` défini
- [ ] Authentification configurée (user/password)
- [ ] Application déployée
- [ ] URL accessible : https://n8n-laurent.fly.dev
- [ ] Connexion réussie avec les identifiants

---

## 📚 Documentation

- [Documentation n8n](https://docs.n8n.io/)
- [Documentation Fly.io](https://fly.io/docs/)
- [Variables d'environnement n8n](https://docs.n8n.io/hosting/configuration/environment-variables/)
