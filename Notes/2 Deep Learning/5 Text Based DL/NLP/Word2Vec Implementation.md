
## Dependency:

- ### gensim

```python
pip install gensim
---

import gensim
```


### 1st Step: Preprocess Text

*We can use gensim for preprocessing as well.*

## <span style="color:rgb(255, 0, 0)">Better: Use SpaCy Lemmatization... it is better!</span>
### Find it here [[Preprocessing Text With SpaCy]]

```python
import gensim.utils.simple_preprocess()

store_processed_text = df['Column_text'].apply(simple_preprocess)
```

### This will tokenize the text and return a pandas series.


## Step 2: Word2vec

> gensim **is an NLP library which has word2vec class**

```python
model = gensim.models.Word2Vec(
	----- Parameters of This Model -----
	window = 10, //(int) Target window(10 words before target , 10 words after target)
	
	min_count =2 , //Dataset (column) should have frequency of that word  >=2.
	
	vector_size = 100
	 //100 By default, number of numbers you want in each vector (shape) of vector
	
	workers =4, // How many CPU threads you will use to train this model.
)
```


### Build Vocab

```python
model.build_vocab(text, progress_per=1000)
```
- `progress_per=1000` → Gensim will print a progress update every 1000 sentences processed.
- It does **not** affect training quality or speed significantly—just how often you see updates.

- Scans all your sentences
- Extracts **unique words (vocabulary)**
- Counts word frequencies
- Assigns each word an internal index

### Train

```python
model.train(text, total_examples=model.corpus_count, epochs = model.epochs)
```


- `build_vocab()` → **collect all words in a book + make an index**
- `train()` → **actually read the book and learn meaning**


### <span style="color:rgb(255, 255, 0)">For Multiple Columns to pass.</span>

> **Do not build vocab one by one for each column seperately. Instead:**

```python
sentences = list(df['P_Summary']) + list(df['P_Text'])

model = Word2Vec()
model.build_vocab(sentences)
model.train(sentences, total_examples=len(sentences), epochs=10)
```


## Testing

> Most Simillar Words

```python
model.wv.most_similar('harry')
```


## Word Vectors

## 🧠 1. Get vector of a word

model.wv['dog']

👉 Output:

- a NumPy array (usually 100–300 dimensions depending on your settings)

Example:

array([ 0.12, -0.98, 0.44, ..., 0.07])

---

## 🔍 2. Check vector shape (dimensions)

model.wv['dog'].shape

Example:

(100,)

---

## 📚 3. See vocabulary (all learned words)

model.wv.index_to_key

---

## 🔎 4. Check if a word exists

'dog' in model.wv

---

## 🤝 5. Find similar words (this is the fun part)

model.wv.most_similar('dog')

👉 Output like:

[('cat', 0.89), ('puppy', 0.85), ('pet', 0.82)]

---

## ⚡ 6. Do the classic analogy (king - man + woman)

model.wv.most_similar(positive=['king', 'woman'], negative=['man'])

---

## 📏 7. Similarity between two words

model.wv.similarity('dog', 'cat')