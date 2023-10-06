#!/bin/bash

# Define the ASCII art title
TITLE="
$$$$$$$\                      $$$$$$$\  $$\                                                                               
$$  __$$\                     $$  __$$\ \__|                                                                              
$$ |  $$ | $$$$$$\   $$$$$$$\ $$ |  $$ |$$\                                                                               
$$$$$$$  | \____$$\ $$  _____|$$$$$$$  |$$ |                                                                              
$$  __$$<  $$$$$$$ |\$$$$$$\  $$  ____/ $$ |                                                                              
$$ |  $$ |$$  __$$ | \____$$\ $$ |      $$ |                                                                              
$$ |  $$ |\$$$$$$$ |$$$$$$$  |$$ |      $$ |                                                                              
\__|  \__| \_______|\_______/ \__|      \__|                                                                              
                                                                                                                          
                                                                                                                          
                                                                                                                          
$$\                      $$\        $$$$$$\                       $$\                         $$\ $$\                     
$$ |                     $$ |      $$  __$$\                      $$ |                        $$ |$$ |                    
$$ |      $$$$$$\   $$$$$$$ |      $$ /  \__| $$$$$$\  $$$$$$$\ $$$$$$\    $$$$$$\   $$$$$$\  $$ |$$ | $$$$$$\   $$$$$$\  
$$ |     $$  __$$\ $$  __$$ |      $$ |      $$  __$$\ $$  __$$\\_$$  _|  $$  __$$\ $$  __$$\ $$ |$$ |$$  __$$\ $$  __$$\ 
$$ |     $$$$$$$$ |$$ /  $$ |      $$ |      $$ /  $$ |$$ |  $$ | $$ |    $$ |  \__|$$ /  $$ |$$ |$$ |$$$$$$$$ |$$ |  \__|
$$ |     $$   ____|$$ |  $$ |      $$ |  $$\ $$ |  $$ |$$ |  $$ | $$ |$$\ $$ |      $$ |  $$ |$$ |$$ |$$   ____|$$ |      
$$$$$$$$\\$$$$$$$\ \$$$$$$$ |      \$$$$$$  |\$$$$$$  |$$ |  $$ | \$$$$  |$$ |      \$$$$$$  |$$ |$$ |\$$$$$$$\ $$ |      
\________|\_______| \_______|       \______/  \______/ \__|  \__|  \____/ \__|       \______/ \__|\__| \_______|\__|      
                                                                                                                          
                                                                                                                          
                                                                                                                          
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
pip3 install -r /root/RasPi-Led-Controller/requirements.txt

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