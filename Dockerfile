# Utiliser Node 20
FROM node:20

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Créer des fichiers .env dans chaque endroit stratégique
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/.env
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/apps/nestjs-backend/.env
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/apps/nextjs-app/.env

# Configuration pour éviter les problèmes de téléchargement de Node
RUN pnpm config set use-node-version false

# Installer les dépendances
RUN pnpm install --no-frozen-lockfile

# Construire l'application
RUN pnpm g:build || true

# Exposer le port
EXPOSE 3000

# Démarrer le backend avec variable d'environnement explicite
CMD ["sh", "-c", "PUBLIC_ORIGIN=https://xv.automatiser.com pnpm --filter @teable/backend start"]
