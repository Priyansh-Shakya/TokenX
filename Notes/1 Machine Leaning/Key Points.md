
## 1.
- ## Classification metrix -> accuracy_score(true val , prediction )
- ## Regressor metrix -> r2_score(true val , prediction )


## 2.
## Model Properties to understand Features better.

## 🔑 1. `coef_` (Feature Weights)

- Available in **linear models** like:
    - LinearRegression
    - LogisticRegression
    - Ridge

👉 It gives **importance + direction** of each feature.

- Positive → increases prediction
- Negative → decreases prediction
- Larger magnitude → more influence

**Example:** model.coef_

---

## 🎯 2. `intercept_` (Bias Term)

- The constant added to the prediction

👉 Think of it as:

> prediction when all features = 0

model.intercept_

---

## 🌳 3. `feature_importances_` (Tree Models)

- Used in models like:
    - DecisionTreeRegressor
    - RandomForestRegressor
    - GradientBoostingRegressor

👉 It gives **relative importance (0 → 1)** of features.

model.feature_importances_

- Higher value = more important feature
- No direction (unlike `coef_`)


## 3.
### Use this property inside any model to keep target value balanced as much possible:

```python
model = Any_Model(class_weight='balanced') #Balance target
```


### 4.
#### Text to Number (Vectorization)

```python
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer

# EXAMPLE
texts = ["I love AI", "AI is amazing", "I like football"]  
  

vectorizer = TfidfVectorizer() --- 
Use max_features=1000 (any number)   (1000-5000 is good)
To Limit the vector to include only that number of most important words.  
X = vectorizer.fit_transform(texts)
```


## 5.

#### Combine different data together - crs matrix , arryas etc:

```python
from scipy.sparse import hstack
import numpy as np

# 1. Grab your numeric column and make sure it's 2D (like the others)
subjectivity = x_train[['Sentiment_Subjectivity']].values

# 2. Stack them all horizontally
X_combined_sparse = hstack([x_cat_encoded, x_vector_gen, subjectivity])

# 3. Convert to a dense NumPy array (Tensors need dense data)
X_combined_dense = X_combined_sparse.toarray()
```
	