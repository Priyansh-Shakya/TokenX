
# PEFT
### <span style="color:rgb(0, 176, 240)">PEFT (Parameter efficient fine tuning) means fine tuning a small subset of parameters instead of updating the entire model.</span>

## PEFT Family:

# 1. LoRA (Low Rank Adaption)

## LoRA
Original weight:

$W′=W+BA$

Where:
- `W` = frozen pretrained weights
- `B` and `A` = small trainable low-rank matrices

Instead of training huge `W`, we only train tiny matrices.

# 2. QLoRA (Quantized Low Rank Adaption)

## Quantized model:
### Neural network weights are normally stored as high precision numbers.

Example:
```
0.827364891-1.283746280.00019473
```

Usually:
- FP32 → 32-bit float
- FP16 → 16-bit float
- BF16 → 16-bit float variant

These consume lots of memory.

---
Quantization means:

> Store weights using fewer bits.

Example:
- 8-bit
- 4-bit

instead of:

- 16-bit
- 32-bit

---
So instead of storing:

```
0.827364891
```

maybe approximated into something representable in 4-bit space.
You lose some precision,  
BUT drastically reduce memory.