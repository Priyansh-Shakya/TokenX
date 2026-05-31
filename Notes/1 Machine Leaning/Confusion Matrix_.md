

## 🎯 Confusion Matrix (Base of everything)

## ⚡ Accuracy

(TP + TN) / Total

👉 Use when:

- Data is balanced

❌ Avoid when:

- Imbalanced dataset

---

## 🎯 Precision

TP / (TP + FP)

👉 Meaning:

> When model says “YES”, how often is it correct?

### Use when:

- False positives are costly

💡 Example:

- Spam detection
- Showing ads to wrong users

---

## 🎯 Recall (IMPORTANT)

TP / (TP + FN)

👉 Meaning:

> Out of all real YES, how many did we catch?

### Use when:

- Missing positives is dangerous

💡 Example:

- Fraud detection
- Disease detection
- Your case (marketing)

---

## ⚖️ F1 Score

2 * (Precision * Recall) / (Precision + Recall)

👉 Meaning:

> Balance between precision & recall

### Use when:

- You want overall performance on minority class

---

## 📊 Support

Number of actual samples in each class

👉 Just tells:

- How many 0s and 1s exist

---

# 🧠 3. When to Use What (SUPER IMPORTANT)

|Situation|Focus Metric|
|---|---|
|Balanced dataset|Accuracy|
|Imbalanced dataset|F1 / Recall|
|Avoid false alarms|Precision|
|Catch all positives|Recall|
|Real-world ML|F1 + Recall|

---

# 🔥 4. Your Case (Marketing)

Goal:

> Find customers likely to respond

👉 So:

- ❌ Accuracy → not important
- ⚠️ Precision → somewhat important
- 🔥 Recall → VERY important
- ✅ F1 → good overall metric

---

# 🧩 5. Simple Way to Remember

- **Precision** → “How correct am I?”
- **Recall** → “How much did I catch?”
- **F1** → “Balance”