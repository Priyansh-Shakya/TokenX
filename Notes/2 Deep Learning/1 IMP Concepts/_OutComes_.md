
**The Golden Rule of Testing:**

- **Train:** `vectorizer.fit_transform(x_train)` (Learns the vocabulary AND converts).
    
- **Test:** `vectorizer.transform(x_test)` (Uses the **Train** vocabulary to convert).
    
- **Never** call `.fit` on test data. If the test set has a word the training set didn't have, the vectorizer should just ignore it. That is how you prevent "cheating" (leakage).


## train , test Conversion to NumPy

- ### If sparse_matrix => Use : x_train = x_train.toarray()

 - ### If pandas.series  , DF=> Use : y_train = y_train.to_numpy


>[!Balancing Data]
>**If you want to balance dataset.**
>First Split dataset , and then only ba;ance the training dataset!

## Forward Pass:

> Wx + b : W = Weights of x feature , b = bias


