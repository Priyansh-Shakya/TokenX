
>[! Part of speach]
>**There are total 8 part of speech in english**

## spacy.explain(...)

> *Writes everythings in full form instead of short forms for better understanding of that thing.*


## Part of Speech:

```python

nlp = spacy.load("en_core_web_sm")

doc = nlp("bro, why the hell you have to make it about yourself man? bruh be a man and show some guts, all teh dude here are gooning for you brah!")

for token in doc:
  print(token , "|", token.lemma_, "|", token.pos_, spacy.explain(token.pos_))
```


## Verb and Tense:

```python
for token in doc:
  print(token , "|", token.lemma_, "|", token.tag_, spacy.explain(token.tag_))
```
