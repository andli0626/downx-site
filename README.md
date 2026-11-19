# DownX 产品发布页（静态站）

零外部依赖的单页静态站，用于分发 DownX v3.1.39 的六端产物。设计约束来自《GitHub Pages 国内访问分析与发布方案》：
单页纯静态、系统字体、内联 SVG、下载走同源相对路径、不用 Release 直链。

## 目录

```
site/
├── index.html          # 页面本体：内联 CSS/JS，无任何外链（含 favicon 也是内联 data URI）
├── downloads/          # 10 个平台产物（224 MB），文件名与页面链接严格一致
├── .nojekyll           # 空文件，防止 GitHub Pages 的 Jekyll 处理路径
├── check.sh            # 零外部依赖 / Release 直链自检
└── README.md
```

`assets/` 目前为空：hero 的应用窗口是纯 CSS + 内联 SVG 绘制的，页面不引任何图片。

## 本地预览

```bash
cd site && python3 -m http.server 8911 --bind 127.0.0.1
# 打开 http://127.0.0.1:8911/index.html
```

直接双击 `index.html` 也能看，但 `file://` 下部分浏览器对 `download` 属性的行为不一致，验证下载请用本地服务。

## 发布前自检

```bash
cd site && ./check.sh
# [通过] 未发现高风险外部依赖
```

扫描项：Google Fonts / gstatic、jsDelivr、unpkg、cdnjs、GA/GTM/百度统计、
raw.githubusercontent、codeload、objects.githubusercontent、`releases/download`、
polyfill.io、staticfile、bootcdn。

## 发布到 GitHub Pages

1. 仓库必须是 **public**（私有库开 Pages 需要 GitHub Pro）。
2. Settings → Pages → Source 选 `Deploy from a branch`，分支 `main`，目录 `/site`（或把 `site/` 内容推到 `gh-pages` 分支根目录）。
3. 访问 `https://<owner>.github.io/<repo>/`，锚点入口：`#features`、`#platforms`、`#manual`、`#download`、`#about`。

## 两个必须知道的限制

- **`downloads/` 共 224 MB**，其中 `DownX_3.1.39_amd64.AppImage` 为 90 MB（GitHub 单文件上限 100 MB，未超）。
  把产物提交进仓库会把 git 历史永久撑大；更稳的做法是只提交页面，把 `downloads/` 放到
  Pages 同源的静态目录（对象存储 / 自有服务器），或定期用 `git filter-repo` 清理。
- GitHub Pages 免费额度：站点 ≤ 1 GB、月流量 100 GB 软限。224 MB 的产物被反复下载时，流量比页面本身更先触顶。

## 更新发布页

改版本时按顺序替换：`index.html` 里的版本号（真实值见首屏徽标、平台卡、下载卡、版本表）、
`downloads/` 里的文件名、`#about` 的提交号与 Actions run 号。改完跑一次 `./check.sh`。
