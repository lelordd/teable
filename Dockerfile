# Utiliser Node 20
FROM node:20

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Créer des fichiers .env dans des emplacements stratégiques
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/.env
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/apps/nestjs-backend/.env
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/apps/nextjs-app/.env

# Configuration pour éviter les problèmes de téléchargement de Node
RUN pnpm config set use-node-version false

# Installer les dépendances
RUN pnpm install --no-frozen-lockfile

# Construire d'abord les packages de base
RUN pnpm --filter "@teable/openapi" build
RUN pnpm --filter "@teable/core" build

# Ensuite, construire le reste de l'application
RUN pnpm build:packages
RUN pnpm g:build

# Exposer le port
EXPOSE 3000

# Démarrer le backend
CMD ["sh", "-c", "PUBLIC_ORIGIN=https://xv.automatiser.com pnpm --filter @teable/backend start"]
