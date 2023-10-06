#!/bin/bash

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
User=root
WorkingDirectory=/RasPi-Led-Controller/
ExecStart=/usr/bin/python3 /RasPi-Led-Controller/ws2812Artnet.py
Restart=always
StandardOutput=append:/RasPi-Led-Controller/logs/ws2812Artnet.log
StandardError=append:/RasPi-Led-Controller/logs/ws2812Artnet_error.log

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
WorkingDirectory=/RasPi-Led-Controller/app/
ExecStart=/usr/bin/python3 /RasPi-Led-Controller/app/app.py
Restart=always
StandardOutput=append:/RasPi-Led-Controller/logs/app.log
StandardError=append:/RasPi-Led-Controller/logs/app_error.log

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the services
sudo systemctl enable ws2812Artnet.service
sudo systemctl start ws2812Artnet.service
sudo systemctl enable app.service
sudo systemctl start app.service

echo "Installation completed!"
