# Utiliser Node 20
FROM node:20

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Configuration pour éviter les problèmes de téléchargement de Node
RUN pnpm config set use-node-version false

# Installer les dépendances
RUN pnpm install --no-frozen-lockfile

# Créer un lien symbolique pour prisma dans node_modules/.bin
RUN ln -s /app/node_modules/.pnpm/prisma@6.2.1/node_modules/prisma/build/index.js /app/node_modules/.bin/prisma

# Recherche du schéma Prisma et génération du client
RUN find /app -name "schema.prisma" -exec sh -c 'cd $(dirname "{}") && npx prisma generate --schema={}' \;

# Utiliser la commande de build correcte
RUN pnpm g:build || true

# Exposer le port
EXPOSE 3000

# Démarrer l'application
CMD ["pnpm", "start"]
