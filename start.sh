#!/bin/bash

# Print Hub Startup Script
echo "Starting Print Hub Dashboard and Services..."

# Get the host IP for Homepage configuration
# HOST_IP=$(hostname -I | awk '{print $1}')
# export HOMEPAGE_VAR_HOST_IP=$HOST_IP
HOST_IP=$(hostname -I | awk '{print $1}')
echo "HOMEPAGE_VAR_HOST_IP=$HOST_IP" > .env

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
# mainsail and octoprint are also possible as UI's
docker compose --profile fluidd up -d

# Start the Bambulabs stack 
echo "Starting Bamboo Labs stack..."
cd ../../internal/bambu-connect
docker compose up -d
cd ../../

echo ""
echo "========================================"
echo "Print Hub is now running!"
echo "========================================"
echo "Dashboard: http://$HOST_IP"
echo "OctoPrint: http://$HOST_IP/octoprints"
echo "Fluidd: http://$HOST_IP/klipper"
echo "Portainer: http://$HOST_IP/portainer"
echo "========================================"