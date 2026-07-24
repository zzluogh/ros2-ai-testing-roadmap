#!/bin/bash
# 一键同步 public_repo 到 GitHub
# 用法：bash ~/test_ws/public_repo/sync.sh "本次更新描述"
cd ~/test_ws/public_repo
git add -A
git commit -m "${1:-sync update}" || echo "nothing to commit"
git push
