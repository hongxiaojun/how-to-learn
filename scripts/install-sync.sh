#!/bin/bash

# 概念解剖自动同步安装脚本
# 用途：设置每周六自动同步概念解剖到 GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYNC_SCRIPT="$SCRIPT_DIR/sync-concepts.sh"
PLIST_FILE="$SCRIPT_DIR/com.hongxiaojun.how-to-learn.sync.plist"
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
LAUNCH_AGENT_PLIST="$LAUNCH_AGENT_DIR/com.hongxiaojun.how-to-learn.sync.plist"

echo "========================================="
echo "概念解剖自动同步 - 安装向导"
echo "========================================="

# 检查脚本是否存在
if [ ! -f "$SYNC_SCRIPT" ]; then
    echo "❌ 错误: 找不到同步脚本 $SYNC_SCRIPT"
    exit 1
fi

# 赋予执行权限
echo "📝 设置脚本执行权限..."
chmod +x "$SYNC_SCRIPT"

# 复制 plist 文件到 LaunchAgents 目录
echo "📂 安装定时任务..."
mkdir -p "$LAUNCH_AGENT_DIR"
cp "$PLIST_FILE" "$LAUNCH_AGENT_PLIST"

# 加载定时任务
echo "⏰ 加载定时任务..."
launchctl unload "$LAUNCH_AGENT_PLIST" 2>/dev/null || true
launchctl load "$LAUNCH_AGENT_PLIST"

echo "========================================="
echo "✅ 安装完成!"
echo ""
echo "📋 配置信息："
echo "  - 同步脚本: $SYNC_SCRIPT"
echo "  - 执行时间: 每周六 20:00"
echo "  - 日志文件: /tmp/how-to-learn-sync.log"
echo ""
echo "🔧 手动运行: $SYNC_SCRIPT"
echo "📊 查看日志: tail -f /tmp/how-to-learn-sync.log"
echo ""
echo "⚙️  修改时间: 编辑 $LAUNCH_AGENT_PLIST"
echo "   禁用任务: launchctl unload $LAUNCH_AGENT_PLIST"
echo "   启用任务: launchctl load $LAUNCH_AGENT_PLIST"
echo "========================================="
