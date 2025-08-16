# Hugo GitHub Pages 渐进式部署计划

## 方案概要

**目标**: 使用 Hugo 构建个人博客，通过 GitHub Pages 托管

### 仓库结构
- 主仓库：`azhao1981.github.io`
- 源码分支：`main` 分支管理 Hugo 源码
- 部署分支：`gh-pages` 分支存放静态文件
- 目录 public/* 使用 gitignore 然后 checkout  `gh-pages`

### 步骤
1. quick start - 创建 Hello World 页面，验证 GitHub Pages 部署流程
2. Hugo 集成 - 添加 Hugo 静态网站生成器，创建基础内容
3. 主题配置 - 配置 hugo-book 主题，完善网站功能

### 部署方式
- 手动配置 GitHub Pages 设置
- 使用部署脚本自动化构建和发布
- 分阶段验证，确保每步成功

### 具体步骤
**第一阶段 - 基础验证**
1. 创建 `gh-pages` 分支：
   ```bash
   mkdir public && cd public
   git clone git@github.com:azhao1981/azhao1981.github.io.git .
   git checkout -b gh-pages
   git push --set-upstream origin gh-pages
   ```
2. 添加 `index.html` Hello World 页面：
   ```bash
   cat > index.html << 'EOF'
   <!DOCTYPE html>
   <html lang="zh-CN">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>我的网站 - Hello World</title>
   </head>
   <body>
       <h1>🎉 Hello World!</h1>
       <p>GitHub Pages 部署成功</p>
   </body>
   </html>
   EOF
   git add index.html
   git commit -m "添加 Hello World 页面"
   git push origin gh-pages
   ```

3. 配置 GitHub Pages 设置：
   - 访问：`https://github.com/azhao1981/azhao1981.github.io/settings/pages`
   - Source 选择：`gh-pages` 分支，`/ (root)` 目录
   - 点击 Save 保存

4. 验证网站可访问： https://azhao1981.github.io


**第二阶段 - Hugo 集成**
1. 初始化 Hugo 项目：`hugo new site . --force`
2. 创建 `content/_index.md` 首页：
   ```bash
   cat > content/_index.md << 'EOF'
   ---
   title: "欢迎来到我的博客"
   date: 2024-01-01T00:00:00+00:00
   ---
   
   # 欢迎来到我的博客
   
   这是一个使用 Hugo 构建的个人博客网站。
   
   ## 关于本站
   
   本网站使用 Hugo 静态网站生成器构建，部署在 GitHub Pages 上。
   EOF
   ```

3. 创建 `content/posts/` 文章目录和示例文章：
   ```bash
   mkdir -p content/posts
   cat > content/posts/示例文章.md << 'EOF'
   ---
   title: "第一篇文章"
   date: 2024-01-01T00:00:00+00:00
   draft: false
   ---
   
   # 我的第一篇文章
   
   这是使用 Hugo 发布的第一篇文章。
   
   ## Hugo 简介
   
   Hugo 是一个快速的静态网站生成器。
   EOF
   ```

4. 测试本地构建：
   ```bash
   # 如果 Hugo 提示找不到模板文件，需要先添加主题
   git submodule add https://github.com/alex-shpak/hugo-book.git themes/hugo-book
   
   # 配置主题到 hugo.toml
   echo "theme = 'hugo-book'" >> hugo.toml
   
   # 重新构建
   hugo --minify --cleanDestinationDir
   ls -la public/
   
   # 测试本地服务器：hugo server -D
   ```

5. 部署到 `gh-pages` 分支：
   ```bash
   cd public
   git add .
   git commit -m "Hugo 构建部署: $(date '+%Y-%m-%d %H:%M:%S')"
   git push origin gh-pages
   cd ..
   ```

**第三阶段 - 主题配置**
1. 添加主题：`git submodule add https://github.com/alex-shpak/hugo-book.git themes/hugo-book`
2. 配置 `hugo.toml` 文件：
   ```bash
   cat > hugo.toml << 'EOF'
   baseURL = 'https://azhao1981.github.io/'
   languageCode = 'zh-cn'
   title = 'AI重构你的知识体系'
   theme = 'hugo-book'
   
   [params]
   BookToC = true
   BookSection = 'docs'
   
   [markup.goldmark.renderer]
   unsafe = true
   EOF
   ```
3. 创建文档结构 `content/docs/`
4. 更新首页显示最新文档：
   ```bash
   cat > content/_index.md << 'EOF'
   ---
   title: "欢迎来到我的博客"
   date: 2024-01-01T00:00:00+00:00
   ---
   
   # 欢迎来到我的博客
   
   这是一个使用 Hugo 构建的个人博客网站。
   
   ## 关于本站
   
   本网站使用 Hugo 静态网站生成器构建，部署在 GitHub Pages 上。
   
   ## 最新文档
   
   - [Hugo GitHub Pages 部署计划]({{< ref "posts/hugo-github-pages" >}})
   EOF
   ```
5. 最终部署验证：
   ```bash
   hugo --minify --cleanDestinationDir
   cd public
   git add .
   git commit -m "最终部署: $(date '+%Y-%m-%d %H:%M:%S')"
   git push origin gh-pages
   cd ..
   ```

## 故障排除

### 常见问题

1. **Hugo 构建失败，提示找不到模板**
   - 解决：添加主题 `git submodule add https://github.com/alex-shpak/hugo-book.git themes/hugo-book`

2. **YAML front matter 格式错误**
   - 解决：确保 `---` 前后没有空格，日期格式正确

3. **public/index.html 没有生成**
   - 解决：检查 `content/_index.md` 文件格式和内容

4. **首页不显示最新文档**
   - 解决：使用短代码 `{{< ref "posts/文件名" >}}` 添加链接

### 验证命令
```bash
# 检查构建结果
ls -la public/index.html

# 检查文章是否生成
ls -la public/posts/

# 本地测试
hugo server -D
```