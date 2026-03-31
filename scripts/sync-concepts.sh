#!/bin/bash

# 概念解剖自动同步脚本
# 用途：将新的概念解剖文件同步到 GitHub 仓库

set -e

# 配置
NOTES_DIR="$HOME/Documents/notes"
REPO_DIR="/tmp/how-to-learn"
CONCEPTS_DIR="$REPO_DIR/concepts"
GIT_EMAIL="junqiaochen@gmail.com"
GIT_NAME="hongxiaojun"

echo "========================================="
echo "概念解剖自动同步脚本"
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

# 确保仓库目录存在
if [ ! -d "$REPO_DIR" ]; then
    echo "❌ 错误: 仓库目录不存在 $REPO_DIR"
    echo "正在克隆仓库..."
    git clone git@github.com:hongxiaojun/how-to-learn.git "$REPO_DIR"
fi

# 确保概念目录存在
mkdir -p "$CONCEPTS_DIR"

# 配置 git
cd "$REPO_DIR"
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

# 查找所有概念解剖文件
echo "📂 扫描概念解剖文件..."
CONCEPT_FILES=$(find "$NOTES_DIR" -name "*--概念解剖*__concept.md" -type f 2>/dev/null || true)

if [ -z "$CONCEPT_FILES" ]; then
    echo "ℹ️  没有找到概念解剖文件"
    exit 0
fi

# 统计文件数量
TOTAL_FILES=$(echo "$CONCEPT_FILES" | wc -l | tr -d ' ')
echo "📊 找到 $TOTAL_FILES 个概念解剖文件"

# 检查是否有新文件需要同步
NEW_FILES=0
for file in $CONCEPT_FILES; do
    filename=$(basename "$file")
    if [ ! -f "$CONCEPTS_DIR/$filename" ]; then
        echo "📝 新文件: $filename"
        cp "$file" "$CONCEPTS_DIR/"
        NEW_FILES=$((NEW_FILES + 1))
    fi
done

if [ $NEW_FILES -eq 0 ]; then
    echo "✅ 没有新文件需要同步"
    exit 0
fi

echo "📦 发现 $NEW_FILES 个新文件，开始同步..."

# 添加文件到 git
git add concepts/

# 检查是否有变化
if git diff --cached --quiet; then
    echo "ℹ️  没有需要提交的更改"
    exit 0
fi

# 生成提交信息
COMMIT_MSG="Add/Update $NEW_FILES concept anatomy file(s)

Synced from ~/Documents/notes/ on $(date '+%Y-%m-%d')

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# 提交
echo "📝 创建提交..."
git commit -m "$COMMIT_MSG"

# 推送
echo "🚀 推送到 GitHub..."
git push origin main

echo "========================================="
echo "✅ 同步完成!"
echo "新增文件: $NEW_FILES"
echo "完成时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
