
### <span style="color:rgb(255, 0, 0)">To get list of all possible functions of an object in python, use :</span>

```python
dir(OBJECT)

EXAMPLE:

dir(nlp)
dir(doc)
dir(token) <----- is_digit , is_currency , is_stop etc...
```

## 1. Example preprocessing (lemmatization, stopword removal)

- ### For Tokens

```python
def preprocess(doc):  
    return [  
        token.lemma_.lower()  
        for token in doc  
        if not token.is_stop and not token.is_punct  
    ]  
  
df["tokens"] = [preprocess(doc) for doc in nlp.pipe(df["text"])]
```

---

## 2. For cleaned text (not tokens)

```python
df["clean_text"] = [  
    " ".join(  
        token.lemma_.lower()  
        for token in doc  
        if not token.is_stop and not token.is_punct  
    )  
    for doc in nlp.pipe(df["text"])  
]
```
---

## IMPORTANT:

#### nlp.pipe(text) applies all the functions of processing text - lemma , tokenizer , parser , tagger.
- Our process function just removes stop words etc and converts it to list.

- `nlp.pipe()` → **analyzes language**
- `preprocess()` → **decides what to keep**


### To make things fast

If you only care about lemmas + filtering, you can **disable unused components** to speed things up:

```python
for doc in nlp.pipe(df["title"], disable=["parser", "ner"])
```


## <span style="color:rgb(0, 176, 80)">nlp.pipe() Expects a list of string , not single strings</span>
---

## <span style="color:rgb(82, 165, 255)">nlp.pipe() Returns a Object(List)/Generator of doc.</span>

- ## Use two loops to get actual tken.

```python
for doc in nlp.pipe(texts):   # loop over Docs
    for token in doc:         # loop over Tokens
```

