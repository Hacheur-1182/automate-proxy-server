#!/bin/bash

# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer Shadowsocks-libev
sudo apt install shadowsocks-libev -y

# Générer un mot de passe sécurisé
# PASSWORD=$(openssl rand -base64 16)
PASSWORD=$(qwertyuiop)

# Créer et configurer Shadowsocks
cat <<EOF | sudo tee /etc/shadowsocks-libev/config.json
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "password": "$PASSWORD",
    "method": "aes-256-gcm",
    "timeout": 300
}
EOF

# Redémarrer et activer le service Shadowsocks
sudo systemctl restart shadowsocks-libev
sudo systemctl enable shadowsocks-libev

# Ouvrir le port sur le pare-feu Google Cloud
# gcloud compute firewall-rules create shadowsocks-rule --allow tcp:8388

# Afficher les informations du serveur
echo "✅ Installation terminée !"
echo "🔹 Adresse IP : $(curl -s ifconfig.me)"
echo "🔹 Port : 8388"
echo "🔹 Mot de passe : $PASSWORD"
echo "🔹 Chiffrement : aes-256-gcm"
