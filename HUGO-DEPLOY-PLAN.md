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
1. 初始化 Hugo 项目：`hugo new site .`
2. 创建 `content/_index.md` 首页
3. 创建 `content/posts/` 文章目录
4. 测试本地构建：`hugo --minify`
5. 部署到 `gh-pages` 分支

**第三阶段 - 主题配置**
1. 添加主题：`git submodule add https://github.com/alex-shpak/hugo-book.git themes/hugo-book`
2. 配置 `hugo.toml` 文件
3. 创建文档结构 `content/docs/`
4. 最终部署验证