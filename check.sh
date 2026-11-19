#!/usr/bin/env bash
# 站点零外部依赖自检：防止有人误加境外 CDN / 字体 / 统计 / Release 直链
set -u
RISK='fonts\.googleapis|fonts\.gstatic|cdn\.jsdelivr|unpkg\.com|cdnjs\.cloudflare'
RISK+='|google-analytics|googletagmanager|gtag\(|hm\.baidu'
RISK+='|raw\.githubusercontent|codeload\.github|objects\.githubusercontent'
RISK+='|releases\/download|polyfill\.io|staticfile\.org|bootcdn'
fail=0
while IFS= read -r f; do
  hits=$(grep -nEo "$RISK" "$f" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "[风险] $f"; echo "$hits" | sed 's/^/    /'; fail=1
  fi
done < <(find . -type f \( -name '*.html' -o -name '*.css' -o -name '*.js' \) -not -path './downloads/*')
if [ "$fail" -eq 0 ]; then echo "[通过] 未发现高风险外部依赖"; else echo "[失败] 请移除上述引用后再发布"; exit 1; fi
