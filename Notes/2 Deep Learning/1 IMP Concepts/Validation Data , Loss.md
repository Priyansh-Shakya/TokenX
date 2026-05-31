
>[!Split Training Set]
>**We use train test split to create trian , test datasets, use it again on x_train , x_test, to split it furthre to get validation datasets.**


```python
from sklearn.model_selection import train_test_split

X_train, X_val, y_train, y_val = train_test_split(
    X_train, y_train, test_size=0.2, random_state=42
)
```

---
# 🔁 Step 2: Training loop with validation

```python
train_losses = []

val_losses = []

  

for epoch in range(1000):
    # ---- TRAIN ----
    model.train()
    optimizer.zero_grad()
    logits = model(x_train_tensor)
    loss = creterion(logits, y_train_tensor)
    loss.backward()
    optimizer.step()
    train_losses.append(loss.item())

    # ---- VALIDATION ----
    model.eval()
    with torch.no_grad():
        val_logits = model(x_val_tensor)
        val_loss = creterion(val_logits, y_val_tensor)
        val_losses.append(val_loss.item())

    if epoch % 20 ==0:
      print(f"Epoch {epoch}: Train Loss = {loss.item():.4f}, Val Loss = {val_loss.item():.4f}")
```

---

### Graph for Train vs Validation Loss:

```python
import matplotlib.pyplot as plt

plt.plot(train_losses, label="Train Loss")
plt.plot(val_losses, label="Validation Loss")

plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.title("Training vs Validation Loss")

plt.legend()
plt.show()
```




