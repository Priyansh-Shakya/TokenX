
## <span style="color:rgb(0, 176, 80)">The basic flow we know is:</span>

> **Tokenize -> Feed to model -> Get Get Tokenized output -> Decode**

## We do that same using Hugging face transformers library:

```python
import transformers
from transformers import AutoTokenizer , AutoModelForCausalLM

model_name = "gpt2"

// Create Instances of tokeizer and model 
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

text = "Once upon a time in india,"
input = tokenizer(text, return_tensors='pt')

// check by decoding it, same text as input...
decode = tokenizer.decode(input['input_ids'])

output = model.generate(**input , max_length=50, temperature=1.0, top_k=100,)

print(tokenizer.decode(output))
```


## Understanding:


>[!Flow]
>String Data
>		|
>Tokenizer(data)  --- Converts Raw String into (string) input_ids , numbers representing words.
>		|
>model.generate(**input) --- tokenizer returns a dictionary of input_ids , attention_mask etc... we unpack it here.
>		|
>tokenizer.decode(output) ---model.generate() returns output which is again input_ids which we decode to get actual words.

---
# <span style="color:rgb(0, 176, 240)">model.generate() Important Parameters</span>

## 🧭 The Core Parameter Controls

### 1. Temperature (Creativity)

- **Analogy:** Choosing the mood of a writer.
    
- **Low values ($0.1$ to $0.4$):** Makes the response very predictable, logical, and safe. The model sticks to the most likely next word.
    
- **High values ($0.8$ to $1.2$):** Makes the response highly creative and surprising, but it might start hallucinating or making spelling mistakes.
    

---

### 2. `top_k` (Candidate Limit)

- Instead of choosing from all ~50,000 tokens:
👉 only consider **top 55 most likely tokens**

- **Analogy:** Limiting the writer to a dictionary of the top $K$ words.
    
- **What it does:** It tells the model: _"Look at the probability of all words, but only consider the top $K$ most likely words before picking one."_
    
- **Example (`top_k=50`):** If the model is trying to predict the next word, it restricts its choices to only the top $50$ candidates. A lower number (like $10$) makes the output rigid, while a higher number (like $50$) gives more variety.

---

### 3. `top_p` / Nucleus Sampling (Dynamic Vocabulary)

- **Analogy:** Selecting options based on a "confidence threshold" until they sum up to $p$.
    
- **What it does:** Instead of fixing the number of words (like `top_k`), it looks at the probability percentages of the words. It keeps adding the most likely words until their combined probabilities reach $p$ (e.g., $90\%$ or $0.9$).
    
- **When to use:** It is more dynamic than `top_k`. If the model is very confident about the next word, the pool shrinks to just 1 or 2 words. If the model is uncertain, the pool widens to include more words.


### 4. `max_length` vs. `max_new_tokens`

- **`max_length`:** Controls the total length of the tokens, including the prompt tokens _plus_ the generated tokens.
  - **`max_length` (Total Limit):** Measures the absolute length of the array from the very first token to the end.
  - If your prompt is $10$ tokens long and you set `max_length=20`, the model will only generate $10$ more tokens. If your prompt is $30$ tokens long and you set `max_length=20`, the script throws an error or cuts off the prompt!

<span style="color:rgb(255, 255, 0)">max_length = input_tokens + generated_tokens</span>

---

- **`max_new_tokens`:** **(Industry Favorite)** Specifies only the number of tokens to _generate_. It makes development easier because you don't have to calculate how long your prompt is.
- **`max_new_tokens` (New Tokens Only):** Ignores the size of the input prompt.
- 
- If you set `max_new_tokens=50`, the model will generate exactly $50$ tokens, regardless of whether your input prompt was $5$ tokens or $100$ tokens long. This prevents your model output from being cut short unexpectedly.

<span style="color:rgb(255, 255, 0)">max_new_tokens = only the newly generated tokens</span>  <span style="color:rgb(0, 176, 240)">(Better than max_length)</span>

- <span style="color:rgb(194, 186, 222)"> Use `max_new_tokens` when you want to control how long the generated answer is, regardless of the input prompt's length.</span>
    
- <span style="color:rgb(194, 186, 222)">Use `max_length` when you are strictly restricted by memory limits (for instance, the model context window cannot exceed 1024 or 2048 tokens).</span>

### 5. `do_sample`

- **What it does:** Acts as the on/off switch for creativity.
    
- **Why it matters:** If you want to use `temperature`, `top_k`, or `top_p`, **you must set `do_sample=True`**. If `do_sample=False`, the model defaults to a greedy search, always picking the single most probable word, ignoring the parameters you set.


### 6. `repetition_penalty`

- **What it does:** Discourages the model from repeating the same words or phrases over and over.
    
- **Range:** Usually set between $1.0$ (no penalty) and $1.2$ (strong penalty). Useful for preventing text loops.


### 7. `num_return_sequences`

- **What it does:** Generates multiple different options or completions for a single prompt.
    
- **Example:** If `num_return_sequences=3`, the model returns 3 different answers, and you can pick the best one.

| **Parameter**            | **Recommended Range**                            | **Purpose & Behavior**                                                                                                    |
| ------------------------ | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| **`temperature`**        | $0.0$ to $2.0$                                   | Controls creativity. $0.0$ is strictly deterministic (greedy), while values above $1.5$ produce gibberish.                |
| **`top_k`**              | $1$ to several thousands (usually $30$ to $100$) | Limits candidates. Setting it to $1$ means the model always picks the single most likely word.                            |
| **`top_p`**              | $0.0$ to $1.0$                                   | Cumulative probability threshold. $0.9$ means the model pools candidates until their combined probabilities reach $90\%$. |
| **`max_length`**         | Positive integers (e.g., $20$ to $1024$)         | The **total limit** of tokens, including both your input prompt and the generated text.                                   |
| **`max_new_tokens`**     | Positive integers (e.g., $10$ to $500$)          | The number of new tokens to generate, **excluding** the input prompt.                                                     |
| **`repetition_penalty`** | $1.0$ to $1.5$                                   | Values above $1.0$ penalize the model for re-using the same words.                                                        |