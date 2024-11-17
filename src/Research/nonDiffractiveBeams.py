import numpy as np
import matplotlib.pyplot as plt
import scipy.special
from LightPipesSimulations.pyrula import pyrulamap

# Airy Beam
q = 0.333;
w0 = 30;

# Optical fiber parameters
L = np.arange(0, 40, 0.1)
J = np.abs(scipy.special.jv(q, L))

x = np.linspace(-0, 50, 500)
y = x.reshape(-1, 1)
r = np.sqrt(x**2 + y**2)

J2 = np.abs(scipy.special.jv(q, r))

profile = np.exp(-(pow(L,2))/(pow(w0,2))) * J
fig = plt.figure()
ax = fig.add_subplot()
ax.plot(L/w0, profile, 'r', label='Intensity')
ax.set_title('Airy Beam - Profile')
ax.set_xlabel(r"$\frac{x}{w0}$")
ax.set_ylabel(r"$|E(x)|$")
ax.grid()
ax.minorticks_on()
ax.tick_params(
        axis='both', 
        which='both', 
        direction='in', 
        top=True,
        right=True,
        left=True,
        bottom=True,
        length=2.5,
        width=1.12
)

fig2 = plt.figure()
ax2 = fig2.add_subplot(projection='3d')
ax2.plot_surface(x, y, J2, cmap=pyrulamap, edgecolor='black', linewidth=0.5)
ax2.title.set_text('Airy Beam - 3D Intensity')
ax2.set_xlabel(r"$\frac{x}{w0}$")
ax2.set_ylabel(r"$\frac{y}{w0}$")
ax2.set_zlabel(r"$|E(x,y)|$")

plt.show()
