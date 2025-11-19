FROM n8nio/n8n:latest

# Répertoire de travail (ne pas toucher)
WORKDIR /home/node

# Exposer le port n8n
EXPOSE 5678

# Lancement n8n
CMD ["n8n"]
