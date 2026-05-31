
>[!Stop Words]
><span style="color:rgb(255, 0, 0)"><span style="color:rgb(0, 176, 240)"><b>All the general words in a Text which does not provide any help to classify what the text is about</b><br><b>Examples: a , or , an , the , for , if , is , and , not , in etc...</b></span></span>

---
```python
from spacy.lang.en.stop_words import STOP_WORDS

-- here: spac.lang (language) -> lang.en (english)
```
---

## Print Common Stop Words:

```python
print(STOP_WORDS)

o/p:
{"'d","'ll","'m","'re","'s","'ve",'a','about','above','across','after','afterwards',
'again','against','all','almost','alone','along','already','also','although','always',
  ...
 }
```

---

## Check if token is stop word:

```python
for token in doc:
  if token.is_stop:  -- is_stop is the function()
    print(token)
```


# <span style="color:rgb(146, 208, 80)">Restrict some stop_words from being removed</span>

```python
# List of words you want to keep
words_to_keep = ["not", "no", "don't", "don", "nt", "can't", "couldn't", "won't"]

for word in words_to_keep:
    nlp.vocab[word].is_stop = False
```

> **Run this before tokenizing.**

## <span style="color:rgb(255, 0, 0)">Or better, do this:</span>

```python
# Updated Token generation
ARR = ["List of words , restructed from being removed"]

df['Token'] = [
    [token.lemma_.lower() for token in doc 
     if (not token.is_stop or token.lemma_.lower() in ARR) 
     and not token.is_punct] 
    for doc in nlp.pipe(df['Text'])
]
```
