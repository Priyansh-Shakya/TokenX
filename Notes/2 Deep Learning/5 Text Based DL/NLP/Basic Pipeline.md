
## 🔸 Step-by-step pipeline

### 1. Text Preprocessing

This is where your **regex knowledge comes in**:

- Remove noise (symbols, HTML, etc.)
- Lowercasing
- Tokenization (split words) [Stemming or Lemmatizattion]

---

### 2. Convert Text → Numbers

Models don’t understand text directly.

So we convert:

- Words → vectors
- Methods:
    - Bag of Words
    - TF-IDF
    - Word Embeddings (Word2Vec, GloVe)

---

### 3. Feed into Deep Learning Models

Common DL models:

- RNN (Recurrent Neural Networks)
- LSTM / GRU
- Transformers (most powerful today)

Example:

- Input: “Movie was amazing”
- Output: Positive sentiment

---

### 4. Prediction / Output

Depending on task:

- Classification (spam / not spam)
- Translation
- Text generation
- Question answering

---

# 🔹 Key Tasks in NLP

- Text classification
- Named Entity Recognition (NER)
- Machine translation
- Sentiment analysis
- Text summarization

---

# 🔹 Simple Example (End-to-End)

Input:

"I love this phone!!! 😍"

Steps:

1. Clean → `"i love this phone"`
2. Convert → vectors
3. Model → predicts
4. Output → **Positive sentiment**