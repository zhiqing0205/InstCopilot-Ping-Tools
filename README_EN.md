# InstCopilot Ping Tools

[中文](README.md)

## 📖 Project Description

InstCopilot Ping Tools is a network latency testing tool designed to optimize Claude AI service connections. This tool automatically tests network latency and stability across multiple server nodes and recommends the optimal server configuration.

## ✨ Key Features

- 🌐 **Multi-node Testing**: Test multiple server nodes including Hong Kong, Japan, Singapore, and Mainland China
- 📊 **Detailed Statistics**: Display key network metrics like average latency and packet loss rate
- 🎯 **Smart Recommendations**: Automatically recommend the best server based on comprehensive scoring of latency and packet loss
- ⚙️ **Auto Configuration**: Automatically update base_url in Claude configuration files
- 🎨 **User-friendly Interface**: Colorful progress bars and clear result presentation
- 🔄 **Real-time Monitoring**: Real-time display of test progress and results
- ⚡ **Smart Timeout**: 3-second timeout with automatic skip after 3 consecutive failures

## 🖼️ Preview

![Preview](images/preview.png)

## 🚀 Quick Start

### Method 1: One-click Installation Script

```bash
bash <(curl -sSL https://raw.githubusercontent.com/zhiqing0205/InstCopilot-Ping-Tools/main/test.sh)
```

### Method 2: Manual Installation

1. **Clone Repository**
   ```bash
   git clone https://github.com/zhiqing0205/InstCopilot-Ping-Tools.git
   cd InstCopilot-Ping-Tools
   ```

2. **Run Test**
   ```bash
   chmod +x test.sh
   ./test.sh
   ```

## 📋 System Requirements

- Linux or macOS system
- bash shell
- bc calculator (auto-installed if not available)
- ping command

## 🛠️ Dependencies Installation

The tool automatically detects and installs bc calculator, supporting:

- **Ubuntu/Debian**: `apt-get`
- **CentOS/RHEL**: `yum`
- **Fedora**: `dnf`
- **macOS**: `brew`
- **Arch Linux**: `pacman`

## 📝 Usage Instructions

1. After running the script, the tool will automatically test all configured server nodes
2. Each node undergoes up to 15 ping tests to calculate average latency and packet loss rate
3. Smart timeout mechanism: 3-second timeout per ping, automatically skip remaining tests after 3 consecutive failures
4. Upon completion, a result summary table is displayed
5. The tool recommends the server with the lowest latency and highest stability
6. Option to automatically update Claude configuration file

## 🔧 Configuration Details

The script automatically updates the `ANTHROPIC_BASE_URL` configuration in the `~/.claude/settings.json` file, creating a backup file before making changes.

## 📊 Test Metrics

- **Average Latency**: Average response time from ping tests
- **Packet Loss Rate**: Percentage of failed requests during testing
- **Comprehensive Score**: Latency + (Packet Loss Rate × 10) composite score

## 🌐 Test Nodes

- **Hong Kong**: hk.instcopilot-api.com
- **Japan**: jp.instcopilot-api.com
- **Singapore**: sg.instcopilot-api.com
- **Mainland China**: instcopilot-api.yinban.online

## 🤝 Contributing

Issues and Pull Requests are welcome!

## 📄 License

MIT License