#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create docker-compose directory in user's home directory
mkdir ~/docker-compose

# Create Docker Compose file for linuxserver/qbittorrent, pawelmalak/flame, portainer/portainer, and jc21/nginx-proxy-manager
cat > ~/docker-compose/docker-compose.yaml << EOF
version: '3'

services:
  qbittorrent:
    image: linuxserver/qbittorrent
    container_name: qbittorrent
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - WEBUI_PORT=8080
      - TZ=Europe/London
    volumes:
      - ./qbittorrent-config:/config
      - ~/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp

  flame:
    image: pawelmalak/flame
    container_name: flame
    volumes:
      - ./flame-data:/app/data
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 5005:5005
    environment:
      - PASSWORD=5c8B^m532e5fv^#&
    restart: unless-stopped

  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./portainer-data:/data
    ports:
      - 9443:9443

  nginx-proxy-manager:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt

EOF

# Run docker-compose up -d in the ~/docker-compose directory
cd ~/docker-compose
docker-compose up -d
