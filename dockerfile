FROM n8nio/n8n:latest

# Exposer le port n8n
EXPOSE 5678

# Répertoire de travail
WORKDIR /home/node

# Variables d'environnement par défaut
ENV N8N_PORT=5678
ENV N8N_HOST=0.0.0.0
ENV N8N_PATH=/
ENV NODE_ENV=production
ENV N8N_USER_FOLDER=/data

# Le container n8n utilise déjà le bon entrypoint, pas besoin de le redéfinir
