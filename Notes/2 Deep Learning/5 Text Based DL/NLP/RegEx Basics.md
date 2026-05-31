
### <span style="color:rgb(0, 176, 80)"><br> It is basically a Preprocessing tool for Text Data.<br><br></span>

**Regex (Regular Expressions) in Python** is a way to search, match, and manipulate text using patterns. Python provides this functionality through the built-in re module.

```python
import re

text = "My phone number is 9876543210"
pattern = r"\d+"   # matches digits

result = re.findall(pattern, text)
print(result)
```

---

## 🔹 Core Regex Functions in Python (`re` module)

|Function|Use Case|Example|
|---|---|---|
|`re.findall(pattern, text)`|Extract **all matches** of a pattern|`re.findall(r"\d+", "I have 2 cats and 3 dogs") → ['2','3']`|
|`re.search(pattern, text)`|Find **first match**; returns match object|`re.search(r"\d+", "I have 2 cats") → match object`|
|`re.match(pattern, text)`|Checks **match at start of string**|`re.match(r"\d+", "2 cats") → match object`|
|`re.sub(pattern, repl, text)`|**Replace** matched patterns|`re.sub(r"\d+", "", "I have 2 cats") → "I have cats"`|
|`re.split(pattern, text)`|**Split text** based on pattern|`re.split(r"\s+", "Split this text") → ['Split','this','text']`|

---

### 🔹 Most Useful Regex Patterns for ML/NLP 

|Pattern|Meaning|Example|
|---|---|---|
|`\d`|Any digit|`\d+ → 123`|
|`\w`|Any word character|`\w+ → Hello123`|
|`\s`|Any whitespace|`\s+ → space/tab/newline`|
|`.`|Any character|`a.c → "abc","a1c"`|
|`[^a-zA-Z]`|Anything not a letter|Remove numbers/punctuations|
|`^`|Start of string|`^Hello → match "Hello world"`|
|`$`|End of string|`world$ → match "Hello world"`|

## In Deep Learning (DL)

In frameworks like TensorFlow or PyTorch:
- Regex is used **before training**, not inside neural networks
- Helps prepare clean input for:
    - RNNs
    - LSTMs
    - Transformers (like BERT)

