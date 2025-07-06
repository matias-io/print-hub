#!/bin/bash

# Print Hub Startup Script
echo "Starting Print Hub Dashboard and Services..."

# Get the host IP for Homepage configuration
HOST_IP=$(hostname -I | awk '{print $1}')
export HOMEPAGE_VAR_HOST_IP=$HOST_IP

# Start the main Print Hub dashboard and proxy
echo "Starting Print Hub Dashboard (Homepage) on port 80..."
docker compose up -d

# Start your Octoprint stack
echo "Starting OctoPrint stack on port 160..."
cd external/octoprint
docker compose up -d

# Start Prind stack with desired profiles
echo "Starting Prind stack with Fluidd profile..."
cd ../prind
# mainsail and klipper-octoprint are also possible along with other features
docker compose --profile fluidd up -d

# Start the Bambulabs stack 
echo "Starting Bamboo Labs stack..."
cd ../../internal/bamboo-connect
docker compose up -d
cd ../../

echo ""
echo "========================================"
echo "Print Hub is now running!"
echo "========================================"
echo "Dashboard: http://$HOST_IP"
echo "OctoPrint: http://$HOST_IP/octoprint"
echo "Fluidd: http://$HOST_IP/fluidd"
echo "Mainsail: http://$HOST_IP/mainsail (if enabled)"
echo "Spoolman: http://$HOST_IP/spoolman (if enabled)"
echo "Bamboo: http://$HOST_IP/bamboo"
echo "========================================"