
# What is _Preprocessing_?

👉 In simple words:

> **Preprocessing = preparing raw data before giving it to a machine learning model**

---


## Important Preprocessors.

> 1. **StandardScaller()**
> **Used for converting**: mean =0, standard deviation std =1
> Suitable for: Linear Regression
> Not suitable for: Random Forest , Gradient Boost Regression (Will create way more features to handle)


> 2. **OneHotEncoder()**
> **Used for converting Categorical(string) values into numeric(metrix)**
> **Expands Features**, one column may be converted into many, depending on number of unique values it had.

> 3. **🔹 Text → Numbers (Vectorization)**
> **Converts long text to numbers**
> CountVectorizer → counts words
> TF-IDF → importance of words

# 🎯 Why do we need preprocessing?

Raw data is usually:

- messy 😵
- inconsistent
- contains text, missing values, different scales

👉 Models need **clean, numeric, well-structured data**

---

# 🔧 What comes under preprocessing?

Here are the main tasks (this is the real meaning):

---

## 1. 📏 Scaling (what you understood)

Example:

- Age → 10–50
- Salary → 10,000–1,00,000

## Problem ?

> **The model will think Salary feature is more important as it has way higher values than Age Feature.**

## Solution ?

> **Use Scaler() to bring all the features on one common scale.**

👉 Use scaler:

- `fit()` → learn min/max or mean/std
- `transform()` → bring all to same scale

---

## 2. 🏷️ Encoding (text → numbers)

Example:

"Male", "Female"

👉 Model doesn’t understand text

- Convert to numbers like:

0, 1

---

## 3. 🧩 Handling Missing Values

Example:

Age = [20, 25, None, 30]

👉 Fill missing values:

- mean / median

---

## 4. 🧹 Cleaning Data

- Remove duplicates
- Fix errors
- Handle outliers

---

## 5. 📉 Feature Selection / Reduction

👉 Remove useless columns  
👉 Keep only important ones


---

# Important Fundamentals
## 🔹 1. `fit()`

**Purpose:** Learn parameters from the data.

- It analyzes your dataset and computes necessary statistics.
- Example:
    - In `StandardScaler`, it calculates **mean** and **standard deviation**.
    - In `MinMaxScaler`, it finds **min and max values**.

**Syntax:**

scaler.fit(X)

**Key point:**  
👉 It **does not change the data**, just learns from it.

---

## 🔹 2. `transform()`

**Purpose:** Apply the learned transformation to data.

- Uses parameters learned from `fit()`.
- Converts the dataset accordingly.

**Syntax:**

X_transformed = scaler.transform(X)

**Key point:**  
👉 It **modifies the data**, but does not learn anything new.

---

## 🔹 3. `fit_transform()`

**Purpose:** Combine `fit()` and `transform()` in one step.

- First learns parameters.
- Then immediately applies transformation.

**Syntax:**

X_transformed = scaler.fit_transform(X)