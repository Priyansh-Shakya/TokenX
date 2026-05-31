
# What is a Pipeline in sklearn?

A **Pipeline** is just a way to **chain multiple steps together** so your data flows like this:

Raw Data → Transformations → Model → Predictions

Instead of writing separate code for each step, you bundle everything into one object.

---

# 🧠 Why pipelines exist

Without pipeline, you were doing:

x_expanded = PolynomialFeatures().fit_transform(x)  
x_scaled = scaler.fit_transform(x_expanded)  
model.fit(x_scaled, y)

Problems:

- ❌ messy code
- ❌ easy to forget steps
- ❌ data leakage risk (VERY important)
- ❌ hard to reuse

---

# ✅ With Pipeline

from sklearn.pipeline import Pipeline  

```python
pipeline = Pipeline([  
    ("poly", PolynomialFeatures(degree=2)),  
    ("scaler", StandardScaler()),  
    ("model", LinearRegression())  
])
```

Now just:

pipeline.fit(x_train, y_train)  
y_pred = pipeline.predict(x_test)


## *Accessing single step of pipeline*

> pipeline.named_steps['step_name'].property

---

# `ColumnTransformer` (Quick Note)

## ✅ What it is

`ColumnTransformer` (from scikit-learn) lets you **apply different preprocessing to different columns**.

---
```python
from sklearn.compose import  ColumnTransformer
```
## 🎯 When to use

Use it when your dataset has:

- **categorical features** → need encoding
- **numerical features** → need scaling

👉 Basically: _almost every real dataset_

---

## ⚙️ How it works

You define:

(transform_name, transformer, columns)

Example:

```python
ColumnTransformer([  
    ('cat', OneHotEncoder(), categorical_cols),  
    ('num', StandardScaler(), numerical_cols)  
])
```

👉 Internally it:

1. Splits dataset by column groups
2. Applies respective transformations
3. Combines everything into one output

---

## 🔗 With Pipeline

You plug it into a pipeline like this:

```python
pipe = Pipeline([  
    ('process', preprocesses),   # ColumnTransformer  
    ('model', LinearRegression())  
])
```

---
# 🔥 What actually happens internally

When you call:

pipeline.fit(x_train, y_train)

It runs step-by-step:
1. `PolynomialFeatures.fit_transform(x_train)`
2. `StandardScaler.fit_transform(...)`
3. `LinearRegression.fit(...)`

---

And during prediction:
pipeline.predict(x_test)

It runs:
1. `PolynomialFeatures.transform(x_test)`
2. `StandardScaler.transform(...)`
3. `model.predict(...)`

👉 Notice:
- **fit only happens on training data**
- test data only gets **transform**, not fit  
    ➡️ prevents **data leakage**

---

# 🚨 Why pipelines are VERY important

## 1. Prevents Data Leakage

Big concept.

Wrong way:

scaler.fit(x)  # using full dataset ❌

Pipeline ensures:

fit → only on train  
transform → on test

---

## 2. Cleaner code

Instead of 5–6 steps → 1 object

---

## 3. Works with GridSearchCV (super powerful)

You can tune everything:

from sklearn.model_selection import GridSearchCV  
  
params = {  
    "poly__degree": [1, 2, 3],  
    "model__alpha": [0.1, 1, 10]  
}

👉 Note the naming:

stepname__parameter

---

## 4. Reproducibility

Same pipeline = same transformations every time

---

# 🧩 Structure of a pipeline

Pipeline([  
    ("step_name_1", transformer),  
    ("step_name_2", transformer),  
    ("final_step", model)  
])

### Important:

- All steps except last → must be **transformers**
- Last step → must be **estimator (model)**

