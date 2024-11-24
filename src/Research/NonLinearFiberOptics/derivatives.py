import numpy as np
import findiff as fd
import matplotlib.pyplot as plt

A = 1
f = 1
fs = 1000*f
Ts = 1/fs

start = 0.0
stop = 1.0
t = np.arange(start, stop, Ts)
y = np.arctan(A*np.sin(2*np.pi*f*t))
dy = (1/1e3)*fd.FinDiff(0, Ts, 3)(y)

fig = plt.figure()
ax = fig.add_subplot()
ax.plot(t, y, label=r'$y(t)$')
ax.plot(t, dy, label=r'$\frac{dy(t)}{dt}$')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Amplitude')
ax.set_title('Finite Difference Derivative')
ax.legend(loc='upper right')
ax.grid()
plt.show()
