
## 🔹 What is Clustering?

Clustering is an **unsupervised learning** technique where:

- No labels (`y`) are given
- Model groups similar data points together

👉 Goal: **Find hidden patterns / groups in data**

---

## 🔹 Most Important Algorithm: K-Means

### 💡 Idea:

- Choose number of clusters `k`
- Assign points to nearest cluster center
- Update centers repeatedly

👉 Objective:
$$
∑i=1k∑x∈Ci∣∣x−μi∣∣2\sum_{i=1}^{k} \sum_{x \in C_i} ||x - \mu_i||^2∑i=1k​∑x∈Ci​​∣∣x−μi​∣∣2
$$
Minimize distance between points and their cluster center.

---

## 🔹 Basic Implementation

```python
from sklearn.cluster import KMeans  
  
# create model  
kmeans = KMeans(n_clusters=3, random_state=42)  
  
# train model (NO y)  
kmeans.fit(X)  
  
# get cluster labels  
labels = kmeans.labels_  
  
# OR directly predict  
labels = kmeans.fit_predict(X)
```

---

### Now to understand:

> Add a column cluster in dataframe:

```python
df['cluster'] = kmeans.labels_

-- Now check how it looks:
df.groupby('cluster').mean()
```

---
## 🔹 Important Parameters

```python

KMeans(  
    n_clusters=3,     # number of groups  
    random_state=42,  # reproducibility  
    n_init=10         # number of initializations  
)

```
---

## 🔹 Output You Get

```python
labels = kmeans.labels_          # cluster of each point  
centers = kmeans.cluster_centers_  # cluster centers
```


---

## 🔹 Choosing Best K (Elbow Method)

👉 Problem: How many clusters?

### Idea:

- Try different `k`
- Measure error (inertia)
- Choose point where improvement slows


```python
inertia = []  

for k in range(1, 10):  
    model = KMeans(n_clusters=k)  
    model.fit(X)  
    inertia.append(model.inertia_)

#Plot:
import matplotlib.pyplot as plt  
  
plt.plot(range(1,10), inertia)  
plt.xlabel("K")  
plt.ylabel("Inertia")  
plt.show()
```

👉 Choose “elbow point”

---

## 🔹 When to Use Scaling

Use **StandardScaler** before clustering:

from sklearn.preprocessing import StandardScaler  
  
scaler = StandardScaler()  
X_scaled = scaler.fit_transform(X)

👉 Because KMeans uses **distance**

---

## 🔹 Key Differences (vs Classification)

|Feature|Classification|Clustering|
|---|---|---|
|Labels (y)|Required|Not used|
|Goal|Predict|Group|
|Fit method|fit(X, y)|fit(X)|

---

## 🔹 Other Clustering Algorithms (Brief)

### 1. DBSCAN

- Finds dense regions
- No need to choose `k`

from sklearn.cluster import DBSCAN  
  
model = DBSCAN(eps=0.5, min_samples=5)  
labels = model.fit_predict(X)

---

### 2. Hierarchical Clustering

- Builds tree of clusters
- Used for visualization

---

## 🔹 Common Use Cases

- Customer segmentation
- Image grouping
- Anomaly detection
- Recommendation systems

---

## 🔹 Important Tips

✅ Always scale data  
✅ Try multiple `k` values  
✅ Visualize clusters if possible  
❌ Don’t expect perfect accuracy (no labels)



# Important points:

# 📌 1️⃣ Do we need train-test split in clustering?

### ✅ Short Answer:

**Usually NO**

You’re correct:

- No `y` (labels)
- No “prediction” in traditional sense
- Just grouping data

---

### 💡 Why no split?

Clustering is:

"Understand structure of THIS dataset"

Not:

"Generalize to unseen data"

So normally:

model.fit(X)

That’s it.

---

### ⚠️ But in real-world (advanced cases):

Sometimes you _do_ split when:

- You want to test cluster stability
- You later use clusters for another model
- Production systems (rare at beginner level)

👉 For now: **don’t worry about splitting**

---

# 📌 2️⃣ What are `inertia_`, `labels_`, `cluster_centers_`?

All from **scikit-learn KMeans**

---

## 🔹 `labels_`

labels = model.labels_

👉 Output:

- Which cluster each data point belongs to

Example:

[0, 1, 1, 2, 0]

Means:

- point1 → cluster 0
- point2 → cluster 1

---

## 🔹 `cluster_centers_`

centers = model.cluster_centers_

👉 Output:

- Coordinates of each cluster center

Example:

[  
 [2.1, 3.5],  
 [8.2, 1.3],  
 [5.5, 6.7]  
]

Means:

- 3 clusters → each has a center

---

## 🔹 `inertia_` (VERY IMPORTANT)

model.inertia_

👉 It measures:

> “How tight the clusters are”

Mathematically:

∑i=1k∑x∈Ci∣∣x−μi∣∣2\sum_{i=1}^{k} \sum_{x \in C_i} ||x - \mu_i||^2∑i=1k​∑x∈Ci​​∣∣x−μi​∣∣2

---

### 💡 In simple terms:

- Distance of each point from its cluster center
- Sum of all distances

---

### 📊 Interpretation:

|Inertia|Meaning|
|---|---|
|Low|Good clustering|
|High|Poor clustering|

---

### ⚠️ Important:

- Inertia always decreases when K increases
- So don’t blindly minimize → use **Elbow Method**

---

# 📌 3️⃣ What is `n_init`?

KMeans(n_init=10)

---

### 💡 Problem in KMeans:

KMeans starts with **random cluster centers**

So results can change:

Run 1 → good clusters    
Run 2 → bad clusters

---

### ✅ Solution: `n_init`

- Run KMeans multiple times
- Pick the best result (lowest inertia)

---

### Example:

n_init = 10

Means:

Run algorithm 10 times  
→ choose best clustering

---

### 📌 Rule:

- Keep `n_init=10` (default is fine)
- Higher = more stable, but slower