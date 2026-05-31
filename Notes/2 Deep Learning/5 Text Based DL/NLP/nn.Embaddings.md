
>[!Explanation]
>**`nn.Embedding`**: You only need **one** embedding layer. It is the "lookup table" that converts an ID (like `752`) into a list of x numbers (the vector).


## <span style="color:rgb(0, 213, 255)">Basic Steps:</span>

> **1 Get the tokenized lists of Text data.**
> **2 Create a Vocab list from training set (x_train) which is a list of all the words used in x_train dataset.**
> **3 Create word-to-index mapping which is a dictionary of {index:"token"}**
> **4 Create a list of word_ids which is a 2d list for all the sentence , where the id from word2idx mapping represents taken. Ids will represent a sentence in same sequencee the tokens were.**
> **5 Apply padding: the unequal vectors gets filled with 0s to make them all equal.**
> **6 Pass the padded list of ids to embedding object.**



```python

--- create tokens ---
tokens = [
    [token.lemma_.lower() for token in doc if not token.is_stop and not token.is_punct]
    for doc in nlp.pipe(text)
]

--- Create vocab ---
vocab = sorted(set(token for doc in tokens for token in doc))
// tokens is the 2d list of words. sentence[.... [words...] ...]
// doc is first iterable on sentence , token is iterable for inner loop on words.

--- create word to index mapping ---
word2idx = {word: i for i, word in enumerate(vocab)}  // {word:id}

--- create id sequence of sentences ---
word_ids  = [[word2idx[token] for token in doc] for doc in tokens]
```


## <span style="color:rgb(0, 213, 255)">Embeddings:</span>

```python
nn.Embedding(vocab_size , vec_dim)
```

```python
vocab_size = 10000

vec_dim = 50
→ matrix: 10000 × 50
Each row = vector for one word ID
```
## 🔹 Where your IDs come in

When you pass:

[4, 2, 10]

Embedding does:
output = [embedding[4], embedding[2], embedding[10]]
👉 It **uses IDs as row indices** into that matrix

---

## 🔹 Why `vocab_size` matters

It must match your vocabulary:
vocab_size = len(word2idx)
Because:
- If max ID = 999 → you need at least 1000 rows

---

## 🔹 Why `vec_dim` matters
This is just:

> “How many features per word?”

You choose it (e.g., 50, 100, 300)

```python
# your data
word_ids = [[4, 2, 10], [1, 7, 3]]

# embedding layer
embed = nn.Embedding(len(word2idx), 50)

# result
vectors = embed(torch.tensor(word_ids))
```

## <span style="color:rgb(0, 176, 80)">Apply Padding, Convert sequences list to Tensor:</span>

```python
embd = nn.Embedding(vocab_size , vec_dim) <--- obj configuration of embedding layer.

tensors = [torch.tensor(seq) for seq in word_ids]

padded = pad_sequence(tensors , batch_first=True , padding_value=0)
// batch_first=True -> sentences(sequneces) = ROWS , each sentence ids length = COLUMNS

vectors = embd(padded) <--- actual id values passed to embedding layer.
```

## Example:

```python
import torch.nn as nn

class SpamDetector(nn.Module):
    def __init__(self, vocab_size, embed_dim):
        super().__init__()
        # 1. The Embedding Layer: Turns word IDs into vectors
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        
        # 2. The Linear Layer: Turns the vector into a prediction
        self.fc = nn.Linear(embed_dim, 1)
        
        # 3. The Activation: Squash the output between 0 and 1
        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        # x shape: (batch_size, sequence_length)
        embedded = self.embedding(x) # shape: (batch_size, seq_len, embed_dim)
        
        # We average the word vectors in the sentence (Global Average Pooling)
        pooled = embedded.mean(dim=1) 
        
        return self.sigmoid(self.fc(pooled))

# Initialize the model
model = SpamDetector(vocab_size=len(vocab), embed_dim=32)
print(model)
```

