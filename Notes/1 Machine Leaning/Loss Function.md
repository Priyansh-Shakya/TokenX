
## Definition
A loss function measures how far the model’s prediction is from the true value.

Loss = Model Mistake Score

Lower loss → Better model
Higher loss → Worse model

## Purpose
- Guides the model during training
- Helps adjust weights to improve predictions
- Optimization algorithms try to minimize loss

## Simple Idea
Prediction - Actual = Error  
Loss Function = Mathematical way to measure that error

## Common Loss Functions
Regression:
- Mean Squared Error (MSE)
- Mean Absolute Error (MAE)

Classification:
- Cross Entropy Loss
- Log Loss

## Training Goal
Minimize the loss using optimization algorithms (like Gradient Descent)

## Memory Trick
Model learns by:
Predict → Compare → Calculate Loss → Adjust Weights → Repeat

# *Implementation in Scikit Learn*

```python
from sklearn.metrics import mean_squared_error # import metrix

print(mean_squared_error(y_test , y_pred))
// Needs - true value , predicted value (same as evaluation metrix)
```

>[!Important Points]
>**Mean square error (MSE), or root of MSE (RMSE) does not have a universal scale factor.**

## Scale factor for RMSE

*The target value range decides scale factor for MSE , RMSE values.*

## Scale Range of Target:
| **If Target is...** | **Range** | **RMSE = 2.1 is...** | **Why?**                                                                                 |
| ------------------- | --------- | -------------------- | ---------------------------------------------------------------------------------------- |
| **Exam Score**      | 0 to 100  | **Amazing**          | Being off by 2% is a very tight prediction.                                              |
| **Age**             | 0 to 110  | **Great**            | Predicting a 20-year-old as 22 is very close.                                            |
| **GPA**             | 0 to 4.0  | **Terrible**         | Being off by 2.0 means predicting a 4.0 student as a 2.0 (Failing).                      |
| **House Price**     | $200k+    | Amazing              | Being off by ~$2k on a $200k house is only about **1% error**, which is very accurate.\| |

> If RMSE is let say 2.5 (squared value which means it can be positive or negative).
> Then most of our model's predictions are off by  + ,- 2.5.
> If your prediction was = 65. Then actual value could be = 65 - 2.5 or 65 + 2.5

$$
\text{Error %} = \frac{RMSE}{\text{Range}}
$$


## Classification Loss Averages:

| Loss  | Meaning           |
| ----- | ----------------- |
| > 2   | ❌ Very bad        |
| ~1    | 🤔 Random-ish     |
| ~0.5  | 🙂 Learning       |
| ~0.1  | ✅ Good            |
| ~0.01 | 🔥 Very confident |