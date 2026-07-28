# ROS2 机器人测试 + 大模型评测 · 系统学习路线

> 38岁被裁后边学边整理的转型笔记。不是教程，是一个正在进行的实验。
> 6模块 / 持续更新中 —— 从ROS2传统测试到大模型评测+具身智能。

---

## 这是什么

一个普通测试工程师转型机器人测试 + 大模型评测的完整学习记录。

点进来你能拿到三样东西：
- 🗺️ 6模块学习路线 + 环境准备（Nav2→ROS2测试→大模型评测→CI/CD→具身智能）
- 🐛 5篇样本踩坑笔记（场景→现象→根因→修复，帮你省掉自己瞎摸索的时间）
- 🧠 一套跨技术栈的通用诊断方法

边做边更，成功了是经验，失败了是教训。觉得有用点个 ⭐ Star～

---

## 适合谁 / 不适合谁

✅ **适合你，如果：**
- 有Python基础的测试工程师，想往机器人/大模型方向转型
- 30+遇到职业瓶颈、想找新方向的测试同行
- 正在学ROS2，但不知道"测试视角"应该重点看什么
- 想做LLM评测但不知道从哪入手

❌ **不适合你，如果：**
- 零基础，连Python和Linux都没接触过
- 想找"30天速成拿高薪"的捷径
- 关注的是算法开发，不是测试验证

---

## 快速导航

- 🗺️ [完整学习路线图](./resources/learning-roadmap.md) —— 6模块学习顺序、资源清单、时间规划
- 📋 [命令速查表](./resources/commands-cheatsheet.md) —— ROS2 / Nav2 / pytest / RAGAS 常用命令一页纸

### 5篇样本踩坑笔记

以「场景→现象→根因→修复」为主线，附关键教训：

1. [代价地图配置踩坑记录](./samples/sample-notes.md)
2. [pytest/mock/launch_testing 测试入门（含launch_testing卡死坑）](./samples/sample-module2-pytest-ci.md)
3. [QoS/生命周期/rosbag2 进阶测试（含QoS静默丢消息）](./samples/sample-module3-qos-lifecycle.md)
4. [BLEU短句零分 + RAGAS本地实现——大模型评测入门](./samples/sample-module4-llm-eval.md)
5. [DVC/MLflow/Allure 全链路CI/CD搭建（含DVC command not found）](./samples/sample-module5-cicd.md)

---

## 两条核心管线

### ROS2测试管线
单元测试（pytest+mock）→ 集成测试（launch_testing）→ 回归测试（rosbag2）→ CI自动化（GitHub Actions）

### LLM评测管线
基础指标（BLEU/ROUGE/BERTScore）→ 综合评测（MMLU）→ RAG评测（RAGAS）→ 工具调用评测

### 统一CI管线
pytest跑ROS2测试 + MMLU跑大模型评测，统一输出Allure报告，带阈值门禁。

---

## 模块进度

| 模块 | 状态 |
|------|------|
| 一、Nav2导航基础 | ✅ 核心概念已掌握 |
| 二、传统测试基础（pytest/launch_testing/CI） | ✅ 已完成 |
| 三、ROS2进阶测试（回调组/生命周期/QoS/rosbag2） | ✅ 已完成 |
| 四、大模型测试（MMLU/BLEU/ROUGE/RAGAS/工具调用） | ✅ 已完成 |
| 五、CI/CD自动化（DVC/MLflow/GitHub Actions/Allure） | ✅ 已完成 |
| 六、具身智能测试（LLM+ROS2端到端） | 🔍 方案设计中 |

---

## 完整课程结构（预计学习周期）

> 前置：[环境准备](./modules/00-environment-setup.md)（WSL2 + ROS2 Humble + 工具链）

**模块一：Nav2导航基础（第1-2周）**
├── 环境搭建：Ubuntu + ROS2 + Nav2
├── 核心概念：节点/话题/服务/动作/QoS
├── Nav2架构：代价地图/AMCL/行为树/规划器
└── 理解机器人导航基本概念

**模块二：传统测试基础（第3-4周）**
├── pytest + fixture + mock
├── ROS2 launch_testing
├── 单元测试 + 集成测试
└── CI基础：GitHub Actions

**模块三：ROS2进阶测试（第5-6周）**
├── 回调组与死锁
├── 生命周期节点
├── QoS兼容性测试
└── rosbag2回归测试

**模块四：大模型测试（第7-9周）**
├── 基础指标：BLEU/ROUGE/BERTScore
├── 综合评测：MMLU
├── RAG评测：RAGAS
└── 工具调用评测 + 压测

**模块五：CI/CD自动化（第10-11周）**
├── DVC数据版本控制
├── MLflow实验管理
├── 统一CI管线搭建
└── Allure报告 + 阈值门禁

**模块六：具身智能测试（第12-16周）**
├── LLM → 中间层 → ROS2
├── 端到端测试方案
├── 失败根因自动分析（LLM辅助）
└── 持续探索中...

---

## 怎么用

1. 先看"适合谁"——确认这个仓库对你有没有用
2. 翻几篇踩坑笔记——感受一下内容质量和风格
3. 按模块顺序学——从模块一开始，循序渐进
4. 动手跑，别光看——每个demo都自己敲一遍
5. 记笔记——用自己的话重述一遍，比看十遍教程都管用

---

## 更新计划

- 不定期更新踩坑笔记和模块进展
- 模块六（具身智能测试）持续推进，有进展就更
- 如果找到工作，会更新面试复盘和入职后的实战对比

---

## 交流

- 💬 有问题欢迎提 [Issue](https://github.com/zzluogh/ros2-ai-testing-roadmap/issues)
- 📝 知乎：[@曙光](https://www.zhihu.com/people/shu-guang-2-30-45)
- ⭐ 觉得有用点个Star，边做边更～