# automate-proxy-server
Automation create proxy server on google cloud vm
## To install 
copy and paste this link below on VM

wget https://raw.githubusercontent.com/Hacheur-1182/automate-proxy-server/master/install.sh -O install.sh
chmod +x install.sh
sudo ./install.sh

# Ouvrir le port sur le pare-feu Google Cloud
coller cette commande dans le terminal de votre console google
gcloud compute firewall-rules create shadowsocks-rule --allow tcp:8388
