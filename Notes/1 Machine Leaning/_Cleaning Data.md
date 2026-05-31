> Its best to remove columns from dataset which have no effect on our predictions.


## Finding Importance of All features

> Its not easy to know importance of features without ML model.
> ML model provides: model.coef_ , model.intercept_ properties, which makes it easy.
> But we can use some other methods to analyse data and useless features.


>[!Important]
>**Don't forget to Fill missing data**

# Step-by-step Feature Checking (Pre-model)
## Step.1

> **Know your TARGET**
> What kind of value you are predicting helps in ignoring features which do not share any relationship with Target value.


## Step 2: Remove Obvious Junk

### 👉 ID column

```python
df['ID'].nunique()
```

> ID , Serial number , Index kind of values are never usefull.

If:
- unique = number of rows → every row different
👉 ❌ Useless for prediction → REMOVE

Why?
- It’s just an identifier, no pattern

---

### 👉 Constant columns (you already saw this)

df.nunique()

If any column = (Constant value) → ❌ remove 
These are **constant in this dataset** → useless

---

## 📊 Step 3: Variance Check (Numerical Features)

```python
df.var(numeric_only=True)
```

If variance ≈ 0 → no change → useless

---

## 📈 Step 4: Correlation with Target (VERY IMPORTANT)

Your target is:  
👉 `Response`

Now check:

```python
df.corr(numeric_only=True)['Response'].sort_values()
```

### Interpretation:

- Close to **0** → weak/no relationship → maybe useless
- Far from 0 → useful feature

|Correlation|Meaning|
|---|---|
|~0|No relationship|
|0.1 – 0.3|Weak|
|0.3 – 0.5|Moderate|
|>0.5|Strong|
## Step 5: Categorical Feature Check

For columns like:
- `Education`
- `Marital_Status`

Use:

```python
import pandas as pd  
pd.crosstab(df['Education'], df['Response'], normalize='index')
```


### What this tells:

- Does response rate change across categories?

If all rows look same → ❌ useless  
If patterns differ → ✅ useful


## Step:6 Combine simillar features...

> If multiple columns are for something simillar or versionised.
> For example: True , False columns for all 7 days => Convert to one Boolean Column for a Week.
> Combined makes it more informative.

Example:

```python
# Smart Feature Engineering (Pro Thinking)

For your dataset:

### Combine campaign columns:

df['TotalAcceptedCmp'] = df[['AcceptedCmp1','AcceptedCmp2',
		'AcceptedCmp3','AcceptedCmp4','AcceptedCmp5']].sum(axis=1)

This is often **more useful than individual ones**
```
