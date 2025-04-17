FROM node:18-alpine

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Utiliser npm install au lieu de npm ci
RUN npm install

# Si vous avez besoin de build votre application
RUN npm run build

# Exposer le port (ajustez selon votre application)
EXPOSE 3000

# Commande de démarrage (ajustez selon votre application)
CMD ["npm", "start"]
