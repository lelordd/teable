# Utiliser Node 20
FROM node:20

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Créer des fichiers .env pour les variables nécessaires
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/.env
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/apps/nestjs-backend/.env
RUN echo "PUBLIC_ORIGIN=https://xv.automatiser.com" > /app/apps/nextjs-app/.env
RUN echo "PRISMA_DATABASE_URL=postgresql://qk1QxkhIbaRMpaJt:MtBYzo7b4pqW9uHqzp4mxQe1c2KB0xzv@teable-db:5432/teable" >> /app/.env
RUN echo "PRISMA_DATABASE_URL=postgresql://qk1QxkhIbaRMpaJt:MtBYzo7b4pqW9uHqzp4mxQe1c2KB0xzv@teable-db:5432/teable" >> /app/apps/nestjs-backend/.env

# Configurer pnpm
RUN pnpm config set use-node-version false

# Installer les dépendances
RUN pnpm install --no-frozen-lockfile

# Générer les types Prisma explicitement
RUN cd /app/packages/db-main-prisma && npx prisma generate

# Corriger les dépendances circulaires en générant les fichiers de distribution manquants
RUN mkdir -p /app/packages/core/dist
RUN echo "export {};" > /app/packages/core/dist/index.js

# Construire les packages dans le bon ordre
RUN pnpm --filter "@teable/core" build
RUN pnpm --filter "@teable/openapi" build
RUN pnpm --filter "@teable/db-main-prisma" build || true
RUN pnpm --filter "@teable/common-i18n" build || true

# Tenter de construire l'application complète
RUN pnpm g:build || true

# Exposer le port
EXPOSE 3000

# Démarrer le backend avec variables d'environnement explicites
CMD ["sh", "-c", "PUBLIC_ORIGIN=https://xv.automatiser.com PRISMA_DATABASE_URL=postgresql://qk1QxkhIbaRMpaJt:MtBYzo7b4pqW9uHqzp4mxQe1c2KB0xzv@teable-db:5432/teable pnpm --filter @teable/backend start"]
