
# 🧠 1. What is Dropout?

## 💡 Idea (simple)

> During training, **random neurons are turned OFF**

---

## 🔍 What actually happens

If you have a layer like:


```python 
nn.Linear(106, 64)
```

With:

```python 
nn.Dropout(0.5)
```

👉 **50% of those 64 neurons are randomly ignored each forward pass**

---

## Example:

```python
self.network = nn.Sequential(
    nn.Linear(106, 64),
    nn.ReLU(),
    nn.Dropout(0.3),  <---Dropout
    nn.Linear(64, 32),
    nn.ReLU(),
    nn.Dropout(0.3), <---Dropout
    nn.Linear(32, 1)
)
```
## 🧠 Why do this?

Without dropout:

> Model starts relying on specific neurons → memorization

With dropout:

> Model is forced to **not depend on any one neuron**

---

## 🎯 Analogy

Think of a team:

- Without dropout → same few people do all the work
- With dropout → random people are absent each day  
    👉 everyone must learn the task


## ✅ Important detail

Dropout is ONLY active during:
model.train()

During validation:
model.eval()

👉 Dropout is turned OFF automatically


## 🚀 Rule of thumb
- Use `0.3 – 0.5` dropout for small data
- Add after activation:

Linear → ReLU → Dropout