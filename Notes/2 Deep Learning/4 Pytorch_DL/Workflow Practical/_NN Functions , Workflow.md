
## 🛠 Part 1: The Blueprint (Building the Model)

|**Component**|**What it is**|**When to use it**|**Why?**|
|---|---|---|---|
|**`nn.Linear(in, out)`**|A "Fully Connected" Layer|**Always**|It holds the weights and performs the $xW + b$ math.|
|**`ReLU`**|Activation Function|**In Hidden Layers**|It introduces "curves." Without it, 100 layers are just one big straight line. It stops "negative" signals.|
|**`Sigmoid` / `Softmax`**|Output Activations|**In Classification**|Turns raw numbers into probabilities (0 to 1).|
|**No Activation**|Linear Output|**In Regression**|Because a predicted price or temperature can be any number.|

### The Workflow in `forward(self, x)`:

1. **Input Layer** → **ReLU** (Start finding patterns)
    
2. **Hidden Layer** → **ReLU** (Find complex combinations of patterns)
    
3. **Output Layer** → **(Nothing for Regression)** OR **(Softmax for Classification)**.
    

---

## ⚙️ Part 2: The Engine (Training & Optimization)

|**Tool**|**What it is**|**The "Vibe"**|**When to use?**|
|---|---|---|---|
|**`MSELoss`**|Loss Function|"Distance"|**Regression.** Measures how far apart two numbers are.|
|**`CrossEntropyLoss`**|Loss Function|"Accuracy"|**Classification.** Measures if you picked the right category.|
|**`SGD`**|Optimizer|"The Turtle"|**Simple problems.** Stands for _Stochastic Gradient Descent_. Reliable but slow.|
|**`Adam`**|Optimizer|"The Racecar"|**Most problems.** It automatically adjusts its own speed (learning rate). It’s the "standard" choice.|

---

## 📋 Part 3: The Universal Workflow (Step-by-Step)

### Step 1: Data Prep (The "Handshake" Setup)

- **Format:** Convert everything to `torch.float32`.
    
- **Shape:** Ensure data is 2D: `[BatchSize, Features]`.
    

### Step 2: Define Model (`__init__`)

- Identify `in_features` (from your data columns).
    
- Choose hidden neurons (e.g., 16, 32—your "processing power").
    
- Identify `out_features` (1 for regression, N for classification).
    

### Step 3: Define Flow (`forward`)

- Pass data through layers.
    
- **Decision:** Apply `ReLU` between layers? **Yes**, if the problem is complex. **No**, if it's a simple straight line.
    

### Step 4: The Training Loop (The "Fit" Phase)

This 5-step dance is always the same:

1. **Predict:** `outputs = model(x)`
    
2. **Calculate Loss:** `loss = criterion(outputs, y)`
    
3. **Reset:** `optimizer.zero_grad()` (Clear last turn's memory).
    
4. **Analyze:** `loss.backward()` (Calculate which weights were wrong).
    
5. **Adjust:** `optimizer.step()` (Nudge the weights).
    

### Step 5: Inference (The "Use" Phase)

1. `model.eval()`
    
2. `with torch.no_grad():`
    
3. `prediction = model(new_input)`
    

---

## 📝 Obsidian Note: "When to use ReLU?"

> **Rule of Thumb:** >  **Hidden Layers:** Always use `ReLU`. It allows the network to learn "Non-Linear" logic (IF-THEN type logic).
> 
> 	**(Hidden Layer -> ALWAYS    :   Output Layer -> NEVER)**
> 	
> - **Output Layer (Regression):** Never use `ReLU`. If your target is 50.5, and the model predicts -2.0, you want to know it's -2.0 so you can fix it. If ReLU turns that -2.0 into a 0, the model "loses" the information that it was negative.
>     
> - **Output Layer (Classification):** We usually don't put ReLU here; we use the raw numbers or a "Softmax" to get probabilities.

