#!/bin/bash
cd ~/hydro/Hydro

echo "=== HydroOJ 讨论功能修复 ==="
echo "工作目录: $(pwd)"

# 1. 停止
echo "停止服务..."
sudo systemctl stop hydrooj 2>/dev/null || true
pm2 stop hydrooj 2>/dev/null || true
pkill -f "node.*[Hh]ydro" 2>/dev/null || true
sleep 2

# 2. 清除缓存
echo "清除缓存..."
redis-cli flushall 2>/dev/null || echo "Redis: 跳过"
rm -rf /tmp/hydro* /tmp/.hydro* ~/.cache/hydro* 2>/dev/null || true
rm -rf cache 2>/dev/null || true
rm -rf node_modules/.cache 2>/dev/null || true

# 3. 检查前端资源
echo "检查前端资源..."
if [ -d "public" ]; then
    echo "找到 public 目录，确保资源完整"
    # 可以尝试重新下载或复制资源
else
    echo "未找到 public 目录"
fi

# 4. 启动
echo "启动服务..."
if [ -f "package.json" ]; then
    # 检查启动脚本
    START_SCRIPT=$(node -e "console.log(require('./package.json').scripts.start || '')")
    if [[ "$START_SCRIPT" == *"server.js"* ]] && [ -f "server.js" ]; then
        echo "使用 npm start 启动..."
        nohup npm start > hydrooj.log 2>&1 &
    elif [ -f "server.js" ]; then
        echo "直接启动 server.js..."
        NODE_ENV=production nohup node server.js > hydrooj.log 2>&1 &
    else
        echo "尝试默认启动..."
        nohup node . > hydrooj.log 2>&1 &
    fi
else
    echo "尝试启动 server.js..."
    nohup node server.js > hydrooj.log 2>&1 &
fi

# 5. 验证
echo "等待10秒..."
sleep 10

if curl -s http://localhost:8888 >/dev/null; then
    echo "✅ HydroOJ 启动成功！"
    echo "请访问: http://localhost:8888"
    echo "如果讨论还不显示，请:"
    echo "1. 强制刷新浏览器: Ctrl+Shift+R"
    echo "2. 清除浏览器缓存"
else
    echo "❌ 启动可能失败，查看日志:"
    tail -30 hydrooj.log 2>/dev/null || echo "无法读取日志"
fi