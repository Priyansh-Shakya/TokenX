

>[!Concept]
>**Create a Straight Line on Data in such a way that it is closest to all the data points as much possible**
>“Given some data, find the best straight-line equation that predicts the output.”


## Best Fit:

We define “best” using a **loss function**.

Most common:

### Mean Squared Error (MSE)

$$Loss=1n∑(ytrue−ypred)2\text{Loss} = \frac{1}{n} \sum (y_{\text{true}} - y_{\text{pred}})^2Loss=n1​∑(ytrue​−ypred​)2$$


$$MSE=1n∑(ytrue−ypred)2\text{MSE} = \frac{1}{n}\sum (y_{true} - y_{pred})^2MSE=n1​∑(ytrue​−ypred​)2$$

👉 This penalizes large mistakes heavily.



# How the Model Learns (CRITICAL for Deep Learning)

This is where linear regression becomes _foundational_ for deep learning.

We **optimize weights** w,bw, bw,b to minimize loss using:

### Gradient Descent

$$w:=w−α⋅∂L∂ww := w - \alpha \cdot \frac{\partial L}{\partial w}w:=w−α⋅∂w∂L$$​

$$w:=w−α∂L∂ww := w - \alpha \frac{\partial L}{\partial w}w:=w−α∂w∂L​$$

$$α: learning rate$$
$$ $∂L∂w\frac{\partial L}{\partial w}∂w∂L​: gradient (direction of steepest increase)$$

👉 We move _opposite_ the gradient → to reduce error.