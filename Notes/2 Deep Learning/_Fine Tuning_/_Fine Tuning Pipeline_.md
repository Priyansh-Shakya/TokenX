

# Your mental map of modern fine-tuning

Here’s the simplified map:

---
# STAGE 1 — Base pretrained model

Example:
- Llama
- Qwen
- Gemma

These models already know language.

---

# STAGE 2 — Decide memory format

Possible choices:
## Full precision

- FP32
- FP16
- BF16

OR

## Quantized

- 8-bit
- 4-bit

This affects VRAM usage.

---

# STAGE 3 — Decide training method

Choices:

## Full Fine-Tuning

Train ALL weights.

Very expensive.

---

## LoRA

Train tiny adapter matrices.

Frozen base model.

---

## QLoRA

Quantized frozen model + LoRA adapters.

---

# STAGE 4 — Dataset formatting

This becomes:

- chat template
- instruction format
- tokenization
- packing
- collators

This is where many beginners struggle.

---

# STAGE 5 — Training pipeline

Things like:

- optimizer
- learning rate
- scheduler
- batch size
- gradient accumulation

---

# STAGE 6 — Evaluation

Check:

- overfitting
- repetition
- hallucination
- personality consistency
- instruction following

---

# STAGE 7 — Inference / deployment

Possible outputs:

- merged model
- adapter-only
- GGUF
- vLLM serving
- Ollama
- Hugging Face hosting