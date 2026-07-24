# 模块四：大模型测试

> 10 课 / 第 8-11 周
> 全部在 Google Colab（免费 GPU）上完成

---

## 课程总览

| 课时 | 主题 | 学习目标 |
|------|------|---------|
| 第 23 课 | NLP 评测指标 | 掌握 BLEU / ROUGE / BERTScore / sacrebleu |
| 第 24 课 | MMLU 评测实战 | 用 lm-evaluation-harness 跑 Qwen2.5-0.5B |
| 第 25 课 | OpenCompass 国产模型 | 评测 Qwen2.5 在 C-Eval（中文集）上的表现 |
| 第 26 课 | ollama + locust 压测 | 部署推理服务，输出 QPS/P50/P95/P99 报告 |
| 第 27 课 | 长上下文测试 | 针海捞针 — 不同文档长度下的检索准确率 |
| 第 28 课 | RAGAS 评测 | faithfulness / answer_relevancy / context_recall / context_precision |
| 第 29 课 | Function Calling 测试 | 工具调用准确率 + 参数正确率 |
| 第 30 课 | SWE-bench 理解 | Agent 评测框架阅读理解 |
| 第 31 课 | LangSmith 调试 | RAG/Agent 调用链追踪与根因分析 |
| 第 32 课 | 模块四结课 | 输出一份完整 LLM 评测报告 |

---

## 关键概念

### NLP 三大评测指标

| 指标 | 衡量什么 | 适用场景 |
|------|---------|---------|
| **BLEU** | n-gram 精确匹配 + 短句惩罚 | 机器翻译 |
| **ROUGE** | n-gram 召回率 | 文本摘要 |
| **BERTScore** | 基于 BERT 的语义相似度（余弦相似度） | 任何生成任务 |

### 评测工具链

| 工具 | 用途 |
|------|------|
| `lm-evaluation-harness` | 最通用的 LLM 评测框架，支持 200+ 任务 |
| `OpenCompass` | 国产模型评测首选，支持 C-Eval / CMMLU |
| `RAGAS` | RAG 系统评测：忠实度、相关性、上下文召回 |
| `LangSmith` | LangChain/RAG/Agent 调用链追踪与调试 |
| `locust` | HTTP API 性能压测 |

### 典型评测指标矩阵

| 维度 | 指标 | 说明 |
|------|------|------|
| **知识** | MMLU / C-Eval 准确率 | 57/52 个学科的多选题 |
| **推理** | GSM8K 准确率 | 小学数学应用题 |
| **指令遵循** | Function Calling 准确率 | 工具选择 + 参数填充正确率 |
| **检索** | RAGAS faithfulness | 答案是否忠于检索到的上下文 |
| **长文本** | Needle-in-Haystack 准确率 | 不同长度下的信息检索能力 |
| **性能** | QPS / P50/P99 延迟 | 首 token 时间 vs prompt 长度 |

---

## 推荐资源

- [HuggingFace Evaluate](https://huggingface.co/docs/evaluate/index)
- [lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness)
- [OpenCompass](https://opencompass.readthedocs.io/)
- [RAGAS](https://docs.ragas.io/)
- [LangSmith](https://docs.smith.langchain.com/)
- [ollama](https://ollama.com/)
- [locust](https://locust.io/)

---

## 课后产出物

1. MMLU 计算机科学子集准确率
2. 自建 20 道工具调用测试的准确率
3. RAG faithfulness + context_recall 分数
4. 性能报告：QPS、P50 延迟、最大输入长度
5. 完整 LLM 评测报告（1 份）
