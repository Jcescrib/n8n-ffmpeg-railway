FROM node:18-bullseye

# Install dependencies
USER root
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get install -y python3 && \
    apt-get clean

# Install n8n
RUN npm install -g n8n

# Create n8n user
RUN useradd --create-home --shell /bin/bash n8n
USER n8n

# Set working directory
WORKDIR /home/n8n

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
