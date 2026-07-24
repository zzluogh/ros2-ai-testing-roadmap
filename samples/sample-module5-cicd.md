# 样本笔记：DVC 数据恢复 + GitHub Actions CI 排障日记

> 模块五第 33~38 课 学习笔记样本

---

## 踩坑 1：DVC 装了但 `command not found`

**现象**：
```bash
$ pip install dvc
Successfully installed dvc-3.67.1
$ dvc --version
dvc: command not found
```

**根因**：`pip install` 把 dvc 装到 `~/.local/bin/`，但这个路径不在 WSL 默认 PATH 中。

**修复**：
```bash
# 方法 1：用绝对路径
/home/ubuntu/.local/bin/dvc --version

# 方法 2：加到 PATH（永久）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 踩坑 2：删了原始数据 → `git checkout` 恢复不了

**场景**：`rm data/test_queries.json` 后想用 git 恢复。

**现象**：
```bash
$ git checkout data/test_queries.json
# 没反应
$ ls data/
# test_queries.json 没回来
```

**根因**：`dvc add` 后，git 只跟踪 `.dvc` 元文件（存 hash 指针），原始 JSON 被 `.gitignore` 排除了。Git 根本不知道 JSON 文件的存在。

**正确的恢复流程**：
```bash
# Step 1: git 恢复 .dvc 指针文件
git checkout data/test_queries.json.dvc

# Step 2: DVC 从缓存恢复实际数据
dvc checkout data/test_queries.json
```

### DVC vs Git 分工

| | Git | DVC |
|------|-----|-----|
| 管什么 | 代码、配置、.dvc 元文件（< 1KB） | 实际数据（JSON/CSV/模型/bag） |
| 存储方式 | 文本 diff | 内容寻址（md5 hash） |
| 恢复数据 | `git checkout` | `dvc checkout` |
| 版本对比 | `git diff` | `dvc diff` |

---

## 踩坑 3：CI workflow 上 `mlflow.db` 不存在

**场景**：GitHub Actions workflow 中想对比当前评测结果和 MLflow 上一次记录。

**现象**：CI 上 mlflow 命令报 `mlflow.db not found`。

**根因**：mlflow.db 被 `.gitignore` 排除了，不在 git 仓库中。GitHub Actions runner 上是一个空的 checkout 环境，没有历史数据库。

**解决方案**：放弃 CI 上的 MLflow 对比，改为**阈值检查**。
```yaml
- name: Check Accuracy Threshold
  run: |
    ACCURACY=$(python3 -c "import json; d=json.load(open('results.json')); print(d['mmlu_cs']['acc'])")
    if (( $(echo "$ACCURACY < 0.30" | bc -l) )); then
      echo "::error::Accuracy $ACCURACY below threshold 0.30!"
      exit 1
    fi
```

MLflow 对比保留在**本地开发环境**使用——开发者改代码后本地跑 MLflow UI 对比历史指标，CI 上只做硬阈值门禁。

---

## 踩坑 4：GitHub Actions `paths` 触发条件不包括 workflow 本身

**场景**：改了 `.github/workflows/ml-eval.yml` 文件，push 上去等 CI 跑，结果什么都没发生。

**根因**：workflow 的 `on.push.paths` 指定了触发条件，但不包括 `.github/workflows/**`。修改 workflow 文件本身不会触发自己。

**修复**：
```yaml
on:
  push:
    paths:
      - 'src/**'
      - 'data/**'
      - '.github/workflows/**'  # 加上这行
```

---

## 踩坑 5：`pip install -e .` 改了 entry_points 不生效

**场景**：`setup.py` 中改了 `entry_points` 配置，直接运行 CLI 命令发现还是旧的行为。

**根因**：`entry_points` 配置在 `pip install` 时生成入口脚本（写入 `~/.local/bin/` 或 `/usr/local/bin/`）。修改 `setup.py` 后不重装，入口脚本不会更新。

**修复**：
```bash
sudo pip install -e .  # 重新安装
which my_cli           # 确认指向正确
```

如果只改了源码（不改 entry_points），`-e` (editable) 模式下即时生效无需重装。

---

## 完整 CI/CD 流程图

```
Push Code → GitHub Actions
  ├── pytest（单元 + 集成测试）
  ├── Allure generate（HTML 报告）
  ├── 模型评测脚本（eval_mmlu.py）
  ├── bc 阈值检查（<0.30 → fail）
  └── 上传 Allure 报告 artifacts
```

---

> 完整版含 DVC 全链路实操（3→36 条数据迭代）、MLflow 5 次实验对比、Allure 15 用例注解、Typer CLI 工具 4 命令打包
