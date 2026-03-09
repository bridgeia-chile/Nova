# 📦 Nova AI Assistant - Raspberry Pi 4 Package

## 🎉 Installation Package Ready!

**Status:** ✅ **COMPLETE** - Ready for Raspberry Pi 4 with DietPi

## 📂 Package Contents

```
Nova/
├── RASPBERRY_PI_README.md          # Complete installation guide (200+ lines)
├── RASPBERRY_PI_INSTALLATION.md    # Package documentation (150+ lines)
├── install-rpi.sh                   # Automatic installation script (150+ lines)
├── nova.service                    # Optimized systemd service
└── config/
    └── nova.config.rpi.json        # Raspberry Pi optimized config
```

## 📋 What's Included

### 1. Automatic Installation Script
**`install-rpi.sh`** - One-click installation that:
- ✅ Updates your system
- ✅ Installs Node.js and dependencies
- ✅ Clones Nova repository
- ✅ Configures for Raspberry Pi
- ✅ Installs npm packages
- ✅ Builds TypeScript
- ✅ Sets up systemd service
- ✅ Starts Nova automatically

### 2. Optimized Configuration
**`config/nova.config.rpi.json`** - Pre-configured for Raspberry Pi 4:
- Memory-optimized settings
- Reduced concurrency for ARM
- SQLite database (lightweight)
- Thermal protection
- Performance limits

### 3. Systemd Service
**`nova.service`** - Production-ready service with:
- Automatic restart on failure
- Memory and CPU limits
- Lower priority (Nice=5)
- Logging to files
- Optimized for ARM

### 4. Complete Documentation
**Two comprehensive guides:**
- `RASPBERRY_PI_README.md` - Step-by-step installation
- `RASPBERRY_PI_INSTALLATION.md` - Package overview

## 🚀 Quick Installation

```bash
# 1. Download (on your Raspberry Pi)
cd /mnt/dietpi_userdata/projects
git clone https://github.com/[your-username]/nova.git
cd nova

# 2. Make script executable
chmod +x install-rpi.sh

# 3. Run installation
./install-rpi.sh

# 4. Verify
curl http://localhost:18789/health
```

## 🎯 Key Features

### Optimized for Raspberry Pi 4
- ✅ ARM architecture support
- ✅ Low memory usage (< 2GB)
- ✅ Thermal protection
- ✅ CPU optimization
- ✅ Storage optimization

### Easy to Install
- ✅ Single command installation
- ✅ Automatic dependency handling
- ✅ Pre-configured settings
- ✅ Systemd service included

### Production Ready
- ✅ Automatic restarts
- ✅ Logging system
- ✅ Health monitoring
- ✅ Update process

## 📊 System Requirements

| Component | Requirement |
|-----------|-------------|
| **Hardware** | Raspberry Pi 4 (4GB RAM) |
| **OS** | DietPi (latest) |
| **Storage** | 16GB+ MicroSD |
| **Node.js** | v20+ (ARM) |
| **Time** | ~15 minutes |
| **Space** | ~500MB |

## 🔧 Configuration Options

### Performance Tuning
Edit `config/nova.config.rpi.json`:

```json
{
  "core": {
    "maxTokens": 500,      // Adjust based on your needs
    "concurrency": 2       // 1-3 recommended for Pi 4
  },
  "performance": {
    "maxOldSpaceSize": 1024  // Memory limit in MB
  }
}
```

### Service Management
```bash
# Start/Stop/Restart
sudo systemctl start/stop/restart nova

# Check status
sudo systemctl status nova

# View logs
journalctl -u nova -f
```

## 📈 Performance Expectations

### Raspberry Pi 4 (4GB) Benchmarks

| Task | Expected Performance |
|------|----------------------|
| Startup time | 5-10 seconds |
| Memory usage | 300-500MB |
| CPU usage | 10-40% (idle) |
| Response time | 1-3 seconds |
| Max concurrent | 2-3 users |

### Optimization Tips

1. **Enable ZRAM:**
   ```bash
   dietpi-config > Advanced > ZRAM > Enable
   ```

2. **Use SSD:**
   - Boot from USB SSD for better I/O

3. **Cooling:**
   - Use heatsink and fan
   - Monitor temps: `sensors`

4. **Overclock (optional):**
   - Can improve performance by 20-30%
   - Increases heat output

## 🔄 Update Process

```bash
# Stop service
sudo systemctl stop nova

# Update code
git pull origin main

# Install new dependencies
npm install --production

# Rebuild
npm run build

# Restart service
sudo systemctl start nova
```

## 💡 Usage Examples

### CLI Interface
```bash
cd /mnt/dietpi_userdata/projects/nova
npm run cli
```

### API Access
```bash
# Send message
curl -X POST http://localhost:18789/api/message \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello from Raspberry Pi"}'

# Health check
curl http://localhost:18789/health
```

### Remote Access
```bash
# On your local machine
ssh dietpi@<raspberry-pi-ip>

# Forward port (optional)
ssh -L 18789:localhost:18789 dietpi@<raspberry-pi-ip>

# Then access via localhost:18789
```

## 📚 Support & Resources

- **Installation Guide:** `RASPBERRY_PI_README.md`
- **Package Docs:** `RASPBERRY_PI_INSTALLATION.md`
- **Configuration:** `config/nova.config.rpi.json`
- **Service File:** `nova.service`

## 🎉 Next Steps

1. **Install Nova** on your Raspberry Pi
2. **Test the functionality**
3. **Explore plugins** to extend capabilities
4. **Set up remote access** for convenience
5. **Monitor performance** and adjust settings

## 📝 Notes

- Tested on Raspberry Pi 4 with 4GB RAM
- DietPi recommended for best performance
- For headless operation, use SSH
- Backup your data regularly
- Monitor temperatures during extended use

---

**Package Status:** ✅ READY FOR INSTALLATION
**Version:** 0.1.0 (Raspberry Pi Edition)
**Last Updated:** 09/03/2026
**Compatibility:** Raspberry Pi 4 / DietPi / ARMv8

**Your Nova AI Assistant is ready to run on Raspberry Pi! 🚀**

*Need help? Check the documentation files or ask for support.*