# 常用命令速查

## ROS2 测试

```bash
# 构建 + 测试
colcon build
colcon test --event-handlers console_direct+
colcon test-result --verbose

# launch_testing
ros2 run launch_testing test_launch.py

# rosbag
ros2 bag record -o test_data /cmd_vel /scan /odom
ros2 bag play test_data --loop

# 话题/节点/服务
ros2 topic list
ros2 node list
ros2 topic echo /cmd_vel --once

# 生命周期
ros2 lifecycle set /node_name configure
ros2 lifecycle set /node_name activate
```

## pytest

```bash
# 运行指定文件
python3 -m pytest tests/test_xxx.py -v

# 按关键字筛选
pytest -v -k "test_qos"

# 覆盖率
pytest --cov=src --cov-report=html

# Allure 报告
pytest --alluredir=./allure-results tests/
allure serve ./allure-results
```

## LLM 评测

```bash
# lm-evaluation-harness
lm_eval --model hf \
  --model_args pretrained=Qwen/Qwen2.5-0.5B \
  --tasks mmlu_computer_science \
  --device cuda:0 --batch_size 8

# OpenCompass
python -m opencompass --datasets ceval --models qwen

# locust 压测
locust -f locustfile.py --headless -u 10 -r 2 -t 60s
```

## Git & CI

```bash
# GitHub CLI
gh run watch
gh run view --log

# DVC
dvc init
dvc add data/test_queries.json
dvc push
dvc pull

# MLflow
mlflow ui
```

## pip 工具安装

```bash
pip install pytest pytest-cov pytest-timeout pytest-xdist allure-pytest
pip install locust
pip install evaluate rouge_score bert_score sacrebleu
pip install lm-eval opencompass
pip install ragas langchain chromadb
pip install langsmith
pip install mlflow
pip install dvc
pip install typer
```
