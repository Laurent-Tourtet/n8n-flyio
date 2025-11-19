# Test de la persistance des donnees

## Comment verifier que vos donnees sont bien persistees

### Etape 1 : Creer un workflow de test

1. Connectez-vous a n8n : https://n8n-laurent.fly.dev
   - Username: `admin`
   - Password: `N8n2025SecurePass!`

2. Creez un nouveau workflow
   - Cliquez sur "New workflow"
   - Ajoutez un noeud simple (ex: Schedule Trigger)
   - Donnez-lui un nom : "Test Persistance"
   - Sauvegardez le workflow

### Etape 2 : Redemarrer l'application

```powershell
# Configuration de l'alias
Set-Alias -Name fly -Value "$env:USERPROFILE\.fly\bin\flyctl.exe" -Scope Global

# Redemarrer la machine
fly machine restart 874de7f0615638 --app n8n-laurent

# Attendre quelques secondes
Start-Sleep -Seconds 10

# Verifier le statut
fly status --app n8n-laurent
```

### Etape 3 : Verifier la persistance

1. Reconnectez-vous a n8n : https://n8n-laurent.fly.dev
2. Verifiez que votre workflow "Test Persistance" est toujours present
3. Verifiez que vous n'avez pas besoin de recreer votre compte

### Resultat attendu

✅ **Votre workflow doit etre present**  
✅ **Votre compte doit etre intact**  
✅ **Vos parametres doivent etre conserves**

## Configuration de la persistance

La persistance est assuree par :

### Volume Fly.io
```toml
[mounts]
  source = "n8n_data"
  destination = "/data"
```

### Variables d'environnement
```toml
[env]
  N8N_USER_FOLDER = "/data"
```

### Dockerfile
```dockerfile
ENV N8N_USER_FOLDER=/data
```

## Que faire si les donnees ne sont pas persistees ?

### Verification 1 : Volume monte correctement

```powershell
fly volumes list --app n8n-laurent
```

Vous devez voir un volume nomme `n8n_data`.

### Verification 2 : Variable d'environnement

```powershell
fly config show --app n8n-laurent
```

Verifiez que `N8N_USER_FOLDER` est bien defini a `/data`.

### Verification 3 : Logs

```powershell
fly logs --app n8n-laurent
```

Recherchez des messages concernant le stockage des donnees.

## Sauvegarde manuelle (optionnel)

Si vous souhaitez faire une sauvegarde manuelle de vos donnees :

```powershell
# Se connecter en SSH (necessite une cle SSH configuree)
fly ssh console --app n8n-laurent

# Dans le container
cd /data
ls -la

# Verifier que vos fichiers sont presents :
# - config
# - database.sqlite (ou autre DB)
# - nodes/
# - workflows/
```

## Restoration en cas de probleme

Si vous perdez vos donnees malgre la configuration :

1. Verifiez que le volume n'a pas ete supprime
2. Verifiez la configuration dans fly.toml
3. Redéployez l'application
4. Consultez MAINTENANCE.md pour plus de details

---

La persistance est maintenant correctement configuree.
Vos donnees survivront a tous les redemarrages et redeploiements !
