# Utiliser Node sur Debian/Ubuntu qui a glibc au lieu d'Alpine qui a musl
FROM node:18

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Installer les dépendances sans essayer de télécharger Node.js
RUN pnpm config set use-node-version false
RUN pnpm install --no-frozen-lockfile

# Construire l'application
RUN pnpm build

# Exposer le port
EXPOSE 3000

# Démarrer l'application
CMD ["pnpm", "start"]
