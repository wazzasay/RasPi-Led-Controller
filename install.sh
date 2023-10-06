#!/bin/bash

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install git, if not already installed (optional)
sudo apt-get install -y git

# Install Python3 and pip3, if not already installed
sudo apt-get install -y python3 python3-pip

# Clone the repository containing the scripts
git clone https://github.com/wazzasay/RasPi-Led-Controller.git

# Navigate to the cloned repository
cd RasPi-Led-Controller

# Install Python dependencies from requirements.txt
pip3 install -r requirements.txt

# Copy the ws2812Artnet.py and app.py scripts to /usr/local/bin/
sudo cp ws2812Artnet.py /usr/local/bin/
sudo cp app/app.py /usr/local/bin/

# Create a systemd service file for the ws2812Artnet.py script
sudo tee /etc/systemd/system/ws2812Artnet.service > /dev/null <<EOF
[Unit]
Description=WS2812 Artnet Service
After=network.target

[Service]
User=root
WorkingDirectory=/usr/local/bin
ExecStart=/usr/bin/python3 /usr/local/bin/ws2812Artnet.py
Restart=always

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
WorkingDirectory=/usr/local/bin
ExecStart=/usr/bin/python3 /usr/local/bin/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the services
sudo systemctl enable ws2812Artnet.service
sudo systemctl start ws2812Artnet.service
sudo systemctl enable app.service
sudo systemctl start app.service

# Any other system-wide dependencies or configurations go here
# For example:
# sudo apt-get install -y some-other-dependency

echo "Installation completed!"