#!/usr/bin/env bash
set -e

echo "[*] Updating apt..."
sudo apt-get update -y

echo "[*] Installing basic tools..."
sudo apt-get install -y \
  python3 python3-venv python3-pip \
  ca-certificates curl gnupg lsb-release \
  bc


# Docker Installation

if ! command -v docker &> /dev/null; then
  echo "[*] Installing Docker..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

echo "[*] Adding vagrant user to docker group..."
sudo usermod -aG docker vagrant

# Docker Compose 
if ! docker compose version &> /dev/null; then
  echo "[*] Installing docker compose plugin..."
  sudo apt-get install -y docker-compose-plugin
fi

echo "[*] Provisioning complete."
