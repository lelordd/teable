# Utiliser Node 20
FROM node:20

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Configuration pour éviter les problèmes de téléchargement de Node
RUN pnpm config set use-node-version false

# Définir les variables d'environnement nécessaires
ENV PUBLIC_ORIGIN="https://xv.automatiser.com"
ENV PRISMA_DATABASE_URL="postgresql://qk1QxkhIbaRMpaJt:MtBYzo7b4pqW9uHqzp4mxQe1c2KB0xzv@teable-db:5432/teable"
ENV POSTGRES_DB="teable"
ENV POSTGRES_PORT="5432"
ENV SERVICE_PASSWORD_POSTGRES="MtBYzo7b4pqW9uHqzp4mxQe1c2KB0xzv" 
ENV SERVICE_PASSWORD_REDIS="w2isigUnm5tz3pHz9WaMvSVGOSf6b7E4"
ENV SERVICE_USER_POSTGRES="qk1QxkhIbaRMpaJt"

# Installer les dépendances
RUN pnpm install --no-frozen-lockfile

# Générer le client Prisma
RUN find /app -name "schema.prisma" -exec sh -c 'cd $(dirname "{}") && npx prisma generate --schema={} || true' \;

# Construire l'application
RUN pnpm g:build || true

# Exposer le port
EXPOSE 3000

# Démarrer le backend NestJS
CMD ["pnpm", "--filter", "@teable/backend", "start"]
