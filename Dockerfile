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

# Tenter de générer Prisma (si nécessaire)
RUN find /app -name "schema.prisma" -exec sh -c 'cd $(dirname "{}") && npx prisma generate --schema={} || true' \;

# Construire l'application
RUN pnpm g:build || true

# Exposer le port (Vérifiez si le port 3000 est correct pour votre application)
EXPOSE 3000

# Démarrer le backend NestJS
CMD ["pnpm", "--filter", "@teable/backend", "start"]
