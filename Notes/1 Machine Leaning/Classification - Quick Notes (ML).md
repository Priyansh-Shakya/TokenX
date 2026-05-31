
## 🔹 What is Classification?
- A supervised learning task
- Definition: assign input to a **class/label**
- Example:
  - Spam detection → {Spam, Not Spam}
  - Fraud detection → {Fraud, Not Fraud}

---

## 🔹 X and Y (Data Structure)

- **X (Features / Input)**
  - Can include:
    - Text (email content)
    - Metadata (sender, time, etc.)
- **Y (Labels / Target)**
  - Categories (0/1, Yes/No, Spam/Not Spam)

```python
X = ["Win money now!!!", "Meeting at 5pm"]
y = [1, 0]  # 1 = spam, 0 = not spam
```


## How Classification Works (Concept)
1. Convert input → numbers
2. Model computes:
    
    z = w1*x1 + w2*x2 + ... + b
    
3. Convert to probability (sigmoid)
4. Apply threshold → final class

---

## 🔹 Why Text Must Be Converted to Numbers

- ML models only understand numbers
- Raw text ❌ cannot be used directly

---

## 🔹 Text → Numbers (Vectorization)

### ❌ Not One-Hot Encoding

- Works for small categorical data (limited range of words)
- Text has huge vocabulary → inefficient

>[!Important]
>**One hot encoding can also be done using pandas -> df = pd.get_dummies(df, drop_first=True)** (Although , use sklearn.preprocessing import OneHotEncoding)

### ✅ Use Vectorizers

- CountVectorizer → counts words
- TF-IDF → importance of words

---

## 🔹 Example: Text Vectorization

```python
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# Data
emails = [
    "Win money now!!!",
    "Meeting at 5pm",
    "Claim your prize",
    "Let's have lunch"
]

labels = [1, 0, 1, 0] # y (target)

# Text → Numbers
vectorizer = CountVectorizer()
X = vectorizer.fit_transform(emails)

# Split
X_train, X_test, y_train, y_test = train_test_split(X, labels, test_size=0.2)

# Model
model = LogisticRegression()
model.fit(X_train, y_train)

# Prediction
y_pred = model.predict(X_test)

# Evaluation
print("Accuracy:", accuracy_score(y_test, y_pred))
```