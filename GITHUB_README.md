# Nova AI Assistant

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-20+-green.svg)](https://nodejs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue.svg)](https://www.typescriptlang.org/)

**Nova** is a personal AI assistant inspired by OpenClaw, designed to run on your own devices including Raspberry Pi 4.

## 🚀 Quick Start

### For Raspberry Pi 4 (Recommended)

```bash
# Clone the repository
cd /mnt/dietpi_userdata/projects
git clone https://github.com/[your-username]/nova.git
cd nova

# Make script executable
chmod +x install-rpi.sh

# Run installation
./install-rpi.sh

# Verify
curl http://localhost:18789/health
```

### For Other Platforms

```bash
# Clone the repository
git clone https://github.com/[your-username]/nova.git
cd nova

# Install dependencies
npm install

# Build
npm run build

# Start
npm run start
```

## 📋 Features

- ✅ Personal AI assistant
- ✅ Runs on your own devices
- ✅ Raspberry Pi 4 optimized
- ✅ Modular architecture
- ✅ Plugin system
- ✅ CLI and API interfaces
- ✅ Low memory usage
- ✅ Thermal protection

## 📂 Project Structure

```
Nova/
├── src/               # Source code
│   ├── core/          # AI core
│   ├── gateway/       # Gateway server
│   ├── channels/      # Communication channels
│   └── index.ts       # Entry point
├── config/            # Configuration files
├── docs/              # Documentation
└── scripts/           # Installation scripts
```

## 📖 Documentation

- [Raspberry Pi Installation](RASPBERRY_PI_README.md)
- [Project Summary](PROJECT_SUMMARY.md)
- [Technical Documentation](MEMORIA.md)
- [Roadmap](NEXT_STEPS.md)

## 🔧 Configuration

Copy `config/nova.config.json.example` to `config/nova.config.json` and edit as needed.

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Inspiration

Nova is inspired by [OpenClaw](https://github.com/openclaw/openclaw) but designed to be simpler and more accessible.

---

**Star this repo if you find it useful! ⭐**