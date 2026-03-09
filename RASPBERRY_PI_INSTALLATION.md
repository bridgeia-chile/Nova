# 🍓 Nova AI Assistant - Raspberry Pi 4 Installation Package

## 📦 Package Contents

This package contains everything you need to install and run Nova AI Assistant on your Raspberry Pi 4 with DietPi.

### Files Included:

```
Nova/
├── RASPBERRY_PI_README.md       # Complete installation guide
├── install-rpi.sh              # Automatic installation script
├── nova.service                # Systemd service file (optimized)
└── config/
    └── nova.config.rpi.json     # Pre-configured for Raspberry Pi
```

## 🚀 Quick Start Guide

### 1. Download the Package

```bash
# On your Raspberry Pi
cd /mnt/dietpi_userdata/projects
git clone https://github.com/[your-username]/nova.git
cd nova
```

### 2. Make Script Executable

```bash
chmod +x install-rpi.sh
```

### 3. Run Installation

```bash
./install-rpi.sh
```

The script will:
- ✅ Update your system
- ✅ Install Node.js and Git
- ✅ Clone Nova repository
- ✅ Configure for Raspberry Pi
- ✅ Install dependencies
- ✅ Build the application
- ✅ Set up systemd service
- ✅ Start Nova automatically

### 4. Verify Installation

```bash
# Check service status
sudo systemctl status nova

# Test Nova
curl http://localhost:18789/health

# Should return: {"status":"ok","version":"0.1.0"}
```

## 📋 Installation Details

### System Requirements

| Requirement | Specification |
|-------------|---------------|
| **Hardware** | Raspberry Pi 4 (4GB RAM) |
| **OS** | DietPi (latest) |
| **Storage** | 16GB+ MicroSD |
| **Node.js** | v20+ (ARM) |
| **Dependencies** | Git, build-essential |

### Configuration Files

#### `config/nova.config.rpi.json`

Optimized settings for Raspberry Pi:

```json
{
  "core": {
    "maxTokens": 500,          // Reduced for performance
    "concurrency": 2           // Limit concurrent operations
  },
  "performance": {
    "lowMemoryMode": true,    // Enable memory optimizations
    "maxOldSpaceSize": 1024   // Limit Node.js memory usage
  },
  "memory": {
    "provider": "sqlite",     // Lightweight database
    "storagePath": "/mnt/dietpi_userdata/nova_data"
  },
  "raspberryPi": {
    "optimized": true,
    "thermalProtection": {
      "enabled": true,
      "maxTemp": 75
    }
  }
}
```

#### `nova.service`

Systemd service with optimizations:
- `Nice=5` - Lower CPU priority
- `CPUQuota=80%` - Limit CPU usage
- `MemoryLimit=2G` - Memory constraint
- Automatic restart on failure

### Installation Script

The `install-rpi.sh` script performs:

1. **System Update** - Ensures all packages are up-to-date
2. **Dependency Installation** - Node.js, Git, build tools
3. **Repository Setup** - Clones or updates Nova
4. **Configuration** - Sets up Raspberry Pi optimized config
5. **Dependency Installation** - npm install --production
6. **Build Process** - Compiles TypeScript
7. **Service Setup** - Creates and enables systemd service

## 🎛 Performance Optimization

### For Best Results on Raspberry Pi 4:

1. **Enable ZRAM:**
   ```bash
   dietpi-config
   # Advanced Options > ZRAM > Enable (50% of RAM)
   ```

2. **Configure Swap:**
   ```bash
   dietpi-config
   # Advanced Options > Swap File > 1GB
   ```

3. **Thermal Management:**
   ```bash
   # Install thermal monitoring
   sudo apt install lm-sensors

   # Check temperatures
   sensors
   ```

4. **Network Optimization:**
   ```bash
   # Allow Nova port through firewall
   sudo ufw allow 18789/tcp
   ```

## 🔧 Troubleshooting

### Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| **Out of Memory** | Reduce `maxTokens`, enable ZRAM, limit concurrency |
| **Slow Performance** | Use SQLite, disable plugins, reduce logging |
| **Port Conflict** | Change port in config, check with `netstat` |
| **Build Errors** | Run `npm install` again, check Node.js version |
| **Service Fails** | Check logs: `journalctl -u nova -f` |

### Log Files

```bash
# View Nova logs
journalctl -u nova -f

# View application logs
cat /mnt/dietpi_userdata/nova_logs/nova.log

# View output logs
cat /mnt/dietpi_userdata/nova_logs/nova.out.log

# View error logs
cat /mnt/dietpi_userdata/nova_logs/nova.err.log
```

## 📈 Monitoring

### Check System Resources

```bash
# CPU and Memory
dietpi-services status

# Nova process
top -p $(pgrep -f "node.*nova")

# Disk usage
df -h /mnt/dietpi_userdata
```

### Nova-Specific Monitoring

```bash
# Check API health
curl http://localhost:18789/health

# Get system status
curl http://localhost:18789/status

# Check memory usage
curl http://localhost:18789/metrics
```

## 🔄 Updating Nova

```bash
# Stop service
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
- **Raspberry Pi Optimization:** https://www.raspberrypi.com/documentation/computers/configuration.html
- **Node.js on ARM:** https://github.com/nodejs/node/blob/main/BUILDING.md#arm

## 💡 Tips for Raspberry Pi 4

1. **Use a Heatsink** - Nova can be CPU-intensive
2. **Power Supply** - Use official 5V/3A USB-C power supply
3. **Cooling** - Consider active cooling for long sessions
4. **Storage** - Use high-endurance MicroSD or SSD via USB
5. **Overclocking** - Can improve performance (but increases heat)

## 🎯 Next Steps

Once Nova is running on your Raspberry Pi:

1. **Test the CLI interface:**
   ```bash
   cd /mnt/dietpi_userdata/projects/nova
   npm run cli
   ```

2. **Explore the API:**
   ```bash
   curl -X POST http://localhost:18789/api/message \
     -H "Content-Type: application/json" \
     -d '{"message":"Hello from Raspberry Pi"}'
   ```

3. **Set up remote access:**
   - Configure your router to forward port 18789
   - Use a dynamic DNS service if needed
   - Enable authentication in the config file

4. **Add plugins:**
   - Explore available plugins
   - Enable in `config/nova.config.rpi.json`
   - Restart Nova to apply changes

## 📝 Notes

- This package is optimized for **Raspberry Pi 4 with 4GB RAM**
- For Raspberry Pi 3 or earlier models, reduce `maxTokens` to 250
- For 8GB models, you can increase `concurrency` to 3-4
- Always monitor temperatures during extended use

---

*Package Version: 0.1.0*
*Last Updated: 09/03/2026*
*Optimized for: Raspberry Pi 4 / DietPi / ARMv8*

**Enjoy your Nova AI Assistant on Raspberry Pi! 🚀**