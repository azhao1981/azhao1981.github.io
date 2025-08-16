# Hugo GitHub Pages 渐进式部署方案

## 概述
本方案采用渐进式步骤，从基础验证开始，逐步构建完整的 Hugo 静态网站并部署到 GitHub Pages。

## 方案特点
- **渐进式验证**：每一步都可独立验证成功
- **简化依赖**：开始时使用默认配置，逐步添加功能
- **手动配置**：先手动配置 GitHub Pages，确保理解流程
- **分阶段实施**：分为基础验证、Hugo 集成、主题配置三个阶段

## 仓库结构
- 主仓库：`azhao1981.github.io`（用于 GitHub Pages 用户主页）
- 源码分支：`main` 分支管理 Hugo 源码和配置
- 部署分支：`gh-pages` 分支存放构建后的静态文件
- 构建目录：`public/` 目录通过 gitignore 忽略，仅用于临时构建

---

# 第一阶段：基础验证

## 目标
创建最基础的 GitHub Pages 网站，验证部署流程正常工作。

### 步骤 1：创建仓库和初始分支

```bash
# 创建新的 Git 仓库
git init
git branch -m main

# 创建初始 README
echo "# 我的 GitHub Pages 网站" > README.md
echo "这是我的个人网站，正在建设中..." >> README.md

# 初始提交
git add README.md
git commit -m "🎉 初始化仓库"

# 添加远程仓库（请替换为您的仓库地址）
git remote add origin git@github.com:azhao1981/azhao1981.github.io.git
git push -u origin main
```

### 步骤 2：创建 gh-pages 分支并添加 Hello World

```bash
# 创建 gh-pages 分支
git checkout -b gh-pages

# 清理分支内容（保留 .git 目录）
git rm -rf .

# 创建简单的 HTML Hello World 页面
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的网站 - Hello World</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
        }
        .header {
            text-align: center;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
        }
        .content {
            margin-top: 30px;
        }
        .success {
            color: #28a745;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🎉 Hello World!</h1>
        <p>我的第一个 GitHub Pages 网站成功部署！</p>
    </div>
    <div class="content">
        <h2>部署信息</h2>
        <ul>
            <li>部署时间：<span id="deploy-time"></span></li>
            <li>部署方式：GitHub Pages</li>
            <li>状态：<span class="success">✅ 成功</span></li>
        </ul>
        
        <h2>下一步</h2>
        <p>接下来我们将集成 Hugo 静态网站生成器。</p>
        
        <h2>验证清单</h2>
        <p>请确认以下项目正常工作：</p>
        <ul>
            <li>☐ 网站可以正常访问</li>
            <li>☐ 页面样式显示正确</li>
            <li>☐ 中文显示正常</li>
            <li>☐ 响应式设计正常</li>
        </ul>
    </div>
    
    <script>
        // 显示当前时间
        document.getElementById('deploy-time').textContent = new Date().toLocaleString('zh-CN');
    </script>
</body>
</html>
EOF

# 提交并推送
git add index.html
git commit -m "🚀 添加 Hello World 页面"
git push -u origin gh-pages

# 返回 main 分支
git checkout main
```

### 步骤 3：配置 GitHub Pages（手动）

1. **访问仓库设置**
   - 打开浏览器，访问：`https://github.com/azhao1981/azhao1981.github.io/settings/pages`

2. **配置 GitHub Pages**
   - 在 "Source" 部分选择：
     - Branch: `gh-pages`
     - Directory: `/ (root)`
   - 点击 "Save" 保存设置

3. **等待部署**
   - GitHub Pages 需要几分钟时间来部署
   - 部署状态会在设置页面显示

### 步骤 4：验证部署

```bash
# 检查部署状态
git checkout gh-pages
git log --oneline -1

# 应该看到类似：🚀 添加 Hello World 页面
```

**访问网站验证**：
- 网站地址：`https://azhao1981.github.io`
- 应该显示 "Hello World" 页面
- 检查样式和中文显示是否正常

### 步骤 5：创建验证脚本

创建 `verify-deployment.sh` 脚本：

```bash
#!/bin/bash

echo "🔍 验证 GitHub Pages 部署状态..."

# 检查当前分支
current_branch=$(git branch --show-current)
echo "📋 当前分支: $current_branch"

# 检查 gh-pages 分支是否存在
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "✅ gh-pages 分支存在"
    
    # 检查最新的提交
    echo "📝 gh-pages 最新提交:"
    git log gh-pages --oneline -1
    
    # 检查 index.html 是否存在
    if git show gh-pages:index.html > /dev/null 2>&1; then
        echo "✅ index.html 文件存在"
    else
        echo "❌ index.html 文件不存在"
    fi
else
    echo "❌ gh-pages 分支不存在"
fi

echo "🌐 请访问 https://azhao1981.github.io 验证网站是否正常"
```

设置权限：
```bash
chmod +x verify-deployment.sh
```

运行验证：
```bash
./verify-deployment.sh
```

---

# 第二阶段：Hugo 集成

## 目标
在基础验证成功后，集成 Hugo 静态网站生成器。

### 步骤 1：安装 Hugo

```bash
# 检查 Hugo 是否已安装
hugo version

# 如果未安装，请根据您的操作系统安装 Hugo
# macOS: brew install hugo
# Ubuntu: sudo apt-get install hugo
# Windows: choco install hugo -confirm
```

### 步骤 2：初始化 Hugo 项目

```bash
# 确保在 main 分支
git checkout main

# 创建 Hugo 站点（使用默认配置）
hugo new site . --force

# 创建 .gitignore 文件
cat > .gitignore << 'EOF'
# Hugo 构建输出
public/

# Hugo 资源
resources/_gen/

# 操作系统文件
.DS_Store
Thumbs.db

# 编辑器文件
.vscode/
.idea/
*.swp
*.swo

# 临时文件
*.tmp
*.log

# Node.js
node_modules/
package-lock.json

# 环境变量
.env
.envrc
EOF

# 提交 Hugo 项目结构
git add .
git commit -m "📦 添加 Hugo 项目结构"
git push origin main
```

### 步骤 3：创建基础内容

```bash
# 创建首页内容
cat > content/_index.md << 'EOF'
---
title: "欢迎来到我的博客"
date: 2024-01-01T00:00:00+00:00
---

# 欢迎来到我的博客

这是一个使用 Hugo 构建的个人博客网站。

## 关于本站

本网站使用 Hugo 静态网站生成器构建，部署在 GitHub Pages 上。

## 功能特点

- 快速加载
- 简洁设计
- 易于维护
- 版本控制

## 最新动态

网站正在建设中，敬请期待更多内容！
EOF

# 创建示例文章
cat > content/posts/第一篇文章.md << 'EOF'
---
title: "第一篇文章"
date: 2024-01-01T00:00:00+00:00
draft: false
---

# 我的第一篇文章

这是使用 Hugo 发布的第一篇文章。

## Hugo 简介

Hugo 是一个快速的静态网站生成器，非常适合构建博客和文档网站。

## 为什么选择 Hugo？

- **速度快**：构建时间通常在毫秒级别
- **简单易用**：配置简单，学习曲线平缓
- **主题丰富**：有大量现成的主题可供选择
- **社区活跃**：拥有活跃的开发者社区

## 后续计划

接下来我将：
1. 添加更多主题配置
2. 优化网站样式
3. 添加更多功能
EOF

# 提交内容
git add content/
git commit -m "📝 添加基础内容"
git push origin main
```

### 步骤 4：测试 Hugo 构建

```bash
# 测试本地构建
hugo --minify

# 检查构建结果
ls -la public/
cat public/index.html

# 测试本地服务器
hugo server -D
```

访问 `http://localhost:1313` 查看本地预览。

### 步骤 5：更新部署脚本

创建 `deploy.sh` 脚本：

```bash
#!/bin/bash

set -e

echo "🚀 开始部署流程..."

# 检查是否在 main 分支
if [ "$(git branch --show-current)" != "main" ]; then
    echo "❌ 请在 main 分支上执行部署"
    exit 1
fi

# 构建网站
echo "📦 构建 Hugo 网站..."
hugo --minify

if [ $? -ne 0 ]; then
    echo "❌ Hugo 构建失败"
    exit 1
fi

# 切换到 gh-pages 分支
echo "📋 切换到 gh-pages 分支..."
git checkout gh-pages

# 删除现有文件（除了 .git 目录）
echo "🧹 清理现有文件..."
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} \;

# 复制构建后的文件
echo "📄 复制构建文件..."
cp -r public/* .

# 添加所有变更
echo "💾 提交变更..."
git add .

# 检查是否有变更
if [ -n "$(git status --porcelain)" ]; then
    git commit -m "🚀 Hugo 自动部署: $(date '+%Y-%m-%d %H:%M:%S')"
    
    echo "📤 推送到 gh-pages 分支..."
    git push origin gh-pages
    
    echo "✅ 部署成功！"
else
    echo "ℹ️  没有变更需要部署"
fi

# 返回 main 分支
echo "🔙 返回 main 分支..."
git checkout main

echo "🎉 部署流程完成！"
echo "🌐 访问地址: https://azhao1981.github.io"
```

设置权限：
```bash
chmod +x deploy.sh
```

### 步骤 6：部署并验证

```bash
# 执行部署
./deploy.sh

# 验证部署
./verify-deployment.sh
```

访问 `https://azhao1981.github.io` 验证 Hugo 网站是否正常显示。

---

# 第三阶段：主题配置

## 目标
在 Hugo 基础功能验证成功后，添加主题配置。

### 步骤 1：选择并添加主题

```bash
# 确保在 main 分支
git checkout main

# 添加 hugo-book 主题（或其他您喜欢的主题）
git submodule add https://github.com/alex-shpak/hugo-book.git themes/hugo-book

# 复制主题配置示例
cp themes/hugo-book/exampleSite/config.toml hugo.toml
```

### 步骤 2：配置 Hugo

编辑 `hugo.toml` 文件：

```toml
baseURL = "https://azhao1981.github.io"
title = "我的博客"
theme = "hugo-book"
languageCode = "zh-cn"
defaultContentLanguage = "zh"
publishDir = "public"

# 启用中文搜索
[params]
  BookSearch = true
  BookToC = true
  BookSection = "docs"
  BookRepo = "https://github.com/azhao1981/azhao1981.github.io"
  BookEditPath = "edit/main/content/"

# 菜单配置
[menu]
  [[menu.main]]
    name = "首页"
    url = "/"
    weight = 1
  [[menu.main]]
    name = "文章"
    url = "/posts/"
    weight = 2
  [[menu.main]]
    name = "文档"
    url = "/docs/"
    weight = 3

# Goldmark 配置
[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true
```

### 步骤 3：创建文档结构

```bash
# 创建文档目录
mkdir -p content/docs

# 创建文档首页
cat > content/docs/_index.md << 'EOF'
---
title: "文档"
weight: 1
---

# 技术文档

这里存放各种技术文档和笔记。
EOF

# 提交配置变更
git add .
git commit -m "🎨 添加 hugo-book 主题配置"
git push origin main
```

### 步骤 4：最终部署

```bash
# 执行最终部署
./deploy.sh

# 验证最终部署
./verify-deployment.sh
```

---

# 常用脚本和命令

## 开发脚本

创建 `dev.sh` 脚本：

```bash
#!/bin/bash

echo "🔥 启动 Hugo 开发服务器..."
echo "🌐 本地地址: http://localhost:1313"
echo "⏹️  按 Ctrl+C 停止服务器"

hugo server -D --disableFastRender
```

创建 `new-post.sh` 脚本：

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "❌ 请提供文章标题"
    echo "用法: ./new-post.sh \"文章标题\""
    exit 1
fi

TITLE="$1"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9\u4e00-\u9fa5]/-/g' | sed 's/--*/-/g' | sed 's/^-*|-*$//g')
DATE=$(date '+%Y-%m-%d')
FILENAME="content/posts/${DATE}-${SLUG}.md"

echo "📝 创建新文章: $FILENAME"
hugo new posts/"${DATE}-${SLUG}.md"

echo "✅ 文章创建成功！"
echo "📝 文件位置: $FILENAME"
echo "🔥 编辑后可以使用 ./dev.sh 预览"
echo "🚀 准备好后使用 ./deploy.sh 部署"
```

设置权限：
```bash
chmod +x dev.sh new-post.sh
```

## 常用命令

```bash
# 查看网站
hugo server

# 构建网站
hugo --minify

# 创建新内容
hugo new posts/文章名.md

# 查看构建后的文件
ls public/

# 查看分支状态
git branch -a

# 切换到 gh-pages 分支
git checkout gh-pages

# 验证部署
./verify-deployment.sh
```

---

# 故障排除

### 常见问题

1. **网站无法访问**
   - 检查 GitHub Pages 设置是否正确
   - 确认 gh-pages 分支有内容
   - 等待几分钟（部署需要时间）

2. **Hugo 构建失败**
   - 检查配置文件语法
   - 确认主题正确安装
   - 查看错误日志

3. **部署失败**
   - 确认 Git 权限正确
   - 检查网络连接
   - 验证分支名称正确

4. **中文显示问题**
   - 确认文件编码为 UTF-8
   - 检查 HTML 头部的 charset 设置

### 验证清单

每个阶段完成后，请确认：

- [ ] 第一阶段：Hello World 页面正常显示
- [ ] 第二阶段：Hugo 基础网站正常工作
- [ ] 第三阶段：主题配置正确应用
- [ ] 所有链接正常工作
- [ ] 中文显示正常
- [ ] 响应式设计正常

---

**创建日期**: 2024-08-17  
**最后更新**: 2024-08-17  
**作者**: weiz  
**版本**: 4.0 (渐进式部署方案)