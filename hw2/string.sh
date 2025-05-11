#!/bin/bash

original_string="Hello, World!"

# 取得 "World!" 之後的字串
substring="${original_string##*,}"

echo "Original String: $original_string"
echo "Substring: $substring"

