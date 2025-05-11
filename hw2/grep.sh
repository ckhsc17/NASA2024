#!/bin/bash

# 假設你有一個包含路徑的變數
full_path="dir2/code/output4.txt"

# 使用 grep 來提取 dir2 後的部分
dir2_part=$(echo "$full_path" | sed 's/.*dir2\///')

# 印出結果
echo "Original path: $full_path"
echo "Extracted part: $dir2_part"
