# 样本笔记：BLEU 短句零分 + RAGAS 本地实现踩坑

> 模块四第 23~28 课 学习笔记样本

---

## 踩坑 1：`evaluate.load("bleu")` 在墙内超时

**场景**：Colab / 本地 WSL 跑 `import evaluate; bleu = evaluate.load("bleu")`，卡住然后超时。

**根因**：HuggingFace Hub 被墙，`evaluate.load()` 需要从 huggingface.co 下载配置文件。

**修复**：不用 `evaluate` 库，直接用底层库——它们都在本地纯计算，不需要网络：
```python
# 取代 evaluate.load("bleu")
from sacrebleu import BLEU
bleu = BLEU()
score = bleu.corpus_score(predictions, [references])

# 取代 evaluate.load("rouge")  
from rouge_score import rouge_scorer
scorer = rouge_scorer.RougeScorer(["rouge1", "rouge2", "rougeL"])
scores = scorer.score(reference, prediction)
```

BERTScore 同理——它依赖 HuggingFace 下载 BERT 模型，也被墙。本地无法跑时标记 skip，留到 Colab 跑。

---

## 踩坑 2：BLEU 对短句天然不友好——不是 bug

**现象**：`"Hi"` 和 `"Hello"` 的 BLEU 得分 = 0

第一反应：是不是算错了？

**实际原因**：BLEU 默认用 1-gram 到 4-gram 的几何平均。3 个词的句子在 4-gram 粒度上是 0——几何平均里只要有一个 0，结果就是 0。

**验证**：
```python
# "the cat sat" (3 词) vs "the cat sat"
# → unigram = 1.0, bigram = 1.0, 3-gram = 1.0, 4-gram = 0
# → 几何平均 = (1.0 × 1.0 × 1.0 × 0)^(1/4) = 0
# → BLEU = 0 · brevity_penalty = 0
```

这是 BLEU 的**固有特性**，不是实现 bug。

**教训**：评测短文本（如单句对话、工具调用参数）时不要用 BLEU，换 ROUGE-L 或 BERTScore。

---

## 踩坑 3：ROUGE 只看字面，不看语义

**测试用例**：
- Prediction: "The cat sat on the mat."
- Reference: "A cat is sitting on a mat."

ROUGE-1 F1 = 0.5（只有 cat, mat 重叠）

但这两句话语义完全相同。ROUGE 无法识别同义表达。

**解决方法**：用 BERTScore——它把句子编码成 BERT 向量后计算余弦相似度，能跨同义词匹配。

---

## 踩坑 4：RAGAS faithfulness 本地实现的边界

**背景**：不用 LangChain 生态，从零实现 RAGAS 四个核心指标（faithfulness / answer_relevancy / context_recall / context_precision）。

**核心发现**——真实的 RAGAS 用 LLM 做逐句判断，本地简化版用 token 重叠率做近似。

| 指标 | 真实 RAGAS（LLM） | 本地简化版（token 重叠） | 准确性损失 |
|------|------------------|---------------------|:---:|
| faithfulness | LLM 逐句判断"有依据" | token 重叠率 ≥50% 就算有依据 | 中 |
| answer_relevancy | LLM 生成问题 + cosine 相似度 | 一问一答直接算 cosine | 低 |
| context_recall | 按 sentence 标注+LLM 判断 | token 级覆盖 | 中 |
| context_precision | LLM 判断每句相关→算 ranking | 检索词在提问中的命中比例 | 低 |

**关键局限**：纯 token 重叠无法区分"词无关但语义相关"。比如上下文讲"机器人避障"，回答讲"无人机飞行"——token 层面有 `drone` 和 `obstacle` 等词重叠，但实际上完全答非所问。

**实践结论**：本地简化版适合快速筛选和 CI pipeline 中的快速检查；正式评测报告需要用真实 LLM 版。

---

## 三个指标对比速查

| 指标 | 测什么 | 原理 | 适合场景 | 不适合场景 |
|------|--------|------|---------|-----------|
| **BLEU** | n-gram 精确匹配 | 1-4 gram precision + brevity penalty | 机器翻译 | 短文本、对话 |
| **ROUGE** | 词重叠召回率 | unigram/bigram/LCS 的 F1 | 文本摘要 | 同义表达评估 |
| **BERTScore** | 语义相似度 | BERT embedding → cosine 匹配 | 任何生成任务 | 模型下载被墙时 |

---

> 完整版含 11 个 NLP 评测测试用例、RAGAS 四指标完整实现源码（77 用例全绿）、10 组 QA 数据集
