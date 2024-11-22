import numpy as np
import matplotlib.pyplot as plt

def sech(x):
    return 2/(np.exp(x) + np.exp(-x))

t = np.linspace(-10, 10, 1000)
y = sech(t)
plt.plot(t, y)
plt.title(r'$sech(t)$')
plt.xlabel(r'$t$')
plt.ylabel(r'$sech(t)$')
plt.grid()
plt.show()
