# n8n sur Fly.io

Déploiement de n8n sur Fly.io avec persistance des données.

## Prérequis

- [Flyctl](https://fly.io/docs/hands-on/install-flyctl/) installé
- Compte Fly.io actif

## Configuration

### Variables d'environnement

Les variables essentielles sont définies dans `fly.toml` :
- `N8N_PORT` : Port sur lequel n8n écoute (5678)
- `N8N_PROTOCOL` : Protocole HTTPS
- `WEBHOOK_URL` : URL publique de votre instance
- `GENERIC_TIMEZONE` : Fuseau horaire (Europe/Paris)

### Variables d'environnement sensibles (secrets)

Pour ajouter des secrets (ne pas mettre dans fly.toml) :

```bash
# Définir un mot de passe d'administration (recommandé)
fly secrets set N8N_BASIC_AUTH_ACTIVE=true --app n8n-laurent
fly secrets set N8N_BASIC_AUTH_USER=votre_username --app n8n-laurent
fly secrets set N8N_BASIC_AUTH_PASSWORD=votre_password --app n8n-laurent

# Clé de chiffrement pour les credentials (IMPORTANT)
fly secrets set N8N_ENCRYPTION_KEY=$(openssl rand -hex 32) --app n8n-laurent
```

## Volume de données

Créer le volume pour persister les données :

```bash
fly volumes create n8n_data --size 1 --region cdg --app n8n-laurent
```

## Déploiement

```bash
fly deploy --app n8n-laurent
```

## Accès

Votre instance sera accessible à : https://n8n-laurent.fly.dev

## Commandes utiles

```bash
# Voir le statut
fly status --app n8n-laurent

# Voir les logs
fly logs --app n8n-laurent

# Ouvrir dans le navigateur
fly open --app n8n-laurent

# SSH dans le container
fly ssh console --app n8n-laurent

# Lister les volumes
fly volumes list --app n8n-laurent

# Scaler la mémoire si nécessaire
fly scale memory 2048 --app n8n-laurent
```

## Configuration avancée

### Base de données PostgreSQL (optionnel)

Pour de meilleures performances avec plusieurs workflows :

```bash
# Créer une base de données Postgres
fly postgres create --name n8n-db

# Attacher la base à l'app
fly postgres attach n8n-db --app n8n-laurent

# Ajouter les variables d'environnement
fly secrets set DB_TYPE=postgresdb --app n8n-laurent
fly secrets set DB_POSTGRESDB_DATABASE=n8n --app n8n-laurent
fly secrets set DB_POSTGRESDB_HOST=n8n-db.internal --app n8n-laurent
fly secrets set DB_POSTGRESDB_PORT=5432 --app n8n-laurent
```

## Dépannage

- Si l'app ne démarre pas, vérifier les logs : `fly logs --app n8n-laurent`
- Vérifier que le volume est bien créé : `fly volumes list --app n8n-laurent`
- S'assurer que les secrets sont définis : `fly secrets list --app n8n-laurent`
