# ==========================================
# STUFE 1: Build-Umgebung (Node.js)
# ==========================================
FROM node:22-alpine AS builder

WORKDIR /app

# Abhängigkeiten installieren (Cache-optimiert)
COPY package*.json ./
RUN npm install

# Quellcode kopieren und SSG Build ausführen
COPY . .
RUN npm run build

# ==========================================
# STUFE 2: Production Webserver (Nginx)
# ==========================================
FROM nginx:alpine

# Eigene Nginx-Konfiguration für Astro View Transitions & PWA (SPA Fallback)
RUN rm -rf /usr/share/nginx/html/*

# Kopiere die gebauten Astro-Dateien aus Stufe 1 in das Nginx-Verzeichnis
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponiere Port 80 für den Coolify Proxy
EXPOSE 80

# Nginx im Vordergrund starten
CMD ["nginx", "-g", "daemon off;"]