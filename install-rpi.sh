#!/bin/bash

# Nova AI Assistant - Raspberry Pi 4 Installation Script
# Optimized for DietPi on ARM architecture
# Version: 0.1.0
# Last Updated: 09/03/2026

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    echo -e "${RED}[ERROR]${NC} This script should NOT be run as root. Use regular user."
    exit 1
fi

# Check if running on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/device-tree/model; then
    echo -e "${YELLOW}[WARNING]${NC} This script is optimized for Raspberry Pi. Continuing anyway..."
fi

# Check if DietPi is installed
if [ ! -f /boot/dietpi/.version ]; then
    echo -e "${YELLOW}[WARNING]${NC} DietPi not detected. This script assumes DietPi environment."
fi

# Function to print section headers
print_section() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

# Function to check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_section "Nova AI Assistant - Raspberry Pi Installation"

# Step 1: Update system
print_section "Step 1/6: Updating System"
echo -e "${YELLOW}[INFO]${NC} Updating DietPi..."
sudo dietpi-update -y

# Step 2: Install dependencies
print_section "Step 2/6: Installing Dependencies"

echo -e "${YELLOW}[INFO]${NC} Installing Node.js..."
sudo dietpi-software install 117  # Node.js

echo -e "${YELLOW}[INFO]${NC} Installing Git..."
sudo dietpi-software install 104  # Git

echo -e "${YELLOW}[INFO]${NC} Installing build tools..."
sudo apt-get update
sudo apt-get install -y build-essential python3

# Verify installations
echo -e "${YELLOW}[INFO]${NC} Verifying installations..."
if ! command_exists node; then
    echo -e "${RED}[ERROR]${NC} Node.js installation failed."
    exit 1
fi

if ! command_exists npm; then
    echo -e "${RED}[ERROR]${NC} npm installation failed."
    exit 1
fi

if ! command_exists git; then
    echo -e "${RED}[ERROR]${NC} Git installation failed."
    exit 1
fi

echo -e "${GREEN}[SUCCESS]${NC} All dependencies installed successfully."

# Step 3: Clone Nova repository
print_section "Step 3/6: Cloning Nova Repository"

INSTALL_DIR="/mnt/dietpi_userdata/projects/nova"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}[INFO]${NC} Nova directory already exists. Pulling latest changes..."
    cd "$INSTALL_DIR"
    git pull origin main
else
    echo -e "${YELLOW}[INFO]${NC} Cloning Nova repository..."
    git clone https://github.com/[your-username]/nova.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo -e "${GREEN}[SUCCESS]${NC} Nova repository ready."

# Step 4: Configure Nova for Raspberry Pi
print_section "Step 4/6: Configuring Nova for Raspberry Pi"

# Create config directory if it doesn't exist
mkdir -p config

# Create production config for Raspberry Pi
cat > config/nova.config.prod.json << 'EOF'
{
  "nova": {
    "version": "0.1.0",
    "name": "Nova",
    "description": "AI Assistant - Raspberry Pi Edition",
    "core": {
      "modelProvider": "openai",
      "defaultModel": "gpt-3.5-turbo",
      "temperature": 0.7,
      "maxTokens": 500,
      "concurrency": 2
    },
    "gateway": {
      "port": 18789,
      "host": "0.0.0.0",
      "enableWebsocket": true,
      "enableRestAPI": true
    },
    "channels": {
      "enabled": ["cli"],
      "available": ["cli", "web"]
    },
    "plugins": {
      "pluginDir": "./plugins",
      "enabled": [],
      "sandboxEnabled": true
    },
    "memory": {
      "provider": "sqlite",
      "persistence": true,
      "storagePath": "/mnt/dietpi_userdata/nova_data"
    },
    "logging": {
      "level": "info",
      "file": "/mnt/dietpi_userdata/nova_logs/nova.log",
      "maxSize": "10m",
      "maxFiles": 3
    }
  },
  "raspberryPi": {
    "optimized": true,
    "lowMemoryMode": true,
    "reduceConcurrency": true
  }
}
EOF

echo -e "${GREEN}[SUCCESS]${NC} Nova configured for Raspberry Pi."

# Step 5: Install Node.js dependencies
print_section "Step 5/6: Installing Node.js Dependencies"

echo -e "${YELLOW}[INFO]${NC} Installing production dependencies..."
npm install --production

echo -e "${GREEN}[SUCCESS]${NC} Dependencies installed."

# Step 6: Build and setup service
print_section "Step 6/6: Building and Setting Up Service"

echo -e "${YELLOW}[INFO]${NC} Building TypeScript..."
npm run build

echo -e "${YELLOW}[INFO]${NC} Creating data directories..."
mkdir -p /mnt/dietpi_userdata/nova_data
mkdir -p /mnt/dietpi_userdata/nova_logs

echo -e "${YELLOW}[INFO]${NC} Creating systemd service..."

# Create systemd service
cat > /tmp/nova.service << 'EOF'
[Unit]
Description=Nova AI Assistant
After=network.target

[Service]
ExecStart=/usr/bin/node /mnt/dietpi_userdata/projects/nova/dist/src/index.js
WorkingDirectory=/mnt/dietpi_userdata/projects/nova
Restart=always
User=dietpi
Environment=NODE_ENV=production
Environment=NOVA_CONFIG=/mnt/dietpi_userdata/projects/nova/config/nova.config.prod.json
StandardOutput=append:/mnt/dietpi_userdata/nova_logs/nova.out.log
StandardError=append:/mnt/dietpi_userdata/nova_logs/nova.err.log

[Install]
WantedBy=multi-user.target
EOF

sudo mv /tmp/nova.service /etc/systemd/system/nova.service

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable nova
sudo systemctl start nova

echo -e "${GREEN}[SUCCESS]${NC} Nova service created and started."

# Final verification
print_section "Installation Complete!"

echo -e "${GREEN}✅ Nova AI Assistant has been installed successfully!${NC}"
echo -e ""
echo -e "${BLUE}Next Steps:${NC}"
echo -e "1. Check service status: ${YELLOW}sudo systemctl status nova${NC}"
echo -e "2. View logs: ${YELLOW}journalctl -u nova -f${NC}"
echo -e "3. Test Nova: ${YELLOW}curl http://localhost:18789/health${NC}"
echo -e "4. Access CLI: ${YELLOW}cd /mnt/dietpi_userdata/projects/nova && npm run cli${NC}"
echo -e ""
echo -e "${BLUE}Documentation:${NC}"
echo -e "- Full guide: ${YELLOW}RASPBERRY_PI_README.md${NC}"
echo -e "- Configuration: ${YELLOW}config/nova.config.prod.json${NC}"
echo -e "- Logs: ${YELLOW}/mnt/dietpi_userdata/nova_logs/${NC}"
echo -e ""
echo -e "${BLUE}Access Nova:${NC}"
echo -e "- Web Interface: ${YELLOW}http://$(hostname -I | awk '{print $1}'):18789${NC}"
echo -e "- API Endpoint: ${YELLOW}http://localhost:18789/api/message${NC}"
echo -e ""
