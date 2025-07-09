#!/bin/bash

# Print Hub Shutdown Script
echo "Stopping Print Hub Dashboard and Services..."

# Stop the Bambulabs stack
echo "Stopping Bamboo Labs stack..."
cd internal/bambu-connect
docker compose down
cd ../../

# Stop Prind stack
echo "Stopping Prind stack..."
cd external/prind
docker compose --profile mainsail down
cd ../../

# Stop Octoprint stack
echo "Stopping OctoPrint stack..."
cd external/octoprint
docker compose down
cd ../../

# Stop the main Print Hub dashboard and proxy
echo "Stopping Print Hub Dashboard (Homepage)..."
docker compose down


echo ""
echo "========================================"
echo "Print Hub has been stopped! Make sure you run with sudo if docker was installed with sudo."
echo "========================================"
echo "All services have been shut down."
echo "========================================"