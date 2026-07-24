# 样本笔记：pytest mock ROS2 话题 + launch_testing 踩坑实录

> 模块二第 10~13 课 学习笔记样本

---

## 核心认知：测试金字塔在 ROS2 中怎么落地

```
         ┌──────┐
         │ E2E  │  bag 回放 + Nav2 全链路（少但真实）
         ├──────┤
         │ 集成  │  launch_testing 启动节点 → 断言话题
         ├──────┤
         │ 单元  │  mock 话题输入 → 断言回调逻辑
         └──────┘
```

底层多而快，顶层少但真实。

---

## 踩坑 1：fixture scope 选错，测试互相污染

**场景**：用 `scope="session"` 的 fixture 创建一个 ROS2 节点，所有测试共享。

**现象**：第二个测试偶尔失败——前一个测试的 callback 残留数据没清干净。

**根因**：`session` 级 fixture 只初始化一次，测试间的副作用会累积。ROS2 节点内的回调状态（计数器、缓存的 msg）不会自动重置。

**修复**：
```python
# 错：session 级，副作用累积
@pytest.fixture(scope="session")
def ros_node():
    rclpy.init()
    node = Node("test_node")
    yield node
    node.destroy_node()
    rclpy.shutdown()

# 对：function 级，每个测试干净启动
@pytest.fixture  # 默认 scope="function"
def ros_node():
    rclpy.init()
    node = Node("test_node")
    yield node
    node.destroy_node()
    rclpy.shutdown()
```

**教训**：ROS2 节点的 fixture 默认用 `function` 级，除非有明确的性能瓶颈。

---

## 踩坑 2：mock 了话题但没验证调用

**场景**：mock 一个 publisher，测试 timer_callback 是否发了消息。

**错误写法**：
```python
def test_publishes_cmd_vel(mocker):
    mock_pub = mocker.patch.object(node, 'create_publisher')
    node.timer_cb()  # 触发回调
    # 没做任何断言！
```

你以为 mock 了就行，但实际上根本没验证 `publish()` 被调没调、参数对不对。

**正确写法**：
```python
def test_publishes_cmd_vel(mocker):
    mock_pub = mocker.MagicMock()
    mocker.patch.object(node, 'cmd_vel_pub', mock_pub)
    node.timer_cb()
    
    mock_pub.publish.assert_called_once()  # 验证被调了
    msg = mock_pub.publish.call_args[0][0]  # 取出实际参数
    assert msg.linear.x == 0.2
    assert msg.angular.z == 0.0
```

**教训**：mock 的终点不是 mock 本身，是 `assert_called_once_with` / `call_args`——验证 mock 对象上的方法是否被正确调用。

---

## 踩坑 3：launch_testing 的 ReadyToTest 不写就卡死

**场景**：第一次写 launch_testing，测试函数里等了 5 秒还没结果，手动 ctrl+c。

**根因**：`ReadyToTest()` 是一个信号——告诉 launch_testing "我的 launch 描述已经准备好，可以开始执行测试了"。不写这个，launch_testing 永远在等待。

```python
# 错：没有 ReadyToTest → 测试永远不启动
def generate_test_description():
    return LaunchDescription([
        Node(package='my_pkg', executable='my_node'),
    ])

# 对
def generate_test_description():
    return LaunchDescription([
        Node(package='my_pkg', executable='my_node'),
        launch_testing.actions.ReadyToTest(),  # 必须加
    ])
```

---

## 踩坑 4：CI 上路径硬编码 `/home/ubuntu/...` 

**场景**：本地测试全绿，push 到 GitHub Actions 报 `ModuleNotFoundError`。

**根因**：测试脚本里写了 `/home/ubuntu/test_ws/src/my_math`。本地 WSL 用户名恰巧也是 ubuntu，所以没暴露。但 GitHub Actions runner 上的目录结构完全不同。

**修复**：用相对路径 + `os.path.dirname(__file__)`：
```python
# 错
sys.path.insert(0, '/home/ubuntu/test_ws/src/my_math')

# 对
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src', 'my_math'))
```

**教训**：代码里出现任何绝对路径都是迟早要爆的雷。

---

## 关键工具链速查

| 工具 | 一行安装 |
|------|---------|
| pytest | `pip install pytest pytest-cov pytest-xdist` |
| mock | Python 内置 `unittest.mock`，另装 `pytest-mock` 提供 mocker fixture |
| launch_testing | `sudo apt install ros-humble-launch-testing` |
| CI | `.github/workflows/test.yml` + `ros-tooling/setup-ros@v0.7` |

---

> 完整版含 25 个测试用例、launch_testing 全流程模板、GitHub Actions 完整 YAML 配置
