#!/bin/bash

# 服务器列表（保持顺序）
declare -a regions=("香港" "日本" "新加坡" "上海" "北京")
declare -A servers=(
    ["香港"]="hk.instcopilot-api.com"
    ["日本"]="jp.instcopilot-api.com"
    ["新加坡"]="sg.instcopilot-api.com"
    ["上海"]="sh.instcopilot-api.com"
    ["北京"]="bj.instcopilot-api.com"
)

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# 结果存储
declare -A avg_latency
declare -A packet_loss

# 清理函数
cleanup() {
    echo -e "\n${YELLOW}测试中断${NC}"
    exit 1
}
trap cleanup SIGINT SIGTERM

# 绘制标题
draw_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}               InstCopilot 网络延迟测试工具                   ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

# 绘制进度条
draw_progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local progress=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "${BLUE}总体进度: ${WHITE}["
    for ((i=1; i<=filled; i++)); do printf "█"; done
    for ((i=1; i<=empty; i++)); do printf "░"; done
    printf "] %d/%d (%d%%)${NC}\n\n" $current $total $progress
}

# 绘制单个测试进度条
draw_test_progress() {
    local current=$1
    local total=$2
    local width=30
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "${PURPLE}  ["
    for ((i=1; i<=filled; i++)); do printf "█"; done
    for ((i=1; i<=empty; i++)); do printf "░"; done
    printf "] %2d/15${NC}" $current
}

# 单个服务器ping测试
ping_server() {
    local region=$1
    local host=${servers[$region]}
    local count=15
    local loss=0
    local total_time=0
    local valid_pings=0
    
    printf "${WHITE}正在测试 $region ($host)...${NC}\n"
    
    # 连续超时计数
    local consecutive_timeouts=0
    
    # 进度指示器
    for i in $(seq 1 $count); do
        printf "\r"
        draw_test_progress $((i-1)) $count
        
        # 执行ping命令，超时时间3秒
        result=$(ping -c 1 -W 3000 $host 2>/dev/null | grep "time=")
        
        if [[ $result =~ time=([0-9.]+) ]]; then
            latency=${BASH_REMATCH[1]}
            total_time=$(echo "$total_time + $latency" | bc -l)
            ((valid_pings++))
            consecutive_timeouts=0  # 重置连续超时计数
        else
            ((loss++))
            ((consecutive_timeouts++))
            
            # 连续3次超时则直接跳出
            if [ $consecutive_timeouts -ge 3 ]; then
                printf "\r"
                draw_test_progress $count $count
                printf " ${RED}[连续超时，跳过剩余测试]${NC}\n"
                # 将剩余的测试都标记为超时
                local remaining=$((count - i))
                loss=$((loss + remaining))
                break
            fi
        fi
        
        sleep 0.1
    done
    
    # 完成进度条
    printf "\r"
    draw_test_progress $count $count
    printf "                         \n"
    
    # 计算结果
    if [ $valid_pings -gt 0 ]; then
        avg_latency[$region]=$(echo "scale=2; $total_time / $valid_pings" | bc -l)
    else
        avg_latency[$region]=999999
    fi
    packet_loss[$region]=$(echo "scale=1; $loss * 100 / $count" | bc -l)
    
    # 显示结果
    if [ $valid_pings -gt 0 ]; then
        printf "${GREEN}  ✓ $region: 平均延迟 %.2fms, 丢包率 %.1f%%${NC}\n\n" \
            "${avg_latency[$region]}" "${packet_loss[$region]}"
    else
        printf "${RED}  ✗ $region: 连接失败${NC}\n\n"
    fi
}

# 更新Claude配置文件
update_claude_config() {
    local new_url="https://$1"
    local config_file="$HOME/.claude/settings.json"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ 配置文件不存在: $config_file${NC}"
        return 1
    fi
    
    # 备份原配置文件
    cp "$config_file" "${config_file}.backup"
    echo -e "${BLUE}📦 已备份原配置文件到 ${config_file}.backup${NC}"
    
    # 使用sed替换ANTHROPIC_BASE_URL
    if grep -q "ANTHROPIC_BASE_URL" "$config_file"; then
        sed -i "s|\"ANTHROPIC_BASE_URL\": \"[^\"]*\"|\"ANTHROPIC_BASE_URL\": \"$new_url\"|g" "$config_file"
        echo -e "${GREEN}✅ 已更新 ANTHROPIC_BASE_URL 为: $new_url${NC}"
    else
        echo -e "${YELLOW}⚠️  配置文件中未找到 ANTHROPIC_BASE_URL 字段${NC}"
    fi
}

# 选择最优服务器
select_best_server() {
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}📊 测试结果汇总${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local best_region=""
    local best_score=999999
    
    printf "${WHITE}%-8s %-30s %-12s %-8s${NC}\n" \
        "区域" "服务器" "平均延迟" "丢包率"
    echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
    
    for region in "${regions[@]}"; do
        local host=${servers[$region]}
        local avg=${avg_latency[$region]}
        local loss=${packet_loss[$region]}
        
        if [ "$avg" != "999999" ]; then
            # 计算综合得分 (延迟 + 丢包率权重)
            local score=$(echo "scale=2; $avg + ($loss * 10)" | bc -l)
            
            # 根据延迟设置颜色
            local color=$WHITE
            if (( $(echo "$avg < 50" | bc -l) )); then
                color=$GREEN
            elif (( $(echo "$avg < 100" | bc -l) )); then
                color=$YELLOW
            else
                color=$RED
            fi
            
            printf "${color}%-8s${NC} %-30s ${color}%10.2fms${NC}   %6.1f%%\n" \
                "$region" "$host" "$avg" "$loss"
            
            if (( $(echo "$score < $best_score" | bc -l) )); then
                best_score=$score
                best_region=$region
            fi
        else
            printf "${RED}%-8s${NC} %-30s ${RED}连接失败${NC}       --\n" \
                "$region" "$host"
        fi
    done
    
    echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
    
    if [ -n "$best_region" ]; then
        echo -e "${GREEN}🏆 推荐服务器: $best_region (${servers[$best_region]})${NC}"
        echo -e "${GREEN}   平均延迟: ${avg_latency[$best_region]}ms, 丢包率: ${packet_loss[$best_region]}%${NC}"
        echo
        # 询问是否更新配置
        echo -e "${YELLOW}🔧 是否更新 Claude 配置文件中的 base_url? (Y/n):${NC}"
        read -r response
        
        if [[ "$response" =~ ^[Yy]$ ]] || [[ -z "$response" ]]; then
            update_claude_config "${servers[$best_region]}"
        else
            echo -e "${BLUE}ℹ️ 跳过配置更新${NC}"
        fi
    else
        echo -e "${RED}❌ 所有服务器连接失败${NC}"
    fi
    
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 安装bc计算器
install_bc() {
    echo -e "${YELLOW}正在自动安装 bc 计算器...${NC}"
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y bc
    elif command -v yum &> /dev/null; then
        sudo yum install -y bc
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y bc
    elif command -v brew &> /dev/null; then
        brew install bc
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm bc
    else
        echo -e "${RED}错误: 无法自动安装 bc，请手动安装后重试${NC}"
        echo "Ubuntu/Debian: sudo apt-get install bc"
        echo "CentOS/RHEL: sudo yum install bc"
        echo "macOS: brew install bc"
        echo "Arch Linux: sudo pacman -S bc"
        exit 1
    fi
    
    if command -v bc &> /dev/null; then
        echo -e "${GREEN}✅ bc 安装成功${NC}"
    else
        echo -e "${RED}❌ bc 安装失败，请手动安装后重试${NC}"
        exit 1
    fi
}

# 主函数
main() {
    # 检查并安装依赖
    if ! command -v bc &> /dev/null; then
        echo -e "${YELLOW}⚠️  未检测到 bc 计算器，正在自动安装...${NC}"
        install_bc
        echo
    fi
    
    draw_header
    
    echo -e "${CYAN}📡 准备测试以下服务器:${NC}"
    for region in "${regions[@]}"; do
        echo -e "   ${WHITE}$region${NC}: ${servers[$region]}"
    done
    echo
    
    local total=${#regions[@]}
    local current=0
    
    # 顺序测试每个服务器
    for region in "${regions[@]}"; do
        draw_progress_bar $current $total
        ping_server "$region"
        ((current++))
    done
    
    draw_progress_bar $current $total
    echo -e "${GREEN}所有测试完成！${NC}\n"
    
    # 显示结果
    select_best_server
    
}

# 运行主函数
main