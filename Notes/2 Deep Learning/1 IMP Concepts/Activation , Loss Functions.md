

# 1. 🧠 ReLU (Rectified Linear Unit)

### 📌 Math

$$
f(x)=max⁡(0,x)
$$
### ⚙️ What it does

- Kills negative values
- Keeps positive values unchanged
- Helps networks learn non-linearity

### ✅ Use when

- Hidden layers (almost always)

### ❌ Don’t use when

- Output layer (unless regression edge case)

### 📊 Output range

$$
- [0,∞)
$$
### 📉 Loss used with it

- Usually **MSE / RMSE / MAE** (for regression tasks)

### 📏 How to judge performance

- RMSE ↓ (closer to 0 = better)
- Compare with target range

---

# 2. 🧠 Sigmoid

### 📌 Math

$$
\sigma(x) = \frac{1}{1 + e^{-x}}​
$$


### ⚙️ What it does

- Converts logits → probability
- Squashes into (0,1)

### ✅ Use when

- Binary classification (output layer — but usually via loss)

### ❌ Don’t use when

- Hidden layers (vanishing gradients)

### 📊 Output range

- (0, 1)

### 📉 Loss

- `BCELoss` (if you manually apply sigmoid)
- ✅ `BCEWithLogitsLoss` (preferred)

### 📏 Inference

probs = torch.sigmoid(logits)  
pred = (probs > 0.5).float()

### 📏 How to judge

- Accuracy, Precision, Recall, F1
- Loss ↓ is good

---

# 3. 🧠 Tanh

### 📌 Math
$$
\tanh(x) = \frac{e^x - e^{-x}}{e^x + e^{-x}}​
$$


### ⚙️ What it does

- Like sigmoid but centered at 0
- Better gradient than sigmoid (but still limited)

### 📊 Range

- (-1, 1)

### ✅ Use when

- Sometimes hidden layers (older models, RNNs)

### ❌ Avoid when

- Deep networks (ReLU better)

### 📉 Loss

- Same as regression → MSE etc.

---

# 4. 🧠 Softmax

### 📌 Math

$$
Softmax(xi)=exi∑jexj\text​​
$$

### ⚙️ What it does

- Converts logits → probability distribution
- Sum of outputs = 1

### ✅ Use when

- Multi-class classification (one correct class)

### ❌ Don’t use when

- Using `CrossEntropyLoss` (it already includes it)

### 📊 Output

- Probabilities across classes

### 📉 Loss

- `CrossEntropyLoss` (logits input, no softmax needed)

### 📏 Inference

probs = torch.softmax(logits, dim=1)  
pred = torch.argmax(probs, dim=1)

---

# 5. 🧠 Cross Entropy Loss

### ⚙️ What it does

- Measures difference between prediction & true class
- Internally:
    - Softmax + Log + NLL

### ✅ Use when

- Multi-class classification

### ❗ Input expected

- **Logits (NOT probabilities)**

### 📏 Code

loss = CrossEntropyLoss(logits, target)

---

# 6. 🧠 BCEWithLogitsLoss

### ⚙️ What it does

- Sigmoid + Binary Cross Entropy

### ✅ Use when

- Binary OR multi-label classification

### 📏 Code

loss = BCEWithLogitsLoss(logits, target)

---

# 7. 🧠 Argmax

### ⚙️ What it does

- Picks index of highest value

### ❗ Important

- NOT an activation
- Used only for prediction

### 📏 Code

pred = torch.argmax(logits, dim=1)

---

# 🚀 FINAL MASTER RULE (most important)

|Task|Model Output|Loss|Activation in forward|
|---|---|---|---|
|Regression|Raw values|MSE / MAE|Maybe ReLU|
|Binary classification|Logits|BCEWithLogitsLoss|❌ No sigmoid|
|Multi-class|Logits|CrossEntropyLoss|❌ No softmax|
|Multi-label|Logits|BCEWithLogitsLoss|❌ No sigmoid|

---

# 🧠 Mental Model (this will stick)

Model → logits (raw scores)  
        ↓  
Loss function → applies correct activation internally  
        ↓  
Training happens  
  
Inference → you manually apply sigmoid / softmax if needed

---

# ⚠️ Golden mistakes to avoid

- ❌ Sigmoid + BCEWithLogitsLoss → WRONG
- ❌ Softmax + CrossEntropyLoss → WRONG
- ❌ Using argmax during training → WRONG