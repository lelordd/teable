FROM ghcr.io/teableio/teable:latest

# Copier vos fichiers modifiés
# COPY mes-modifications/fichier1.js /app/chemin/vers/fichier1.js
# COPY mes-modifications/fichier2.js /app/chemin/vers/fichier2.js

# Définir variables d'environnement
ENV PUBLIC_ORIGIN=https://xv.automatiser.com
ENV PRISMA_DATABASE_URL=postgresql://qk1QxkhIbaRMpaJt:MtBYzo7b4pqW9uHqzp4mxQe1c2KB0xzv@teable-db:5432/teable

# Exposer le port
EXPOSE 3000

# Conserver la commande de démarrage d'origine
CMD ["sh", "-c", "PUBLIC_ORIGIN=https://xv.automatiser.com PRISMA_DATABASE_URL=postgresql://qk1QxkhIbaRMpaJt:MtBYzo7b4pqW9uHqzp4mxQe1c2KB0xzv@teable-db:5432/teable pnpm --filter @teable/backend start"]
