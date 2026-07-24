# 样本笔记：Nav2 代价地图配置

> 本文档为模块一第 3 课的学习笔记样本，展示"半公开血肉"层的笔记风格。
> 完整版笔记和代码实现持续更新中。

---

## 全局代价地图 vs 局部代价地图

| 特性 | 全局代价地图 (global) | 局部代价地图 (local) |
|------|----------------------|---------------------|
| 坐标系 | map | odom |
| 大小 | 整个地图范围 | 5m × 5m 窗口 |
| 是否滚动 | 否（固定） | 是（rolling_window: True） |
| 更新频率 | 低（1 Hz） | 高（5 Hz+） |
| 用途 | 全局规划器使用 | 局部控制器避障 |

---

## 代价地图层级结构

代价地图采用插件式层级架构，每层独立计算代价值，最终合并到 Master Layer：

```
Master Layer（主层，必须存在）
├── Static Layer（静态地图层）
│   - 数据源：map_server 发布的 /map 话题
│   - 标记已知障碍物为致命代价(254)
│   - 标记未知区域为无信息(255)
├── Obstacle Layer（动态障碍物层）
│   - 数据源：激光雷达 /scan 话题
│   - 实时标记感知到的障碍物
│   - observation_sources 可配置多个传感器
└── Inflation Layer（膨胀层）
    - 在障碍物周围扩展安全缓冲区
    - inflation_radius = 机器人半径 + 安全余量
    - cost_scaling_factor 控制代价衰减速度
```

---

## 关键参数详解

### inflation_radius（膨胀半径）

障碍物周围的安全缓冲区半径，单位米。

- **典型值**：0.55m（机器人半径 0.22m + 余量）
- **过大**：机器人绕远路，可能卡在窄通道
- **过小**：机器人擦边通过，碰撞风险高

### cost_scaling_factor（代价缩放因子）

控制障碍物向外距离的代价衰减速度。

- **典型值**：3.0
- **越大**：代价衰减越快，机器人更贴障碍物
- **越小**：代价衰减越慢，机器人更早绕行

**两者关系**：`cost_scaling_factor` 决定了 `inflation_radius` 范围内的代价曲线形状，而非二选一的关系。

---

## 实战踩坑记录

### 坑 1：rolling_window 忘记设 True

**现象**：局部代价地图数据不更新，控制器反复撞墙。

**原因**：默认 `rolling_window: False`，局部代价地图仅覆盖初始位置周围区域，机器人移出后不再有地图数据。

**修复**：`local_costmap.rolling_window: True`

### 坑 2：分辨率改小内存爆炸

**现象**：把 resolution 从 0.05 改为 0.01 后，Nav2 延迟陡增。

**计算**：分辨率降低 5 倍，每个栅格面积缩小 25 倍，同样地图范围的栅格数 = 25 倍。代价地图内存 ≈ 25 倍增长。

**建议**：室内场景 0.05 即可，室外大场景 0.1。

---

## 推荐延伸阅读

- [Nav2 Costmap 2D 官方文档](https://navigation.ros.org/configuration/packages/costmap-plugins/index.html)
- `ros2 run nav2_costmap_2d nav2_costmap_2d --ros-args -p use_sim_time:=True`

---

> 完整版含 YAML 参数模板、8+ 边界值测试用例、自动化验证脚本
