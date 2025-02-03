#!/bin/bash

# Vérification des privilèges root
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Ce script doit être exécuté en tant que root !"
    exit 1
fi

# Mise à jour du système
echo "🔄 Mise à jour du système..."
apt update && apt upgrade -y

# Installation de Shadowsocks et vnstat (surveillance du trafic)
echo "🔧 Installation de Shadowsocks-libev et vnstat..."
apt install shadowsocks-libev vnstat -y

# Demande à l'utilisateur de choisir un port
read -p "🛠️ Entrez le port que vous voulez utiliser (par défaut: 8388) : " PORT
PORT=${PORT:-8388}

# Demande à l'utilisateur le nombre d'utilisateurs à créer
read -p "👥 Combien d’utilisateurs voulez-vous créer ? (par défaut: 1) : " USER_COUNT
USER_COUNT=${USER_COUNT:-1}

# Génération de la configuration avec plusieurs utilisateurs
CONFIG="/etc/shadowsocks-libev/config.json"
echo "{" > $CONFIG
echo '    "server": "0.0.0.0",' >> $CONFIG
echo '    "mode": "tcp_and_udp",' >> $CONFIG
echo '    "timeout": 300,' >> $CONFIG
echo '    "method": "aes-256-gcm",' >> $CONFIG
echo '    "fast_open": true,' >> $CONFIG
echo '    "reuse_port": true,' >> $CONFIG
echo '    "no_delay": true,' >> $CONFIG
echo '    "users": {' >> $CONFIG

for ((i=1; i<=USER_COUNT; i++))
do
    PASSWORD=$(openssl rand -base64 12)
    echo "🆕 Utilisateur $i - Mot de passe : $PASSWORD"
    if [ $i -eq $USER_COUNT ]; then
        echo "        \"user$i\": {\"password\": \"$PASSWORD\", \"port\": $PORT}" >> $CONFIG
    else
        echo "        \"user$i\": {\"password\": \"$PASSWORD\", \"port\": $PORT}," >> $CONFIG
    fi
done

echo '    }' >> $CONFIG
echo "}" >> $CONFIG

# Redémarrer Shadowsocks
echo "🔄 Redémarrage de Shadowsocks..."
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev

# Ouvrir le port sur Google Cloud
echo "🌍 Configuration du pare-feu Google Cloud..."
gcloud compute firewall-rules create shadowsocks-rule --allow tcp:$PORT,udp:$PORT

# Affichage des informations
IP=$(curl -s ifconfig.me)
echo "✅ Installation terminée !"
echo "🔹 Adresse IP : $IP"
echo "🔹 Port : $PORT"
echo "🔹 Méthode de chiffrement : aes-256-gcm"
echo "📊 Surveillez le trafic avec : vnstat -l"

