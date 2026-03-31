# 概念解剖自动同步系统

这个脚本系统会自动将你新创建的概念解剖文件同步到 GitHub 仓库。

## 功能特性

- ✅ 自动检测 `~/Documents/notes/` 目录下的新概念解剖文件
- ✅ 只同步新增的文件，不会重复复制
- ✅ 自动创建 git 提交
- ✅ 自动推送到 GitHub
- ✅ 每周六晚上 8 点自动运行

## 文件说明

```
scripts/
├── sync-concepts.sh                    # 主同步脚本
├── install-sync.sh                     # 安装脚本
├── com.hongxiaojun.how-to-learn.sync.plist  # 定时任务配置
└── README_SYNC.md                      # 本文档
```

## 快速开始

### 1. 安装自动同步

```bash
cd /tmp/how-to-learn/scripts
chmod +x install-sync.sh
./install-sync.sh
```

安装完成后，系统会**每周六晚上 8 点**自动运行同步。

### 2. 手动运行同步

如果你想立即同步，可以手动运行：

```bash
bash /tmp/how-to-learn/scripts/sync-concepts.sh
```

### 3. 查看运行日志

```bash
# 查看最新日志
tail -f /tmp/how-to-learn-sync.log

# 查看错误日志
tail -f /tmp/how-to-learn-sync-error.log
```

## 配置选项

### 修改执行时间

编辑定时任务配置文件：

```bash
nano ~/Library/LaunchAgents/com.hongxiaojun.how-to-learn.sync.plist
```

找到 `StartCalendarInterval` 部分：

```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Weekday</key>
    <integer>7</integer>    <!-- 7=周六, 1=周日, 2=周一... -->
    <key>Hour</key>
    <integer>20</integer>   <!-- 小时 (0-23) -->
    <key>Minute</key>
    <integer>0</integer>    <!-- 分钟 (0-59) -->
</dict>
```

修改后重新加载：

```bash
launchctl unload ~/Library/LaunchAgents/com.hongxiaojun.how-to-learn.sync.plist
launchctl load ~/Library/LaunchAgents/com.hongxiaojun.how-to-learn.sync.plist
```

### 禁用自动同步

```bash
launchctl unload ~/Library/LaunchAgents/com.hongxiaojun.how-to-learn.sync.plist
```

### 重新启用自动同步

```bash
launchctl load ~/Library/LaunchAgents/com.hongxiaojun.how-to-learn.sync.plist
```

## 工作流程

1. **检测新文件**：扫描 `~/Documents/notes/` 目录
2. **对比文件**：检查哪些文件在仓库中不存在
3. **复制文件**：只复制新文件到仓库的 `concepts/` 目录
4. **Git 提交**：自动创建提交信息
5. **推送到 GitHub**：推送到 `main` 分支

## 文件命名规则

脚本会自动处理符合 Denote 风格命名的文件：

```
{timestamp}--概念解剖-{概念名}__concept.md

例如：20260331T222928--概念解剖-好奇心__concept.md
```

## 故障排除

### 同步失败

1. 检查 SSH 密钥是否配置正确：
   ```bash
   ssh -T git@github.com
   ```

2. 查看错误日志：
   ```bash
   cat /tmp/how-to-learn-sync-error.log
   ```

3. 手动运行脚本看详细错误：
   ```bash
   bash -x /tmp/how-to-learn/scripts/sync-concepts.sh
   ```

### 没有文件被同步

1. 确认新文件在 `~/Documents/notes/` 目录
2. 确认文件名包含 `--概念解剖--` 和 `__concept.md`
3. 检查日志文件看具体原因

## 许可

MIT License
