
## Why do we need to Transpose Key (Key) Metrix?

### The 2D View (Ignoring Batch)

Forget the Batch for a second. Let's say we have one sentence:

- **Q (Query):** Shape $[3, 512]$ (3 words, each has a vector of 512 numbers).
    
- **K (Key):** Shape $[3, 512]$ (3 words, each has a vector of 512 numbers).
    

In Matrix Multiplication $(A \times B)$, the **columns** of the first must match the **rows** of the second.

- If you do $Q \times K$, you are trying to do $(3, \mathbf{512}) \times (\mathbf{3}, 512)$. **Error!** The 512 doesn't match the 3.
    

But if you **transpose** $K$, it flips from $(3, 512)$ to $(512, 3)$.

- Now you do $Q \times K^T$: $(3, \mathbf{512}) \times (\mathbf{512}, 3)$.
    
- The "inner" numbers (512) match and disappear.
    
- The "outer" numbers remain, giving you a **(3, 3)** matrix.
    

This **(3, 3)** matrix is exactly what we wanted: **Length x Length**.