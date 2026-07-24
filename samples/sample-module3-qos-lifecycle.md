# 样本笔记：QoS 静默失败 + 生命周期死锁调试

> 模块三第 17~19 课 学习笔记样本

---

## 踩坑 1：QoS 不兼容导致消息静默丢失

这是 ROS2 测试中最隐蔽的一类 bug——没有 crash、没有报错，但数据就是收不到。

**场景**：一个 publisher 用 `RELIABLE`，一个 subscriber 用 `BEST_EFFORT`。

**现象**：
```bash
$ ros2 topic echo /test_data
# 什么都没有，干干净净
```

Publisher 明明在发，subscriber 却没收到。`ros2 topic list` 能看到话题，`ros2 topic info` 显示 pub 和 sub 都存在，但 `echo` 就是空的。

**根因**：QoS 不兼容。RELIABLE 要求确认重传，BEST_EFFORT 不做确认——二者握手失败，DDS 层直接丢弃消息，ROS2 层面不出任何警告。

**排查方法**：
```bash
# 查看实际 QoS 配置
ros2 topic info /test_data --verbose
# 对比 publisher 和 subscriber 的 Reliability policy
```

**修复**：publisher 和 subscriber 的 `reliability` 策略必须一致。
```python
# 对：两边都用 RELIABLE
pub_qos = QoSProfile(depth=10, reliability=ReliabilityPolicy.RELIABLE)
sub_qos = QoSProfile(depth=10, reliability=ReliabilityPolicy.RELIABLE)
```

### QoS 兼容矩阵速记

| Publisher ↓ / Subscriber → | RELIABLE | BEST_EFFORT |
|---------------------------|----------|-------------|
| **RELIABLE**              | 兼容     | **不兼容**  |
| **BEST_EFFORT**           | **不兼容**| 兼容        |

---

## 踩坑 2：TRANSIENT_LOCAL 以为能"持久化"，实际 pub 一关就丢

**场景**：设了 `durability=TRANSIENT_LOCAL`，以为 subscriber 后启动也能收到之前发的消息。

**现象**：subscriber 延迟启动后收不到任何历史消息。

**根因**：TRANSIENT_LOCAL 的"持久化"是进程级别的——publisher 存活期间缓存最近的消息。一旦 publisher 进程退出，缓存消失。它不是 ROS1 的 latching（DDS 中间件级持久化）。

**验证实验**：
1. pub 启动，发 5 条消息
2. pub 退出
3. sub 启动 → 收不到任何消息

**教训**：TRANSIENT_LOCAL ≠ 持久化存储。需要跨进程历史数据用 rosbag。

---

## 踩坑 3：生命周期节点 `inactive → shutdown` 非法

**场景**：写生命周期测试脚本，逐状态迁移。

**错误路径**：
```
unconfigured → configure → activate → deactivate → shutdown  ❌
```

**现象**：`shutdown` 调用返回 `Transition is not registered`。

**根因**：生命周期状态机规定——从 `inactive` 不能直接 `shutdown`，必须先 `cleanup`。

**正确路径**：
```
unconfigured → configure → activate → deactivate → cleanup → shutdown  ✅
```

### 合法 vs 非法迁移

| 当前状态 | 合法下一步 | 非法尝试 |
|---------|-----------|---------|
| unconfigured | configure | activate / shutdown |
| inactive | activate, cleanup, shutdown | deactivate |
| active | deactivate | cleanup / shutdown |
| finalized | (终止) | 任何迁移 |

---

## 踩坑 4：rosbag record 第一帧丢了

**场景**：先启动数据源节点，再启动 `ros2 bag record`。

**现象**：数据源发了 30 条，bag 里只录到 24 条。

**根因**：recorder 节点启动后需要时间完成 DDS 发现和话题订阅（通常 1~2 秒），这期间数据源已经发了几条消息。

**修复**：
```bash
# 方法 1：先录后发
ros2 bag record -o output /topic1 /topic2 &
sleep 2  # 等 recorder 完成订阅
ros2 run my_pkg data_source

# 方法 2：用 --wait 参数（rosbag2 新版本支持）
ros2 bag record -o output --wait /topic1
```

---

## rosbag2 做回归测试的标准流程

```bash
# 1. 录制基准数据
ros2 bag record -o baseline /cmd_vel /scan /odom

# 2. 写回归测试脚本
# 回放 baseline → 启动被测节点 → 断言输出是否符合预期

# 3. 代码变更后重复步骤 2
```

这相当于给机器人算法建了一套"单元测试数据集"——每次改代码后回放同样的传感器数据，对比输出。

---

> 完整版含 15 个 QoS 组合测试、生命周期全状态迁移自动化验证、rosbag2 录制回放测试 3 话题 72 条数据
