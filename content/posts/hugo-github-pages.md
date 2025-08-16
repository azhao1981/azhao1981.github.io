---
title: "Hugo GitHub Pages 部署计划"
date: 2024-01-01T00:00:00+00:00
draft: false
---

# Hugo GitHub Pages 部署计划

本文详细记录了如何使用 Hugo 静态网站生成器和 GitHub Pages 构建个人博客网站的完整过程。

## 🎯 部署概要

**目标**: 使用 Hugo 构建个人博客，通过 GitHub Pages 托管  
**网站地址**: https://azhao1981.github.io  
**部署状态**: 已成功部署并运行

### 技术栈
- Hugo 静态网站生成器
- GitHub Pages 托管服务
- hugo-book 主题
- Git 版本控制

## 🚀 快速部署指南

### 自动部署（推荐）
创建部署脚本 `deploy.sh`：
```bash
#!/bin/bash

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
echo "🌐 网站地址: https://yourusername.github.io"
```

### 手动部署
```bash
# 构建 Hugo 网站
hugo --minify --cleanDestinationDir

# 提交并推送
cd public
git add .
git commit -m "手动部署: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin gh-pages
cd ..
```

## 📋 详细部署步骤

### 第一阶段 - 基础验证
1. 创建 `gh-pages` 分支
2. 添加 Hello World 页面
3. 配置 GitHub Pages 设置
4. 验证网站可访问

### 第二阶段 - Hugo 集成
1. 初始化 Hugo 项目：`hugo new site . --force`
2. 创建首页和文章内容
3. 添加主题配置
4. 测试本地构建

### 第三阶段 - 主题配置
1. 添加 hugo-book 主题
2. 配置 `hugo.toml` 文件
3. 创建文档结构
4. 完善网站功能

## 🔧 配置说明

### Hugo 配置文件 (hugo.toml)
```toml
baseURL = 'https://yourusername.github.io/'
languageCode = 'zh-cn'
title = '你的网站标题'
theme = 'hugo-book'

[params]
BookToC = true
BookSection = 'docs'

[markup.goldmark.renderer]
unsafe = true
```

### 主题特性
- 📚 响应式设计
- 🔍 内置搜索功能
- 🎨 支持深色/浅色主题
- 💻 代码高亮
- 📊 数学公式支持
- 🌐 多语言支持

## 📁 项目文件结构
```
your-repo/
├── hugo.toml                 # Hugo 配置文件
├── deploy.sh                 # 自动部署脚本
├── content/                  # 网站内容
│   ├── _index.md            # 首页
│   └── posts/               # 博客文章
├── themes/                   # Hugo 主题
│   └── hugo-book/           # hugo-book 主题
├── public/                   # 构建输出（gh-pages 分支）
└── HUGO-DEPLOY-PLAN.md      # 部署计划文档
```

## 📝 内容管理

### 创建新文章
```bash
# 创建新文章
hugo new posts/文章标题.md

# 编辑文章
vim content/posts/文章标题.md
```

### 文章格式示例
```markdown
---
title: "文章标题"
date: 2024-01-01T00:00:00+00:00
draft: false
---

# 文章标题

这里是文章内容...

## 小节标题

更多内容...
```

## 🛠️ 常见问题解决

### 1. Hugo 构建失败，提示找不到模板
**解决**: 添加主题
```bash
git submodule add https://github.com/alex-shpak/hugo-book.git themes/hugo-book
```

### 2. YAML front matter 格式错误
**解决**: 确保 `---` 前后没有空格，日期格式正确

### 3. public/index.html 没有生成
**解决**: 检查 `content/_index.md` 文件格式和内容

### 4. 首页不显示最新文档
**解决**: 在首页内容中使用 Hugo 的 ref 短代码添加文章链接，具体格式参考 Hugo 官方文档

### 5. 主题样式不生效
**解决**: 确保 `hugo.toml` 中 `theme = 'hugo-book'` 配置正确

## 🔍 验证命令
```bash
# 检查构建结果
ls -la public/index.html

# 检查文章是否生成
ls -la public/posts/

# 本地测试
hugo server -D

# 检查网站是否可访问
curl -s -o /dev/null -w "%{http_code}" https://yourusername.github.io
```

## 🎯 下一步计划

### 内容扩展
- 添加更多技术文章
- 创建文档分类
- 添加标签系统

### 功能增强
- 添加评论系统
- 集成 Google Analytics
- 添加 RSS 订阅

### 性能优化
- 图片优化
- 缓存策略
- CDN 集成

## 💡 部署心得

1. **分阶段验证**: 每个阶段都要确保功能正常再进行下一步
2. **自动化部署**: 使用脚本可以大大简化部署流程
3. **版本控制**: 保持源码和部署文件的分离管理
4. **主题选择**: 选择成熟的主题可以节省大量开发时间
5. **中文支持**: 确保 Hugo 配置中的语言设置正确

## 📚 参考资源

- [Hugo 官方文档](https://gohugo.io/documentation/)
- [hugo-book 主题文档](https://github.com/alex-shpak/hugo-book)
- [GitHub Pages 官方文档](https://pages.github.com/)
- [Git 基础教程](https://git-scm.com/doc)

---

**发布时间**: 2024-01-01  
**最后更新**: 2025-08-17  
**部署状态**: ✅ 已完成并正常运行

通过这个完整的部署计划，你可以轻松搭建自己的 Hugo 博客网站。如果遇到问题，可以参考故障排除部分或者查看官方文档。