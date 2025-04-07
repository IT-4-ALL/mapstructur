#!/bin/bash
# Automatische Installation von MapStruct

# 1. Update und Upgrade des Systems
echo "Updating system..."
apt update && apt upgrade -y

# 2. Installation von Apache2, PHP, Python3-pip, zip, unzip und wget
echo "Installing Apache2, PHP, python3-pip, zip, unzip and wget..."
apt install -y apache2 php python3-pip zip unzip wget

# 3. Apache2-Dienst neu starten
echo "Restarting Apache2..."
systemctl restart apache2

# 4. Download der Zip-Datei von GitHub
echo "Downloading map.zip from GitHub..."
wget -O /tmp/map.zip https://github.com/IT-4-ALL/mapstructur/raw/main/map.zip

# 5. Auspacken der Zip-Datei in /var/www/html
echo "Unzipping map.zip to /var/www/html..."
unzip -o /tmp/map.zip -d /var/www/html

# 6. Alte index.html löschen (falls vorhanden)
echo "Removing existing index.html..."
rm -f /var/www/html/index.html

# 7. Ermitteln der IP-Adresse des Geräts
IP=$(hostname -I | awk '{print $1}')
echo "Detected IP address: $IP"

# 8. Neue index.html erstellen, die auf /map/index.php redirectet
echo "Creating new index.html with redirect..."
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="refresh" content="0; URL='http://$IP/map/index.php'" />
    <title>Redirecting...</title>
  </head>
  <body>
    Redirecting to <a href="http://$IP/map/index.php">http://$IP/map/index.php</a>
  </body>
</html>
EOF

# 9. Rechte im Ordner /var/www/html/map setzen
echo "Setting ownership and permissions for /var/www/html/map..."
chown -R www-data:www-data /var/www/html/map
chmod -R 755 /var/www/html/map

# 10. Abschlussmeldung
echo "Installation completed. Please visit: http://$IP/map/index.php"
