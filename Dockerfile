FROM node:18-alpine

# Installer pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copier tous les fichiers
COPY . .

# Installer les dépendances
RUN pnpm install

# Construire l'application
RUN pnpm build

# Exposer le port
EXPOSE 3000

# Démarrer l'application
CMD ["pnpm", "start"]
