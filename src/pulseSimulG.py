import numpy as np
import matplotlib.pyplot as plt
import scipy
import scipy.special

q = 0;          # Bessel function order  
w0 = 10;        # Beam waist

# Beam profile
L = np.arange(-20, 20, 0.00001)     
J = np.abs(scipy.special.jv(q, L))                  # Bessel function modulation
profile = np.exp(-(pow(L,2))/(pow(w0,2))) * J       # Gaussian beam envelope

fig = plt.figure()
ax = fig.add_subplot()
ax.plot(L/w0, profile, color='red', label=r"$q=0$")
ax.legend()
ax.set_title("Gaussian Beam Profile")
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
plt.show()