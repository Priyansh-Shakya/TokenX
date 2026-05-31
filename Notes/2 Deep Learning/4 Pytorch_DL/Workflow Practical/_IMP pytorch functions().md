

## 1. tensor.backward()

- ####  When we call backward on any tensor, it does the differentiation of that tensor with respect to the tensor it was created.

### Example

```python
import torch

x = torch.tensor(2. ,requires_grad=True)
y = x * 2

y.backward()
-- Here it will now perform dy/dx because y has x in its equation.

print(x.grad)
-- will print dy/dx
```

## IMPORTANT NOTE

- *tensor.backward()* **will perform diffferentiation of that tensor with every tensor involved in its equation.**
- *tensor.grad* **Will print differenntiaion result of only that tensor on which .grad was called on.**

### Example

```python
import torch

x = torch.tensor(2., requires_grad=true)
y = torch.tensor(4., requires_grad=true)
w = torch.tensor(5., requires_grad=true)

z = x * y + w

z.backward()
-- This will calculate: dz/dx , dz/dy , dz/dw

print(x.grad) -- will print dz/dx
print(y.grad) -- will print dz/dy
print(w.grad) -- will print dz/dw

```

