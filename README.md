# 测试工程师转型 AI 机器人测试 — 3 个月学习路线

> 102 天 / 43 课 / 6 模块 —— 从 ROS2 传统测试到大模型评测 + 具身智能

---

## 这是什么

一份为**传统测试工程师**设计的系统化转型路线，目标是从零掌握 **ROS2 机器人测试 + 大模型评测 + CI/CD 自动化** 三项核心能力。

每个模块都给出了：
- 学习目标
- 推荐教程链接
- 关键概念速查
- 实操任务和验证标准

## 适合谁

- 有 Python 基础的测试工程师，想往机器人/AI 方向转型
- 正在学 ROS2，但不知道"测试视角"应该重点看什么
- 想做 LLM 评测但不知道从哪入手

## 课程结构

| 模块 | 内容 | 课时 | 预计时间 |
|------|------|------|---------|
| [〇 环境准备](./modules/00-environment-setup.md) | WSL2 + ROS2 Humble + 工具链 | 2 课 | 课前完成 |
| [一 Nav2 导航基础](./modules/01-nav2-basics.md) | 安装、架构、代价地图、AMCL、行为树 | 8 课 | 第 1-2 周 |
| [二 传统测试基础](./modules/02-testing-fundamentals.md) | pytest/fixture/mock/CI/launch_testing | 7 课 | 第 3-4 周 |
| [三 ROS2 进阶](./modules/03-ros2-advanced.md) | 回调组/生命周期/QoS/rosbag2/tf2/Action | 7 课 | 第 5-7 周 |
| [四 大模型测试](./modules/04-llm-testing.md) | MMLU/BLEU/ROUGE/RAGAS/工具调用/长上下文 | 10 课 | 第 8-11 周 |
| [五 CI/CD 自动化](./modules/05-cicd-automation.md) | DVC/MLflow/GitHub Actions/Allure/CLI 工具 | 6 课 | 第 12-14 周 |
| [六 具身智能测试（选修）](./modules/06-embodied-ai.md) | ROS2+LLM 桥接/仿真安全/指令校验 | 5 课 | 第 15-16 周 |

## 快速导航

- [完整学习路线图](./resources/learning-roadmap.md) — 102 天日计划
- [命令速查表](./resources/commands-cheatsheet.md) — pytest / ros2 / CI 常用命令
- [样本笔记](./samples/sample-notes.md) — Nav2 代价地图学习笔记示例

## 使用方式

1. **自学者**：按模块顺序推进，每课 1.5~2 小时，周末复习
2. **选学**：直接跳到感兴趣模块——各模块相对独立
3. **建议硬件**：8GB RAM + WSL2 Ubuntu 22.04 + Google Colab（LLM 部分）

## 更新日志

详见 [CHANGELOG.md](./CHANGELOG.md)

## 许可证

[CC BY-NC-SA 4.0](./LICENSE) — 署名-非商业使用-相同方式共享

---

> 持续更新中。如果这份路线对你有帮助，欢迎 Star / Watch 关注后续更新。
