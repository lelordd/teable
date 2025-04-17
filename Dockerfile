# Utiliser Node 20 au lieu de Node 18
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

# Utiliser la commande de build correcte (g:build au lieu de build)
RUN pnpm g:build

# Exposer le port
EXPOSE 3000

# Démarrer l'application (ajustez selon les scripts disponibles)
CMD ["pnpm", "start"]
