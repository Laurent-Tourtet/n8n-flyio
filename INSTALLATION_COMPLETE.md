# 🎉 n8n déployé avec succès sur Fly.io !

## ✅ Déploiement terminé

Votre instance n8n est maintenant opérationnelle avec **persistance des données activée** !

## 🌐 Accès à l'application

**URL** : https://n8n-laurent.fly.dev

## 🔐 Identifiants de connexion

**Nom d'utilisateur** : `admin`  
**Mot de passe** : `N8n2025SecurePass!`

⚠️ **IMPORTANT** : Changez ces identifiants dès votre première connexion pour des raisons de sécurité !

## 💾 Persistance des données

**Configuration appliquée pour la persistance :**

- **Volume** : `n8n_data` (1 GB, chiffré)
- **Point de montage** : `/data`
- **Variable d'environnement** : `N8N_USER_FOLDER=/data`

✅ **Toutes vos données sont maintenant persistantes** :
- Workflows
- Credentials
- Exécutions
- Paramètres utilisateur
- Configuration

Vos données survivront aux redémarrages et aux redéploiements !

## 📋 Configuration actuelle

- **Application** : n8n-laurent
- **Région** : Paris (cdg)
- **Mémoire** : 1 GB
- **Volume** : 1 GB (persistance des données)
- **Protocole** : HTTPS forcé
- **Auto-stop** : Activé (économie de ressources)
- **Timezone** : Europe/Paris
- **Host** : 0.0.0.0 (accessible publiquement)

## 🔒 Secrets configurés

- ✅ N8N_ENCRYPTION_KEY (clé de chiffrement pour les credentials)
- ✅ N8N_BASIC_AUTH_ACTIVE (authentification activée)
- ✅ N8N_BASIC_AUTH_USER (nom d'utilisateur)
- ✅ N8N_BASIC_AUTH_PASSWORD (mot de passe)

## 📊 Commandes utiles

```powershell
# Alias pour faciliter l'utilisation
Set-Alias -Name fly -Value "$env:USERPROFILE\.fly\bin\flyctl.exe" -Scope Global

# Voir les logs en temps réel
fly logs --app n8n-laurent

# Ouvrir l'application dans le navigateur
fly open --app n8n-laurent

# Voir le statut
fly status --app n8n-laurent

# SSH dans le container
fly ssh console --app n8n-laurent

# Redémarrer l'application
fly machine restart 874de7f0615638 --app n8n-laurent

# Mettre à jour les secrets
fly secrets set VARIABLE=valeur --app n8n-laurent

# Lister les secrets
fly secrets list --app n8n-laurent

# Redéployer après modification
fly deploy --app n8n-laurent
```

## 🔄 Prochaines étapes recommandées

1. **Connectez-vous à n8n** : https://n8n-laurent.fly.dev
2. **Changez le mot de passe** via les secrets :
   ```powershell
   fly secrets set N8N_BASIC_AUTH_PASSWORD=VotreNouveauMotDePasse --app n8n-laurent
   ```
3. **Configurez vos premiers workflows**
4. **(Optionnel) Ajoutez une base PostgreSQL** pour de meilleures performances (voir DEPLOYMENT.md)

## 🆘 Support

- Documentation n8n : https://docs.n8n.io/
- Documentation Fly.io : https://fly.io/docs/
- En cas de problème, consultez les logs : `fly logs --app n8n-laurent`

---

✨ **Votre installation n8n est prête à l'emploi !**
