
# 🧠 CORE RULE (remember this first)

> 🔑 Choose model based on **task**, not popularity

---

# 🚀 CHEAT SHEET (Save this)

## 🔵 1. Text Generation / Chat / Story / Notifications

👉 Use: **Decoder-only models**

|Model|Usage|Import|
|---|---|---|
|GPT-2|Basic generation, learning internals|`AutoModelForCausalLM`|
|Mistral-7B-Instruct|Chatbots, assistants (better than GPT-2)|`AutoModelForCausalLM`|

```python
from transformers import AutoTokenizer, AutoModelForCausalLM
```

---

## 🔴 When to use?

- chatbot
- storytelling
- auto text completion
- your notification generator (simple version)

---

## ⚠️ Warning:

- GPT-2 is NOT instruction-following
- Use instruct models for real apps

---

# 🟢 2. Classification (Sentiment, Spam, Intent)

👉 Use: **Encoder-only models**

|Model|Usage|Import|
|---|---|---|
|BERT|Deep text understanding|`AutoModelForSequenceClassification`|
|DistilBERT|Faster, lighter classification|`AutoModelForSequenceClassification`|

```python
from transformers import AutoTokenizer, AutoModelForSequenceClassification
```

---

## 🔴 When to use?

- sentiment analysis
- intent detection (chatbots)
- spam filtering

---

## ⚠️ Rule:

> If output is a **label**, use BERT-type

---

# 🟣 3. Text-to-Text (MOST IMPORTANT FOR YOU)

👉 Use: **Encoder-Decoder models**

|Model|Usage|Import|
|---|---|---|
|T5|General transformation tasks|`AutoModelForSeq2SeqLM`|
|FLAN-T5|Instruction following, chat-like tasks|`AutoModelForSeq2SeqLM`|

```python
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
```

---

## 🔴 When to use?

- summarization
- translation
- question answering
- chatbot-style structured responses
- your **notification AI (BEST FIT)**

---

## 🧠 Key advantage:

> Takes input → produces controlled output

---

# 🟡 4. Embeddings / Semantic Search

👉 Use: Encoder models (no generation)

|Model|Usage|Import|
|---|---|---|
|Sentence-BERT|similarity, search|`AutoModel`|

```python
from transformers import AutoTokenizer, AutoModel
```

---

## 🔴 When to use?

- search engines
- recommendation systems
- matching questions/answers