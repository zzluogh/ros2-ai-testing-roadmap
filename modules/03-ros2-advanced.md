# 模块三：ROS2 进阶

> 7 课 / 第 5-7 周

---

## 课程总览

| 课时 | 主题 | 学习目标 |
|------|------|---------|
| 第 16 课 | 回调组 | 理解 MutuallyExclusive vs Reentrant，会复现和修复死锁 |
| 第 17 课 | 生命周期节点 | 掌握状态机迁移（unconfigured→inactive→active→finalized） |
| 第 18 课 | QoS 服务质量 | 理解可靠性 vs 实时性，默写 QoS 兼容矩阵 |
| 第 19 课 | rosbag2 高级 | 录制回放做回归测试 |
| 第 20 课 | tf2 时间进阶 | 历史时刻坐标变换查找 |
| 第 21 课 | Action 通信测试 | 异步发送 NavigateToPose 目标，断言 result |
| 第 22 课 | 模块三结课 | 搭建 Nav2 测试套件（公共 rosbag + Nav2 + launch_testing） |

---

## 关键概念

### 回调组类型

| 类型 | 并发行为 | 适用场景 |
|------|---------|---------|
| MutuallyExclusive | 同一时刻只运行一个回调 | 保护共享状态 |
| Reentrant | 多个回调可并发 | 高性能，需自己加锁 |

### 生命周期状态机

```
unconfigured → configuring → inactive → activating → active
                                        ← deactivating ←
                                        ← cleaningup ←
                                        ← shuttingdown ← finalized
```

### QoS 兼容性关键规则

- RELIABLE + RELIABLE → 兼容
- BEST_EFFORT + BEST_EFFORT → 兼容
- RELIABLE + BEST_EFFORT → **不兼容**
- TRANSIENT_LOCAL + VOLATILE → 兼容（但行为不同）

---

## 推荐资源

- [ROS2 Callback Groups](https://docs.ros.org/en/humble/How-To-Guides/Using-callback-groups.html)
- [Lifecycle Nodes 测试](https://docs.ros.org/en/humble/Tutorials/Intermediate/Testing/Testing-Lifecycle-Nodes.html)
- [QoS 文档](https://docs.ros.org/en/humble/Tutorials/Advanced/Quality-of-Service.html)
- [tf2 教程](https://docs.ros.org/en/humble/Tutorials/Intermediate/Tf2/Tf2-Main.html)

---

## 课后产出物

1. 死锁场景复现 + Reentrant 修复
2. 生命周期状态迁移测试（7 种合法 + 3 种非法转换）
3. QoS 兼容矩阵表
4. Nav2 测试套件（rosbag 回放 + launch_testing）
