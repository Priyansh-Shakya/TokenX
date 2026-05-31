> **Using Scikit Learn Module**

## Process:

>[!Steps]
>Load data
  Split data
  Preprocess (scaling, cleaning)
  Train model
  Predict
  

# 🧠 🔑 PREPROCESSING CHEAT SHEET

## 1. What each preprocessor does + returns

|Preprocessor|Use case|Input|Output|
|---|---|---|---|
|StandardScaler|Scale numeric data|2D (DataFrame/array)|**2D NumPy array**|
|OneHotEncoder|Categorical → binary|2D|**2D NumPy array**|
|CountVectorizer / TfidfVectorizer|Text → numbers|1D (text column)|**2D sparse matrix**|
|PolynomialFeatures|Feature expansion|2D|**2D NumPy array**|

---

## 🧠 Golden rule

> ✅ Almost ALL transformers return **2D arrays**  
> ❌ They **DO NOT return DataFrames (no column names)**

---

# 📦 2. What goes INTO each thing

## ✅ ColumnTransformer (the “chef”)

Using ColumnTransformer

ColumnTransformer(  
    transformers=[  
        ('cat', OneHotEncoder(), cat_columns),  
        ('num', StandardScaler(), num_columns)  
    ]  
)

👉 You pass:

- ✔️ **column names (list / Index)**
- ❌ NOT data (`x_cat`, `x_num`)

---

## ✅ Pipeline (the “recipe”)

Using Pipeline

pipeline = Pipeline([  
    ('preprocessing', preprocessor),  
    ('model', LogisticRegression())  
])

---

## ✅ What you pass to Pipeline

pipeline.fit(X_train, y_train)

👉 You pass:

- ✔️ Full **X_train (DataFrame)**
- ✔️ **y_train (1D)**

---

# 🔁 3. Full Workflow (THE COOKING FLOW)

```python
Raw Data (DataFrame)  
        ↓  
train_test_split  
        ↓  
X_train (2D), y_train (1D)  
        ↓  
Pipeline.fit(X_train, y_train)  
        ↓  
ColumnTransformer:  
    - picks columns  
    - applies transformers  
    - combines into 2D array  
        ↓  
Model trains

```

### Core Tools Only

Just remember these categories:
#### Models:
- LinearRegression
- LogisticRegression
- KNeighborsClassifier
- RandomForest
#### Preprocessing:
- StandardScaler
- PolynomialFeatures
#### Splitting:
- train_test_split
#### Metrics:
- r2_score
- accuracy_score


## Classes to Remember:
- sklearn.preprocessing → scaling
- sklearn.model_selection → splitting
- sklearn.metrics → evaluation
- sklearn.ensemble → advanced models


# *Important Key Points:*

 >[!Handle Missing Values]
 >- Always Check for null values before passing into train test split (Check in your final x , y datasets)
 >-  suppose your 2 input , traget datasets are => X , Y

### X.isna().sum()

> This command will give list of all columns with numer of missing values

### df['feature'] = df['feature'].fillna(df['feature'].median()/mean())

> This command will fill the null cells with median/mean values

- Check is any missing value exists?

### df['feature].isna().sum()

> Should print 0 after we fill them!



>[!Small Workflow]
>Train_Test_Split - gives you x train , x test , y train , y test
>Pass x train , y train to our Pipeline
>Pipeline will pass them to ColumnTransform()
