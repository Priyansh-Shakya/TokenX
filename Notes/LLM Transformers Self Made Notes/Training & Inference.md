

```
TRAINING (happens once, at Anthropic/OpenAI etc.)
├── Embedding table starts as random numbers
├── Model sees billions of sentences
├── Backprop adjusts ALL numbers (embeddings + attention weights)
└── Training ends → everything is FROZEN

INFERENCE (happens when you send a prompt)
├── Your text → tokenizer → list of integer IDs
├── Each ID → lookup in frozen table → get its vector
├── Run attention, feedforward layers (also frozen)
└── Output: probability distribution over next token
```
