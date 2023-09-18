#!/bin/bash

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install git, if not already installed (optional)
sudo apt-get install -y git

# Install Python3 and pip3, if not already installed
sudo apt-get install -y python3 python3-pip

# Navigate to your project directory (change the path accordingly)
cd /RasPi-Led-Controllers

# Install Python dependencies from requirements.txt
pip3 install -r requirements.txt

# Any other system-wide dependencies or configurations go here
# For example:
# sudo apt-get install -y some-other-dependency

# If you have setup_service.py or other scripts to run after
python3 setup_service.py

echo "Installation completed!"