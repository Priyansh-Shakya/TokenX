
# 💚 Flow of Processes

```python
Raw Data
  ↓
Structured Dataset (input → output)
  ↓
Tokenization (text → numbers)
  ↓
Data Collator (Handles padding , batching etc)
  ↓
Model (pretrained)
  ↓
Training (adjust weights)
  ↓
Evaluation / Testing
```

---

# 🧠 Step 1: Define the Task (VERY IMPORTANT)

We are NOT doing classification.

We are doing:

> **Instruction / chatbot-style generation**

---
## 🧪 Example task

```
User: I feel tired today
Bot: You’ve been working hard—maybe take a short break?
```


# 🧪 Step 2: Create Dataset

## 🔥 Format matters MORE than size

We structure it like:

```python
data = [
    {
        "input": "User: I feel tired today\nBot:",
        "output": "You’ve been working hard—maybe take a short break?"
    },
    {
        "input": "User: I am nervous about exam\nBot:",
        "output": "It’s normal to feel that way—just focus on your preparation."
    }
]
```

---
## 🧠 Why this format?

Because model learns pattern:

```
User → Bot response
```

👉 This is how chatbots are trained

---
# 🧪 Step 3: Convert to Dataset

```python
from datasets import Dataset
dataset = Dataset.from_list(data)
```

## <span style="color:rgb(0, 176, 240)">Dataset creates a Dictionary of two seperate lists of Input and Output.</span>

# 🧠 At this stage:

You have:

```
{"input": "...", "output": "..."}
```

---

## <span style="color:rgb(255, 122, 122)">Note: If you dont have Input-Output paired data...</span>

> **If your data looks like something else, like this:**

```python
 {
        'role' : 'user',
        'text' : 'Hello dear! How are you?'
    },
    {
        'role':'bot',
        'text':'Hey darling!! I am good, what about you? How was your day dear?'
    },
```

## <span style="color:rgb(255, 122, 122)">Use a function like this ,to create I-O Pairs:</span>

```python
def buildIOpairs(data):
  pairs = []
  for i in range(len(data)-1):
    if data[i]['role'] == 'user' and data[i+1]['role'] =='bot':
      pairs.append({
         "input" : f"User: {data[i]['text']}\nBot:",
         "output" : data[i+1]['text']
      })
  return pairs
```

---
# 🧪 Step 4: Tokenization (CRITICAL STEP)

We use a seq2seq model like:

👉 FLAN-T5

---

```python
from transformers import AutoTokenizer
tokenizer = AutoTokenizer.from_pretrained("google/flan-t5-small")
```

---

## 🔥 Tokenization function

<span style="color:rgb(194, 186, 222)">We need to make sure the pad tokens are ignored during loss computation. The standard Hugging Face way to handle this for Seq2Seq models is to replace pad tokens with `-100`.</span>

<span style="color:rgb(0, 176, 240)">-100 is reserved index which the model's loss function will ignore.</span>

## <span style="color:rgb(255, 0, 0)">Below code is for Seq2Seq2 Model:</span>
```python
// DO NOT USE PADDING HERE (Use data collator)

def tokenize(data):
    # Tokenize the input
    model_inputs = tokenizer(
        data['input'], 
        truncation=True, 
        max_length=100
    )
    
    # Tokenize the target/labels
    labels = tokenizer(
        data['output'], 
        truncation=True, 
        max_length=100
    )
    
    model_inputs['labels'] = labels['input_ids']
    return model_inputs

# Map the new function over your structured data
tokenized_data = [tokenize(x) for x in structured_data]

# 1. Convert your tokenized list of dictionaries back into a Dataset object 
tokenized_dataset = Dataset.from_list(tokenized_data) # 2. Set the format to PyTorch tensors so the model can read it 
tokenized_dataset.set_format("torch") # 3. Now it is fully ready for the Trainer 
print(tokenized_dataset)
```

## <span style="color:rgb(255, 0, 0)">Below code is for CausalLanguage model:</span> 
### <span style="color:rgb(0, 176, 240)">Tokenizer and Data Collator</span>

```python
tokenizer.pad_token = tokenizer.eos_token

def tokenize(data):
    text = [
        f"Input: {i}\nOutput: {o}"
        for i, o in zip(data["input"], data["output"])
    ]

    tokens = tokenizer(
        text,
        truncation=True,
        max_length=60
    )

    tokens["labels"] = tokens["input_ids"].copy()

    return tokens

tokenized_dataset = dataset.map(
    tokenize,
    batched=True,
    remove_columns=dataset.column_names
)

from transformers import DataCollatorWithPadding

data_collator = DataCollatorWithPadding(
    tokenizer=tokenizer,
    pad_to_multiple_of=8
)
```

> **Truncation**
> <span style="color:rgb(194, 186, 222)">When 'truncation=True' it means, if our max_length is X and input string is longer than X , remove all the tokens which came after X'th number of token.</span>

# <span style="color:rgb(255, 122, 122)">Creat collator</span>

### <span style="color:rgb(194, 186, 222)">See Collator docs: </span>

```python
from transformers import DataCollatorForSeq2Seq # (ForLanguageModeling for other models)

data_collator = DataCollatorForSeq2Seq(
    tokenizer=tokenizer,
    model=model
)
```

# 🧠 WHAT COLLATOR NOW HANDLES
Automatically:  
✅ dynamic padding  
✅ batch tensor creation  
✅ label padding  
✅ seq2seq batch formatting

(You still need to tokenize data yourself.)
## Apply mapping:  <span style="color:rgb(0, 176, 240)">Only if you did not convert to dataset already using above code.</span>

```python
dataset = dataset.map(tokenize, batched=True, remove_columns=dataset.column_names)
```
### <span style="color:rgb(255, 122, 122)">Note: dataset.map() function is only available on 'transformers' dataset library, not on python's simple list.</span>

---
## 🧠 Why separate input and output tokenization?

Because models like FLAN-T5 are:

> **We have created a 'labels' field ourself for training...**
### 🔁 Encoder–Decoder models

	They work like:

```
Encoder input  → understands inputDecoder output → generates response
```

So:

- `input_ids` → goes to encoder
- `labels` → used to train decoder

👉 That’s why they are **separate**
## 🧠 What just happened?

We created:

```
input_ids → what model reads
labels → what model should generate  
```

---

## ⚠️ Important concept: **labels**

👉 During training:

- model predicts output tokens
- compares with `labels`
- computes loss

<span style="color:rgb(194, 186, 222)">In machine learning, a label is simply the "correct answer" or the "target output" that you want the model to learn to predict</span>

Think of it like a school test:
- **The Question (Input):** _"I love this product"_
- **The Label (Output/Answer):** `1` (which means Positive Sentiment)

### 1. T5 is a Text-to-Text Model

For T5, the target answer is also text (e.g., if the task is to summarize, the target is the summarized text). But the computer doesn't understand text directly, so we must convert the target text into token IDs (numbers) just like we did with the input.

### 2. What `targets["input_ids"]` means

When you pass the target string (e.g., the summarized text or the corrected sentence) into the tokenizer, it creates a dictionary with its own `input_ids`. We take those numerical IDs and store them under the key `"labels"`.

The `Trainer` looks for this `"labels"` key to know exactly what the model _should_ have generated.

---

---
# 🧪 Step 5: Load Model

```python
from transformers import AutoModelForSeq2SeqLM
model = AutoModelForSeq2SeqLM.from_pretrained("google/flan-t5-small")
```

---

# 🧠 Why this model?

- understands instructions
- supports input → output tasks
- better than GPT-2 for structure

---

# 🧪 Step 6: TrainingArguments (DEEP EXPLANATION)

```python
from transformers import TrainingArguments

training_args = TrainingArguments(    
	output_dir="./results",
	per_device_train_batch_size=2,    
	num_train_epochs=3, 
	learning_rate=0.001,   
	logging_steps=1
	)
```

---

## 🔍 Parameter breakdown [Visit Docs](https://huggingface.co/docs/transformers/v5.8.0/en/main_classes/trainer#transformers.TrainingArguments)

---

### 🔹 `output_dir`

```python
output_dir="./results"
```

👉 Where model checkpoints are saved

---

### 🔹 `per_device_train_batch_size`

```python
per_device_train_batch_size=2
```

👉 How many samples per step

- small → less memory
- large → faster but needs GPU

---

### 🔹 `num_train_epochs`

```python
num_train_epochs=3
```

👉 How many times model sees dataset

- too low → underfitting
- too high → overfitting

---

### 🔹 `logging_steps`

```python
logging_steps=1
```

👉 Print logs every step

---

# 🔥 Important parameters YOU DIDN’T USE (but should know)

---

## 🔹 `learning_rate`

```python
learning_rate=5e-5
```

👉 Controls how fast model learns

---

## 🔹 `weight_decay`

```python
weight_decay=0.01
```

👉 Prevents overfitting

---

## 🔹 `save_steps`

```python
save_steps=100
```

👉 Save model every N steps

---

## 🔹 `evaluation_strategy`

```python
evaluation_strategy="steps"
```

👉 Enables validation

---

## 🔹 `fp16`

```python
fp16=True
```

👉 Faster training (GPU only)

---

## 🔹 `gradient_accumulation_steps`

```python
gradient_accumulation_steps=4
```

👉 Simulates larger batch size

# 🧠 Mental model

TrainingArguments = **training behavior controller**

---

# 🧪 Step 7: Trainer (CORE ENGINE)

[Visit Trainer Docs](https://huggingface.co/docs/transformers/en/main_classes/trainer)

```python
from transformers import Trainer
trainer = Trainer(    
	model=model,
	args=training_args,
	train_dataset=dataset
	data_collator = data_collator
	)
```

---

## 🔍 What Trainer does internally

Instead of you writing:

```
for batch in data:
    forward pass
    compute loss
    backprop
```

👉 Trainer does ALL of that

---

## 🔥 Important optional params

---

### 🔹 `eval_dataset`

```python
eval_dataset=val_dataset
```

👉 for validation

---

### 🔹 `tokenizer`

```python
tokenizer=tokenizer
```

👉 helps with padding / decoding

---

### 🔹 `compute_metrics`

Custom evaluation metrics

---

# 🧪 Step 8: Train

```python
trainer.train()
```

---

## 🧠 What happens inside

For each step:

1. model predicts output
2. compares with labels
3. calculates loss
4. updates weights

---

# 🧪 Step 9: Test your model

```python
# these are the additional tokens which your input text will be added with, change accordingly
extra = ["Respond for bot, User:", "\nBot:"]

def test_model(user_input: str):
    # Create the combined string using a distinct variable name
    full_text = extra[0] + " " + user_input + extra[-1]

    # Tokenize and place onto GPU
    inputs = tokenizer(full_text, return_tensors="pt").to('cuda')

    # Generate response (pass the dictionary using **inputs)
    output = model.generate(**inputs, max_length=50, temperature=1.0, top_k=100)

    # Decode and print
    print(tokenizer.decode(output[0], skip_special_tokens=True))
test_model("I am feeling lonely...")
```

---
# 🎯 What you just built

A **mini chatbot personality model**

---

# 🧠 CRITICAL INSIGHT (don’t miss this)

The model is NOT learning:

> “what stress is”

It is learning:

> “how to respond when someone says they are stressed”