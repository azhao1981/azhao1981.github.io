#!/bin/bash

# Hugo 部署脚本
# 自动构建并部署到 GitHub Pages

set -e

echo "🚀 开始部署 Hugo 网站..."

# 构建 Hugo 网站
echo "📦 构建 Hugo 网站..."
hugo --minify --cleanDestinationDir

if [ $? -ne 0 ]; then
    echo "❌ Hugo 构建失败"
    exit 1
fi

echo "✅ Hugo 构建成功"

# 进入 public 目录并提交更改
echo "📤 部署到 GitHub Pages..."
cd public

# 添加所有更改
git add .

# 检查是否有更改需要提交
if git diff --staged --quiet; then
    echo "ℹ️  没有更改需要提交"
    exit 0
fi

# 提交更改
git commit -m "自动部署: $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到远程仓库
git push origin gh-pages

echo "🎉 部署成功！"
echo "🌐 网站地址: https://azhao1981.github.io"