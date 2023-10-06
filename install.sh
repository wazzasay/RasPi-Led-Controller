#!/bin/bash

# Define the ASCII art title
TITLE="
  _____           _____ _                                          
 |  __ \         |  __ (_)                                         
 | |__) |__ _ ___| |__) |                                          
 |  _  // _` / __|  ___/ |                                         
 | | \ \ (_| \__ \ |   | |                                         
 |_|  \_\__,_|___/_|  _|_|_            _             _ _           
 | |            | |  / ____|          | |           | | |          
 | |     ___  __| | | |     ___  _ __ | |_ _ __ ___ | | | ___ _ __ 
 | |    / _ \/ _` | | |    / _ \| '_ \| __| '__/ _ \| | |/ _ \ '__|
 | |___|  __/ (_| | | |___| (_) | | | | |_| | | (_) | | |  __/ |   
 |______\___|\__,_|  \_____\___/|_| |_|\__|_|  \___/|_|_|\___|_|   

"

# Print the ASCII art title
echo "$TITLE"

# Navigate to the main repository directory
cd /RasPi-Led-Controller/

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install git, if not already installed (optional)
sudo apt-get install -y git

# Install Python3 and pip3, if not already installed
sudo apt-get install -y python3 python3-pip

# Install Python dependencies from requirements.txt
pip3 install -r requirements.txt

# Create a systemd service file for the ws2812Artnet.py script
sudo tee /etc/systemd/system/ws2812Artnet.service > /dev/null <<EOF
[Unit]
Description=WS2812 Artnet Service
After=network.target

[Service]
WorkingDirectory=/root/RasPi-Led-Controller/
ExecStart=/usr/bin/python3 /root/RasPi-Led-Controller/ws2812Artnet.py
Restart=always
StandardOutput=append:/root/RasPi-Led-Controller/logs/ws2812Artnet.log
StandardError=append:/root/RasPi-Led-Controller/logs/ws2812Artnet_error.log

[Install]
WantedBy=multi-user.target
EOF

# Create a systemd service file for the app.py script
sudo tee /etc/systemd/system/app.service > /dev/null <<EOF
[Unit]
Description=My App Service
After=network.target

[Service]
User=root
WorkingDirectory=/root/RasPi-Led-Controller/app/
ExecStart=/usr/bin/python3 /root/RasPi-Led-Controller/app/app.py
Restart=always
StandardOutput=append:/root/RasPi-Led-Controller/logs/app.log
StandardError=append:/root/RasPi-Led-Controller/logs/app_error.log

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the services
sudo systemctl enable ws2812Artnet.service
sudo systemctl start ws2812Artnet.service
sudo systemctl enable app.service
sudo systemctl start app.service

echo "Installation completed!"