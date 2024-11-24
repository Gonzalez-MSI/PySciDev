import numpy as np
import cmath

I = np.array([[2+1j, -1j], [-5j, 4j-3]])
b = np.array([[10], [0]])

Isolve = np.linalg.solve(I, b)
print(Isolve)
