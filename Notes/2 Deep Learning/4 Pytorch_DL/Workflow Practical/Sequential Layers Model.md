
```python
class Model(nn.Module):
  def __init__(self) -> None:
    super().__init__()

    self.network = nn.Sequential(
        nn.Linear(19, 64),
        nn.ReLU(),
        nn.Linear(64,32),
        nn.LeakyReLU(),
        nn.Linear(32,1)
    )

  def forward(self , x):
    return self.network(x)
```

### All the Layers defined inside a sequence...

You can access each layer like:

```python
model.network[0]  # nn.Linear(19, 64)
model.network[1]  # nn.ReLU()
model.network[2]  # nn.Linear(64, 32)
model.network[3]  # nn.LeakyReLU()
model.network[4]  # nn.Linear(32, 1)
```

---

### 2. Check weights and biases of specific layers

```python
# First Linear layer  
print(model.network[0].weight)  
print(model.network[0].bias)  
  
# Second Linear layer  
print(model.network[2].weight)  
print(model.network[2].bias)  
  
# Third Linear layer  
print(model.network[4].weight)  
print(model.network[4].bias)
```

## 3. Use Loop To print weights and Biases

```python
for i, layer in enumerate(model.network):
    if isinstance(layer, nn.Linear):
        print(f"Layer {i}")
        print("Weights:", layer.weight)
        print("Bias:", layer.bias)
        print()
```


## 4. Check importance(weight) of each layer (Usually 1st matters)

```python
weights = model.network[0].weight.detach()
# importance per input feature
importance = weights.abs().mean(dim=0)
print(importance)
```
