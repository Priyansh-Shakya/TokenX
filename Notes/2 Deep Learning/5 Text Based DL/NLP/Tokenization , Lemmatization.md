

>[!Load The English Model]
>**Load a pre-trained english model which has knowledge of grammer and stuff...**

```python
import spacy

nlp = spacy.load("en_core_web_sm")

doc = nlp(--PASS_A_TEXT_OBJECT--)

--- TOKENIZATION ---

for token in doc:
  print(token)
  

--- LEMMATIZATION ---

for word in doc:
  print(word , "|", word.lemma_)  <------ LEMMATIZATION function
```




### Pipelines in SpaCY

> *Type* **nlp.pipe_names** *to see all the pipelines(kind of functions) you have*


### Create your own Lemma word.

>[!Meaning]
>**Basically means , spaCy's lematization model does not know all the slangs we can use for a base word. So we can provide custom lemma where n number of provided slangs will have an asigned Base word.**


### USING attribute_ruler.

```python
nlp.pipe_names

o/p:
['tok2vec', 'tagger', 'parser', 'attribute_ruler', 'lemmatizer', 'ner']

```


### Get a Pipeline

```python
pipe_name = nlp.get_pipe("NAME OF PIPELINE FROM ABOVE MENTIONED ONES")
```



```python
ar = nlp.get_pipe("attribute_ruler")

-- ADD a list of dictionary of slang words , and its base word (Lemma)
ar.add(
	[
	[{'TEXT': 'bro'}],  -- SYNTAX:  {'Keyword TEXT' : 'Slang word'}
	[{'TEXT'}: 'bruh'],
	[{'TEXT'}: 'blud'],
	[{'TEXT'}: 'brah'],
	],
	{'LEMMA': 'brother'} --- Actual Base Word (out of 2d list)
	)
```