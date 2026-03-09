# 🍓 Nova AI Assistant - Raspberry Pi 4 Installation Guide

## 📋 Overview

This guide provides instructions for installing Nova AI Assistant on a **Raspberry Pi 4 (4GB RAM)** running **DietPi**. The installation has been optimized for ARM architecture and limited resources.

## 🛠 Requirements

### Hardware
- Raspberry Pi 4 Model B (4GB RAM recommended)
- MicroSD card (16GB minimum, 32GB recommended)
- Power supply (5V/3A USB-C)
- Optional: Heat sinks and cooling fan

### Software
- DietPi (latest stable version)
- Node.js v20+ (ARM version)
- npm or pnpm
- Git

## 📦 Installation Steps

### 1. Prepare Your Raspberry Pi

```bash
# Update DietPi
dietpi-update

# Install required dependencies
dietpi-software install 117  # Node.js
dietpi-software install 104  # Git

# Verify installation
node -v  # Should show v20.x or higher
npm -v   # Should show 10.x or higher
```

### 2. Clone Nova Repository

```bash
# Navigate to your projects directory
cd /mnt/dietpi_userdata/projects

# Clone the Nova repository
git clone https://github.com/[your-username]/nova.git

# Navigate to Nova directory
cd nova
```

### 3. Install Dependencies

```bash
# Install Node.js dependencies
npm install --production

# For development (optional)
npm install
```

### 4. Configure Nova

```bash
# Copy the example configuration
cp config/nova.config.json config/nova.config.prod.json

# Edit configuration for Raspberry Pi
nano config/nova.config.prod.json

# Recommended settings for Raspberry Pi 4:
{
  "nova": {
    "core": {
      "modelProvider": "openai",
      "temperature": 0.7,
      "maxTokens": 500  # Reduced for ARM performance
    },
    "gateway": {
      "port": 18789,
      "host": "0.0.0.0",  # Allow external connections
      "enableWebsocket": true
    },
    "memory": {
      "provider": "sqlite",  # Lightweight database
      "storagePath": "/mnt/dietpi_userdata/nova_data"
    }
  }
}
```

### 5. Create Systemd Service

```bash
# Create service file
sudo nano /etc/systemd/system/nova.service

# Add the following content:
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

[Install]
WantedBy=multi-user.target

# Enable and start the service
sudo systemctl enable nova
sudo systemctl start nova

# Check status
sudo systemctl status nova
```

### 6. Build Nova (First Run)

```bash
# Build TypeScript
npm run build

# The service should now be running automatically
```

### 7. Verify Installation

```bash
# Check if Nova is running
curl http://localhost:18789/health

# Should return: {"status":"ok","version":"0.1.0"}

# Check logs
journalctl -u nova -f
```

## 🎛 Configuration Tips for Raspberry Pi

### Performance Optimization

1. **Reduce Memory Usage:**
   ```bash
   # Edit Nova configuration
   nano config/nova.config.prod.json

   # Set:
   "maxTokens": 500,
   "concurrency": 2  # Limit concurrent operations
   ```

2. **Enable ZRAM:**
   ```bash
   dietpi-config
   # Navigate to: Advanced Options > ZRAM
   # Enable and set to 50% of RAM
   ```

3. **Optimize Swap:**
   ```bash
   dietpi-config
   # Navigate to: Advanced Options > Swap File
   # Set to 1GB
   ```

### Network Configuration

```bash
# Allow Nova port through firewall
sudo ufw allow 18789/tcp

# If using remote access
sudo ufw allow from 192.168.1.0/24 to any port 18789
```

## 🚀 Using Nova

### CLI Interface

```bash
# Access Nova CLI
nova-cli

# Or use the gateway directly
curl -X POST http://localhost:18789/api/message \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello Nova"}'
```

### Web Interface (Future)

Once the web interface is implemented:
```bash
# Access via browser
http://<raspberry-pi-ip>:18789
```

## 🔧 Troubleshooting

### Common Issues

1. **Out of Memory Errors:**
   - Reduce `maxTokens` in config
   - Limit concurrent operations
   - Enable ZRAM as shown above

2. **Slow Performance:**
   - Use SQLite instead of other databases
   - Disable unnecessary plugins
   - Reduce logging level

3. **Port Conflicts:**
   - Check if port 18789 is in use: `sudo netstat -tulnp | grep 18789`
   - Change port in config if needed

4. **Node.js Version Issues:**
   - Ensure you have ARM version: `node -v`
   - Reinstall if needed: `dietpi-software reinstall 117`

## 📈 Monitoring

```bash
# Check CPU and memory usage
dietpi-services status

# Monitor Nova specifically
top -p $(pgrep -f "node.*nova")

# View logs
journalctl -u nova -f --no-pager | tail -50
```

## 🔄 Updating Nova

```bash
# Stop the service
sudo systemctl stop nova

# Update code
cd /mnt/dietpi_userdata/projects/nova
git pull origin main

# Install new dependencies
npm install --production

# Rebuild
npm run build

# Restart service
sudo systemctl start nova
```

## 📚 Additional Resources

- **DietPi Documentation:** https://dietpi.com/docs/
- **Node.js on ARM:** https://github.com/nodejs/node/blob/main/BUILDING.md#arm
- **Raspberry Pi Optimization:** https://www.raspberrypi.com/documentation/computers/configuration.html

---

*Last updated: 09/03/2026*
*Optimized for Raspberry Pi 4 with DietPi*