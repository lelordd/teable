FROM node:18-alpine

WORKDIR /app

# Copier les fichiers de l'application
COPY . .

# Installer les dépendances
RUN npm ci

# Construire l'application
RUN npm run build

# Exposer le port
EXPOSE 3000

# Commande de démarrage
CMD ["npm", "start"]
