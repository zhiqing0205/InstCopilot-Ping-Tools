# InstCopilot Ping Tools

[中文版本](#中文版本) | [English Version](#english-version)

---

## 中文版本

### 📖 项目简介

InstCopilot Ping Tools 是一个网络延迟测试工具，专为优化 Claude AI 服务连接而设计。该工具可以自动测试多个服务器节点的网络延迟和稳定性，并推荐最优服务器配置。

### ✨ 主要功能

- 🌐 **多节点测试**: 同时测试香港、日本、新加坡、上海、北京等多个服务器节点
- 📊 **详细统计**: 显示平均延迟、丢包率等关键网络指标
- 🎯 **智能推荐**: 基于延迟和丢包率综合评分，自动推荐最优服务器
- ⚙️ **自动配置**: 可自动更新 Claude 配置文件中的 base_url
- 🎨 **友好界面**: 彩色进度条和清晰的结果展示
- 🔄 **实时监控**: 实时显示测试进度和结果

### 🖼️ 预览图

![预览图](images/preview.png)

### 🚀 快速开始

#### 方法一：一键运行脚本

```bash
bash <(curl -sSL https://raw.githubusercontent.com/zhiqing0205/InstCopilot-Ping-Tools/main/test.sh)
```

#### 方法二：手动安装

1. **克隆仓库**
   ```bash
   git clone https://github.com/zhiqing0205/InstCopilot-Ping-Tools.git
   cd InstCopilot-Ping-Tools
   ```

2. **运行测试**
   ```bash
   chmod +x test.sh
   ./test.sh
   ```

### 📋 系统要求

- Linux 或 macOS 系统
- bash shell
- bc 计算器（如未安装会自动提示）
- ping 命令

### 🛠️ 安装依赖

**Ubuntu/Debian:**
```bash
sudo apt-get install bc
```

**CentOS/RHEL:**
```bash
sudo yum install bc
```

**macOS:**
```bash
brew install bc
```

### 📝 使用说明

1. 运行脚本后，工具将自动测试所有配置的服务器节点
2. 每个节点进行 15 次 ping 测试，计算平均延迟和丢包率
3. 测试完成后显示结果汇总表格
4. 工具会推荐延迟最低、最稳定的服务器
5. 可选择是否自动更新 Claude 配置文件

### 🔧 配置说明

脚本会自动更新 `~/.claude/settings.json` 文件中的 `ANTHROPIC_BASE_URL` 配置项，在更新前会自动创建备份文件。

### 📊 测试指标

- **平均延迟**: 15 次 ping 测试的平均响应时间
- **丢包率**: 测试过程中失败请求的百分比
- **综合得分**: 延迟 + (丢包率 × 10) 的综合评分

### 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 📄 许可证

MIT License

---

## English Version

### 📖 Project Description

InstCopilot Ping Tools is a network latency testing tool designed to optimize Claude AI service connections. This tool automatically tests network latency and stability across multiple server nodes and recommends the optimal server configuration.

### ✨ Key Features

- 🌐 **Multi-node Testing**: Test multiple server nodes including Hong Kong, Japan, Singapore, Shanghai, and Beijing
- 📊 **Detailed Statistics**: Display key network metrics like average latency and packet loss rate
- 🎯 **Smart Recommendations**: Automatically recommend the best server based on comprehensive scoring of latency and packet loss
- ⚙️ **Auto Configuration**: Automatically update base_url in Claude configuration files
- 🎨 **User-friendly Interface**: Colorful progress bars and clear result presentation
- 🔄 **Real-time Monitoring**: Real-time display of test progress and results

### 🖼️ Preview

![Preview](images/preview.png)

### 🚀 Quick Start

#### Method 1: One-click Installation Script

```bash
bash <(curl -sSL https://raw.githubusercontent.com/zhiqing0205/InstCopilot-Ping-Tools/main/test.sh)
```

#### Method 2: Manual Installation

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

### 📋 System Requirements

- Linux or macOS system
- bash shell
- bc calculator (installation prompt if not available)
- ping command

### 🛠️ Install Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get install bc
```

**CentOS/RHEL:**
```bash
sudo yum install bc
```

**macOS:**
```bash
brew install bc
```

### 📝 Usage Instructions

1. After running the script, the tool will automatically test all configured server nodes
2. Each node undergoes 15 ping tests to calculate average latency and packet loss rate
3. Upon completion, a result summary table is displayed
4. The tool recommends the server with the lowest latency and highest stability
5. Option to automatically update Claude configuration file

### 🔧 Configuration Details

The script automatically updates the `ANTHROPIC_BASE_URL` configuration in the `~/.claude/settings.json` file, creating a backup file before making changes.

### 📊 Test Metrics

- **Average Latency**: Average response time from 15 ping tests
- **Packet Loss Rate**: Percentage of failed requests during testing
- **Comprehensive Score**: Latency + (Packet Loss Rate × 10) composite score

### 🤝 Contributing

Issues and Pull Requests are welcome!

### 📄 License

MIT License