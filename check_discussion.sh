#!/bin/bash
echo "=== Hydro v5 讨论功能诊断 ==="

# 基础路径
UI_DIR="packages/ui-default"

# 1. 检查讨论组件
echo "1. 讨论组件目录:"
if [ -d "$UI_DIR/components/discussion" ]; then
    echo "✅ 找到讨论组件目录"
    ls -la "$UI_DIR/components/discussion/"
else
    echo "❌ 讨论组件目录不存在"
    # 查找是否有其他位置的讨论组件
    find "$UI_DIR" -type f -name "*.vue" | xargs grep -l "discussion" | head -5
fi

# 2. 检查侧边栏
echo -e "\n2. 侧边栏组件:"
find "$UI_DIR" -name "*sidebar*.vue" -type f | while read file; do
    echo "检查: $file"
    if grep -q "discussion" "$file"; then
        echo "  ✅ 包含讨论相关代码"
        grep -n "discussion" "$file" | head -3 | sed 's/^/    /'
    else
        echo "  ❌ 不包含讨论代码"
    fi
done

# 3. 检查路由
echo -e "\n3. 路由配置:"
find "$UI_DIR" -name "routes.ts" -o -name "*.routes.ts" | while read file; do
    if grep -q "discussion" "$file"; then
        echo "找到讨论路由: $file"
        grep -n "discussion" "$file" | head -5 | sed 's/^/  /'
    fi
done

# 4. 检查权限常量
echo -e "\n4. 权限检查:"
find "$UI_DIR" -name "*.ts" -type f | xargs grep -l "PERM.*DISCUSSION" | head -5

# 5. 检查构建状态
echo -e "\n5. 构建状态:"
if [ -d "$UI_DIR/build" ]; then
    echo "构建目录存在，检查讨论相关文件:"
    find "$UI_DIR/build" -name "*.js" -type f | xargs grep -l "discussion" 2>/dev/null | head -3
else
    echo "⚠️ 未找到构建目录，可能需要构建"
fi

# 6. 检查API
echo -e "\n6. API接口检查:"
find packages/hydrooj -name "discussion.ts" -type f 2>/dev/null | head -5

# 7. 检查数据库模型
echo -e "\n7. 数据库模型:"
mongo hydro --quiet --eval "
db.document.find({docType:'discussion'}).count();
" 2>/dev/null || echo "无法连接MongoDB"

echo -e "\n=== 诊断结束 ==="
