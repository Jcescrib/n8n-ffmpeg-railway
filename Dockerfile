# 1. Partimos de Node 18 (Debian bullseye)
FROM node:18-bullseye

# 2. Pasamos a root para instalar dependencias del sistema
USER root

# 2.1 Actualizamos e instalamos ffmpeg y python
RUN apt-get update && \
    apt-get install -y ffmpeg python3 wget && \
    rm -rf /var/lib/apt/lists/*

# 3. Instalamos n8n y el nodo community de FFmpeg
RUN npm install -g n8n @saitrogen/n8n-nodes-ffmpeg

# 4. Creamos el usuario 'n8n' y volvemos a él
RUN useradd --create-home --shell /bin/bash n8n
USER n8n

# 5. Directorio de trabajo
WORKDIR /home/n8n

# 6. Exponemos el puerto donde corre n8n
EXPOSE 5678

# 7. Healthcheck para que Railway sepa si está vivo
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --spider --quiet http://localhost:5678/healthz || exit 1

# 8. Comando por defecto
CMD ["n8n", "start"]
