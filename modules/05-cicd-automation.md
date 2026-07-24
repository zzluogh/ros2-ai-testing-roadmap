# 模块五：CI/CD 自动化

> 6 课 / 第 12-14 周

---

## 课程总览

| 课时 | 主题 | 学习目标 |
|------|------|---------|
| 第 33 课 | DVC 数据版本管理 | 测试数据集版本控制（dvc add / push / pull） |
| 第 34 课 | MLflow 实验追踪 | 记录模型评测结果、指标趋势对比 |
| 第 35 课 | GitHub Actions ML Pipeline | push 触发自动评测 + 阈值告警 |
| 第 36 课 | Allure 测试报告 | 装饰器 + HTML 报告生成 |
| 第 37 课 | CLI 测试工具 | 用 Typer 构建命令行工具，打包 pip 包 |
| 第 38 课 | 模块五结课 | 完整 CI/CD 流程演示（push → test → 对比 → 告警 → 报告） |

---

## 关键概念

### ML CI Pipeline

```
Push Code → GitHub Actions
  ├── pytest（ROS2 测试 + LLM 评测）
  ├── 对比 MLflow 上一次指标
  ├── 指标下降 >5% → Issue 告警
  └── 生成 Allure 报告链接
```

### DVC 数据版本管理

```
dvc init                      # 初始化
dvc add data/test_queries.json  # 追踪数据
git add data/test_queries.json.dvc  # 版本化
dvc push                      # 推送到远程存储
```

### MLflow 实验追踪

- `mlflow.set_experiment()` — 创建实验
- `mlflow.start_run()` — 开始一次运行
- `mlflow.log_param()` — 记录参数
- `mlflow.log_metric()` — 记录指标
- `mlflow ui` — 启动对比面板

---

## 推荐资源

- [DVC 文档](https://dvc.org/doc/start)
- [MLflow 文档](https://mlflow.org/docs/latest/getting-started/)
- [Allure 文档](https://docs.qameta.io/allure-report/)
- [Typer 文档](https://typer.tiangolo.com/)

---

## 课后产出物

1. 测试数据集 DVC 版本管理
2. MLflow 实验记录（3+ 次不同参数对比）
3. GitHub Actions ML pipeline（含阈值告警）
4. Allure HTML 测试报告
5. CLI 工具（3 个命令，打包成 pip 包）
