
- ### For problems which have Y (Target Array) [1-d shape] , you need to use: 
```python
When Y is a tensor object
y = y.unsqueez(1)
```

- ### To make it 2 Dimensional, Pytorch will give error otherwise.


- ### While working with torch, Apply preprocessing - scale , encode before converting x, y into tensors.
