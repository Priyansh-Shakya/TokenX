
| **Action**         | **Method**              | **Memory Sharing?** | **Notes**                                        |
| ------------------ | ----------------------- | ------------------- | ------------------------------------------------ |
| **NumPy → Tensor** | `torch.from_numpy(arr)` | **Yes** ✅           | Changes to `arr` will reflect in the tensor.     |
| **NumPy → Tensor** | `torch.tensor(arr)`     | **No** ❌            | Always **copies** the data. Slower but safer.    |
| **Tensor → NumPy** | `t.numpy()`             | **Yes** ✅           | Only works if the tensor is on **CPU**.          |
| **Tensor → NumPy** | `t.detach().numpy()`    | **Yes** ✅           | Use this if the tensor has `requires_grad=True`. |
| **Tensor → NumPy** | `t.cpu().numpy()`       | **No** ❌            | Use this if the tensor is on a **GPU**.          |

### ⚠️ The "Gotchas" of Memory Sharing

Since `from_numpy()` and `.numpy()` share the same underlying memory (buffer), keep these rules in mind:

1. **In-place Changes:** If you have `t = torch.from_numpy(n)`, and you run `n += 1`, your tensor **`t` will also increase by 1**.
    
2. **The "Leaf" Rule:** You cannot convert a tensor that is part of a computation graph (has `requires_grad=True`) directly to NumPy. You must call `.detach()` first to "break it off" from the graph.
    
    > **Correct way:** `arr = t.detach().numpy()`
    
3. **Device Restriction:** NumPy only lives on the CPU. If your tensor is on `cuda:0` (GPU), you must move it to CPU first.
    
    > **Correct way:** `arr = t.cpu().numpy()`