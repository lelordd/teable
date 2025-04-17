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

# Installer les dépendances
RUN pnpm install --no-frozen-lockfile

# Tenter de générer Prisma (si nécessaire)
RUN find /app -name "schema.prisma" -exec sh -c 'cd $(dirname "{}") && npx prisma generate --schema={} || true' \;

# Construire l'application
RUN pnpm g:build || true

# Exposer le port
EXPOSE 3000

# Démarrer avec environnement explicite
CMD ["sh", "-c", "export PUBLIC_ORIGIN=https://xv.automatiser.com && pnpm --filter @teable/backend start"]
