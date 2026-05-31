
In PyTorch, it’s the engine that:
- builds computation graphs
- computes gradients automatically
- enables training via **Backpropagation**


### Autograd works in 3 steps:

###### 1. **Forward pass** → compute output
###### 2. **Build graph** → track operations
###### 3. **Backward pass** → compute gradients



## 1. Building the Graph (The Blueprint)

In PyTorch, we use **Dynamic Computational Graphs** (called _Autograd_). Unlike some other frameworks where the graph is static, PyTorch builds a new graph every single time you perform a calculation.

- **What it is:** A collection of **Nodes** (your Tensors) and **Edges** (the mathematical operations like addition or multiplication).
    
- **The "Requires Grad" trigger:** When you set `requires_grad=True` on a tensor (like your weights $W$), PyTorch starts "watching" it.
    
- **The Tracker:** Every time you do `y = x * w`, PyTorch records that operation in a hidden object called `grad_fn`. This allows it to remember exactly how `y` was created so it can reverse the math later.
    

---

## 2. The Forward Pass (The Prediction)

This is the "straightforward" part. You feed your input data through the layers of the network to get an output.

- **The Flow:** Data $\to$ Weights/Biases $\to$ Activation Function $\to$ Prediction.
    
- **The Loss Calculation:** At the end of the forward pass, we compare the **Prediction** to the **Actual Target** using a Loss Function (like Mean Squared Error).
    
- **Mathematical view:** If $f(x)$ is your network, the forward pass is simply calculating $y = f(x)$.
    

> **Analogy:** You are taking a practice exam. The Forward Pass is you answering the questions based on what you currently know. The "Loss" is the score you get back showing how many you got wrong.

---

## 3. The Backward Pass (The Learning)

This is where the "Calculus" we discussed earlier happens. PyTorch uses the **Chain Rule** to calculate how much each weight contributed to the error.

- **The Trigger:** It starts when you call `loss.backward()`.
    
- **The Process:** 1. PyTorch looks at the final Loss value.
    
    2. It travels **backwards** through the Computational Graph.
    
    3. It calculates the **gradient** (the derivative) for every tensor that had `requires_grad=True`.
    
- **The Result:** The gradients are stored in the `.grad` property of your tensors.
    
    - _Example:_ If a weight $w$ has `w.grad = 0.5`, it means "If we increase $w$ by a tiny bit, the error will increase by $0.5$."
        

---

## The Full Cycle Summary

| **Phase**         | **Direction**      | **Purpose**                             | **PyTorch Command**     |
| ----------------- | ------------------ | --------------------------------------- | ----------------------- |
| **Build Graph**   | Implicit           | Track operations for calculus.          | `requires_grad=True`    |
| **Forward Pass**  | Input $\to$ Output | Make a prediction and find Loss.        | `output = model(input)` |
| **Backward Pass** | Output $\to$ Input | Calculate gradients (blame assignment). | `loss.backward()`       |
| **Step (Bonus)**  | Update             | Change weights to reduce error.         | `optimizer.step()`      |

