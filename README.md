# Print Hub - Centralized 3D Printing Dashboard

![OctoPrint's logo](https://camo.githubusercontent.com/a5e712408ab37bdf61a5ba3d39852828bb5d9538f599794225234403e65834ea/68747470733a2f2f6f63746f7072696e742e6f72672f6173736574732f696d672f6c6f676f2e706e67 =250x)![](https://www.klipper3d.org/img/klipper-logo.png =250x) ![Docker Compose](https://github.com/docker/compose/raw/main/logo.png?raw=true =250x)

A Docker-based solution that provides a centralized dashboard for managing multiple 3D printing services including OctoPrint, Klipper (Fluidd/Mainsail), and Bamboo Labs integration.

## Motivation
Additional Computers can be used to provide additional utility to existing printers (Marlin) or take a step further by using custom printer firmware to achieve better utility than stock MCU firmware. This is typically done with a raspberry pi, however, it can get tedious to set up one or both of these solutions and come with its risks (a power outage to a non UPS'd pi can cause bad times 🧱). This docker deployment has a Mainsail flavour of Klipper you can use or an Octoprint setup (or both) with automated setup and nice subdomains on your network.

There are a few ways to manage the running containers and automate its deployment. A simple docker-based startup is included and recommended, feel free to combine this with something like Portainer for a remote management.
 
### Klipper Based Printers (Custom MCU Firmware)
If you already have klipper firmware on the MCU of your printer, you probably already know how this works and want the benefits you get from having it dockerized. If you are unfamiliar with what this is, consider seeing if your printer can easily switch and if you like the benefits (There are tons!)

There is an included version of mainsail flavour klipper software that was tested to run on Ubuntu based machines. Please view the setup for detailed instructions. 
### Marlin Based Printers (Usually the default firmware your printer has)
If you are unsure what your printer has, it is likely Marlin based. There is nothing wrong with Marlin, but if you know the benefits of Klipper and don't want to (or can't) switch out of Marlin, then octoprint is likely the best option for you. With this setup, you can use pretty much everything octoprint has, but it's nicely kept in this container.


# Setup
## Automated Setup 
You can pull a tagged version of this dirrectly from dockerhub! Coming soon...

## Manual Setup
Note: this was tested using Debian based machines (Particularly a Raspberry PI 3B+ with Raspberry Pi OS Lite, feel free to use this). I will assume this setup for the guide, but it should be nearly identical with whatever distro you are using.


### 🔧  Raspberry Pi setup
There are tons of guides for this. I will summarize what is important if you are unfamiliar.

1.  Use Raspberry Pi Imager and flash **Raspberry Pi OS Lite (64-bit)**. This is best for pi hardware and is very light, we will be using a terminal only OS since we will never have to deal with it outside of initial setup
    
2.  Before ejecting the SD card (On Windows make sure you keep LF line breaks):
    
    -   Create a file called `ssh` (no extension) in the `/boot` partition to enable SSH.
    -   Create a `wpa_supplicant.conf` file in `/boot`:

>         country=CA
>         ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
>         update_config=1
>         
>         network={
>           ssid="YourWiFi"
>           psk="YourPassword"
>         }

Make sure you do not use DHCP and keep a fixed IP from your modem's dashboard if you want easier SSH access (We will use the subdomains to access the printer interfaces regardless)

### 🔧  First time setup and Docker install

### 🔧  Container Setup and Run Instructions

### 🔧  Folder Structure and making custom-builds.

### 🔧  Finishing touches 
You can access these network-bound addresses anywhere on the internet using a free service such as.

> Consider supporting and checking out the open source projects included with these container if you can, they do very cool stuff 😎

## Features

- **Centralized Dashboard**: Homepage-based UI displaying all available services
- **Multiple Printer Support**: Supports OctoPrint and Klipper-based setups
- **Modular Design**: Uses git submodules for external printer stacks
- **Easy Access**: Single entry point with automatic service discovery
- **No Modification Required**: Works with stock configurations of submodules

## Architecture

```
print-hub/
├── docker-compose.yml          # Main dashboard and proxy
├── start.sh                    # Startup script
├── config/
│   ├── homepage/              # Dashboard configuration
│   └── nginx/                 # Reverse proxy config
├── external/                  # Git submodules (don't modify)
│   ├── octoprint/            # OctoPrint stack
│   └── prind/                # Klipper stack (Fluidd/Mainsail)
└── internal/                 # Internal services
    └── bamboo-connect/       # Bamboo Labs integration
```

## Quick Start

1. **Start all services:**
   ```bash
   ./start.sh
   ```

2. **Access the dashboard:**
   - Main Dashboard: `http://<your-pi-ip>`
   - Direct service access is also available via the dashboard

## Services Available

### Default Services
- **Homepage Dashboard** (Port 80): Main entry point with service overview
- **OctoPrint** (Port 160): Traditional 3D printer management
- **Prind Stack** (Port 80 via Traefik): Klipper-based services
  - Fluidd: Modern Klipper web interface
  - Mainsail: Alternative Klipper interface  
  - Moonraker: Klipper API
  - Spoolman: Filament management (optional)

### Optional Services (configure as needed)
- **Bamboo Connect**: Bamboo Labs printer integration
- **KlipperScreen**: Touch screen interface
- **Telegram Bot**: Notifications and remote control
- **Obico**: AI failure detection

## Configuration

### Homepage Dashboard
Edit files in `config/homepage/` to customize:
- `services.yaml`: Add/remove services and their URLs
- `settings.yaml`: Customize appearance and layout
- `docker.yaml`: Docker integration settings

### Adding New Services
1. Add the service to your `docker-compose.yml` or submodule
2. Update `config/homepage/services.yaml` with the new service details
3. Restart the dashboard: `docker compose restart homepage`

### Changing Active Profiles
Edit `start.sh` to modify which Prind profiles are active:
```bash
# Examples:
docker compose --profile fluidd up -d              # Fluidd only
docker compose --profile mainsail up -d            # Mainsail only  
docker compose --profile fluidd --profile spoolman up -d  # Multiple services
```

## Port Layout

| Service | Port | Access Method |
|---------|------|---------------|
| Homepage Dashboard | 80 | Direct |
| OctoPrint | 160 | Direct or via /octoprint |
| Prind (Traefik) | 80 | Proxied paths |
| Bamboo Connect | 8081 | Direct or via /bamboo |
