# 模块二：传统测试基础

> 7 课 / 第 3-4 周

---

## 课程总览

| 课时 | 主题 | 学习目标 |
|------|------|---------|
| 第 9 课 | pytest 入门 | 掌握 assert、fixture、test discovery |
| 第 10 课 | fixture 与 conftest | 用 fixture 管理共享资源，理解 scope 参数 |
| 第 11 课 | mock 隔离依赖 | 用 Mock 模拟 ROS2 话题/服务，不启动真实节点 |
| 第 12 课 | 测试用例设计方法 | 等价类划分 + 边界值分析，为 Nav2 参数写结构化用例 |
| 第 13 课 | launch_testing 集成测试 | 用 launch_testing 做 ROS2 节点集成测试 |
| 第 14 课 | GitHub Actions CI | 配置 push 后自动跑 pytest |
| 第 15 课 | 模块二结课项目 | 为 ROS2 Python 节点补单元/集成/参数测试 + CI 通过 |

---

## 关键概念

### 测试金字塔（ROS2 适配版）

```
         ┌──────┐
         │ E2E  │  少但真实：回放 bag → Nav2 完整导航
         ├──────┤
         │ 集成  │  launch_testing：启动节点 → 断言话题/服务
         ├──────┤
         │ 单元  │  mock 话题输入 → 断言回调逻辑
         └──────┘
```

### pytest fixture scope

| scope | 生命周期 | 适用场景 |
|-------|---------|---------|
| `function` | 每个测试函数 | 每次需要干净环境 |
| `class` | 每个测试类 | 类内共享资源 |
| `module` | 每个 .py 文件 | 模块级初始化 |
| `session` | 一次 pytest 运行 | ros2 daemon、工作区路径 |

### 等价类 + 边界值测试

为每个参数覆盖：
- 下边界、上边界、典型值、中间值
- 小于最小、大于最大、空值、类型错误
- 目标：每个关键参数 ≥ 8 个用例

---

## 推荐资源

- [pytest 官方文档](https://docs.pytest.org/en/stable/)
- [ROS2 Testing 教程](https://docs.ros.org/en/humble/Tutorials/Intermediate/Testing/CLI.html)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

---

## 课后产出物

1. 为 ROS2 节点补充 ≥ 3 个测试用例（单元 + 集成 + 参数边界值）
2. `.github/workflows/test.yml` CI 配置
3. push 后 GitHub Actions 标签页绿灯截图
