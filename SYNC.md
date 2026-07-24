# 同步工作流

> 学习在原 `test_ws` 仓库进行，公开内容手动精选同步到本 `public_repo`

---

## 每周同步清单（周五花 15 分钟）

### Step 1：扫一眼本周学习日志

```bash
ls -la ~/test_ws/learning_logs/ | tail -7
```

### Step 2：挑 2-3 个值得公开的"坑"

从本周笔记中选：典型问题 + 原因分析 + 解决方案

追加到 `samples/` 目录：
- 新建文件如 `samples/week3-rosbag-pitfalls.md`
- 或者追加到现有文件底部

### Step 3：更新模块文件

本周如果有新发现（更好的教程链接、补充的概念），更新对应 `modules/` 文件。

### Step 4：更新 README 进度

在 README 底部可以加一句当前进度，如 `> 当前进度：第 22/43 课（2026-07-24）`

### Step 5：更新 CHANGELOG

记录本周追加的内容要点。

### Step 6：提交并推送

```bash
cd ~/test_ws/public_repo
git add -A
git commit -m "sync: week N - [本周学了什么，一句话]"
git push
```

---

## 注意事项

| 原则 | 说明 |
|------|------|
| **只增不改** | 源学习日志永远从 `test_ws` 消费，public_repo 只做精选追加 |
| **不自动同步** | 全量同步会破坏分层策略，必须手动挑"值得公开的内容" |
| **30% 法则** | 每次同步只放 30% 内容作为样本，完整版标注"持续更新中" |
| **清理路径** | 从 test_ws 搬运内容时，检查是否有 Windows 绝对路径 / 个人邮箱等 |
