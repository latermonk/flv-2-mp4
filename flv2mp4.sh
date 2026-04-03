#!/bin/bash

# FLV 批量转 MP4 脚本
# 转换模式：复制音视频流（极速，不损画质）
# 用法：chmod +x flv2mp4.sh && ./flv2mp4.sh

echo "========================================="
echo "      FLV 批量转换为 MP4 脚本"
echo "========================================="

# 检查 ffmpeg 是否安装
if ! command -v ffmpeg &> /dev/null; then
    echo "错误：未安装 ffmpeg，请先安装！"
    exit 1
fi

# 统计文件数量
total=$(ls -1 *.flv 2>/dev/null | wc -l)
if [ "$total" -eq 0 ]; then
    echo "当前目录没有找到 FLV 文件"
    exit 0
fi

echo "✅ 找到 $total 个 FLV 文件，开始转换..."
echo ""

success=0
fail=0

# 遍历所有 FLV 文件
for file in *.flv; do
    # 跳过非文件（避免目录干扰）
    [ -f "$file" ] || continue

    # 输出文件名（替换 .flv 为 .mp4）
    output="${file%.flv}.mp4"

    echo "-----------------------------------------"
    echo "处理中：$file"
    echo "输出为：$output"

    # 极速转换：复制视频流 + 复制音频流（不重新编码）
    ffmpeg -i "$file" -c copy -y "$output" -hide_banner -loglevel error

    # 检查转换结果
    if [ $? -eq 0 ] && [ -f "$output" ]; then
        echo "✅ 转换成功"
        ((success++))
    else
        echo "❌ 转换失败"
        ((fail++))
    fi
done

echo ""
echo "========================================="
echo "转换完成！"
echo "成功：$success 个"
echo "失败：$fail 个"
echo "========================================="