

## Embaddings:
- embaddings is a vector a numbers which all together represents a word
- holds semantic meaning of word
- we can apply vector math on these embaddings and compute result which will produce another embadding vector.

## Token:
- while embeddings represent a word in a n-dimensional vector, a token represents a word or part of word with just one integer value.
- This is basically an ID for each number **which** corresponds to one embedding vector.
- Token id points to embedding vector which is used for actual task.

```
Token1 -- Embedding vector 1
Token2 -- Embedding vector 2
Token3 -- Embedding vector 3
```


## Example:

```python
When you enter a prompt in chatgpt like:
"What is capital of india?"
Each word is asigned with an id which we call is 'Token' 

prompt_tokens = [{
	'what': 001,
	'is': 002,
	'capital': 003,
	'of': 004,
	'india': 005,
	'?': 006
}]

Thereafter , each token is asigned with an embedding vector which holds semantic numerical computation of words.

001 - [...]
002 - [...] 
...
```


# <span style="color:rgb(0, 176, 240)">Now... In Tranformer's Self Attention Layer:</span>

### Embedding vectors are not static, They update depending on context.

> In self Attention layer of transformers, we get  three vectors Q , K , V which represents:

| Vector | Meaning                           |
| ------ | --------------------------------- |
| Query  | “What am I looking for?”          |
| Key    | “What information do I contain?”  |
| Value  | “What information should I give?” |
Formula:
		$Attention(Q,K,V)=softmax(​​QK^T/\sqrt{dk}​)V$

### <span style="color:rgb(0, 176, 240)">This basically is a dot product of Query and Key. Where...</span>
If two vectors point in similar directions:

```
large positive value
```

If unrelated:

```
small or negative value
```

Then multiplication with V - The actual information (Value) creates a weighted combination.


