
>[!Gradient]
>**Tensor has a property 'requires_grad=bool'**
>Default = False

```python
tn = torch.tensor(10, requires_grad=True)
```

In PyTorch,  
`requires_grad` tells the tensor:
> “Should I track operations on this tensor so I can compute gradients later?”

A tensor with `requires_grad=True` does **NOT store all past values**, instead it:
> **builds a computation graph of operations**

So it remembers:
- **what operations were applied**
- **how tensors depend on each other**

Not:
- ❌ every intermediate value explicitly (like a log)
- ✅ but enough information to compute gradients using **Chain Rule**


>[!Important]
>**Only Tensors of floating point and complex dtype can require gradients**

>[!requires_grad --> Gradient]
>**gradient = Derivative**

- Gradient(Derivative) is rate of change, for very small values.
- Derivative's require a Limit, rate of change which is very small... maybe 0.0001 unit of change on an instance.
- **Integer values cannot store: 2.001**, They are either 2 or 3, nothing in between.
- **But float data type can store 2.000 and 2.001.**


## Leaf Tensor

A **leaf tensor** is:
> A tensor created directly by you (not as a result of an operation)


## .grad Property on Tensors

`.grad` stores:

> **The derivative of the final output w.r.t that tensor**

---

## 🔷 Correct Way to Use It

```python
x = torch.tensor(10., requires_grad=True)  
y = x**2 + 3*x + 1  
  
y.backward()  
  
print(x.grad)
```
👉 Output:
23

Because:
$$
d/dx(x^2+3x+1)=2x+3
$$
At x=10 → 20+3=23

---

# 🔷 Why `y.grad` will print None

Because:
- `y` is an **intermediate result**
- PyTorch **does not store gradients for intermediates by default**
👉 This is for **memory efficiency
