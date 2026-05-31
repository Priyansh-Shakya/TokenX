

# 🧠 What is Word2Vec (core idea)

Word2Vec is a method to convert words into **vectors (numbers)** such that:

👉 Words with similar meaning → have similar vectors  
👉 Example:

- “king” ≈ “queen”
- “dog” ≈ “puppy”

It learns this using **context**.

---

>[!Context Window]
>**Number of Token(Words) from both left and right side of target word.**
>Example: Context window = 2
>Target: 'a'
>Sentence: 'Hey , I am a superhero guys'
>Context Words for target 'a' -> 'i' , 'am', 'superhero', 'guys'

# 📌 Key Idea: Context Window

Take a sentence:

"I love playing football"

If window size = 2, then for the word **"playing"**, context is:

["I", "love", "football"]

---

# 🔁 Two Main Approaches

## 1. CBOW (Continuous Bag of Words)

👉 **Context → Target**

You give surrounding words, model predicts center word.

### Example:

Sentence:

"I love playing football"

Window = 2

### Training sample:

Input (context): ["I", "love", "football"]  
Target: "playing"

👉 Model learns:

> “Given nearby words, what is the missing word?”

---

## 2. Skip-gram

👉 **Target → Context**

You give one word, model predicts surrounding words.

### Example:

Word: `"playing"`

Context:

["I", "love", "football"]

### Training samples:

Input: "playing" → Output: "I"  
Input: "playing" → Output: "love"  
Input: "playing" → Output: "football"

👉 Model learns:

> “Given a word, what words appear around it?”

---

# 🔥 Difference (VERY IMPORTANT)

|Feature|CBOW|Skip-gram|
|---|---|---|
|Direction|Context → Target|Target → Context|
|Speed|Faster|Slower|
|Works well for|Frequent words|Rare words|
|Data size|Needs less data|Needs more data|

---

# 🎯 What are “target” and “sample”?

This is where your confusion is — let’s fix it.

## 🧩 Training Sample

A **sample** = one training example.

### In CBOW:

Sample = (context words, target word)

Example:

(["I", "love", "football"], "playing")

---

### In Skip-gram:

Sample = (target word, one context word)

Examples:

("playing", "I")  
("playing", "love")  
("playing", "football")

---

# 🧠 How does it actually learn?

This is the deep part 👇

1. Each word starts as a random vector
2. Model tries to predict correctly
3. If prediction is wrong → update weights
4. Over time:
    - Words appearing in similar contexts → get similar vectors

---

# 🧱 Architecture (simple intuition)

Word2Vec is actually a **tiny neural network**:

Input → Hidden Layer → Output

- Input: one-hot vector of word
- Hidden: embedding layer (this is what we want!)
- Output: probabilities of words

👉 After training:  
We **throw away output layer**  
We keep **hidden layer weights = word embeddings**

---

# 🎯 Intuition Example

If model sees:

"king is a strong man"  
"queen is a wise woman"

It learns:

king ≈ queen  
man ≈ woman

So vector math becomes possible:

king - man + woman ≈ queen

---

# ⚡ CBOW vs Skip-gram in one line

- **CBOW** = fill in the blank
- **Skip-gram** = predict surroundings

---

# 🚀 Why Skip-gram is often preferred

Even though slower:

- Better at capturing meaning
- Works well with small datasets
- Learns rare words better