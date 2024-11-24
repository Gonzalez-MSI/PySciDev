import numpy as np
from LightPipes.units import *
import matplotlib.pyplot as plt

A1 = 0.6961663; A2 = 0.4079426; A3 = 0.8974794
B1 = 0.0684043**2; B2 = 0.1162414**2; B3 = 9.896161**2

lambda_um = np.linspace(0.3, 1.7) # wavelength range in microns

M1 = A1*np.power(lambda_um, 2)/(np.power(lambda_um, 2) - B1)
M2 = A2*np.power(lambda_um, 2)/(np.power(lambda_um, 2) - B2)
M3 = A3*np.power(lambda_um, 2)/(np.power(lambda_um, 2) - B3)
n_lambda = np.sqrt(1 + M1 + M2 + M3)

fig = plt.figure()
ax = fig.add_subplot()
ax.plot(lambda_um, n_lambda)
ax.set_xlabel(r'Wavelength $\lambda$ ($\mu$m)')
ax.set_ylabel(r'Refractive Index n')
ax.set_title('Sellmeier Equation')
ax.grid()

# Add minor grid lines
ax.grid(which='minor', linestyle=':')
ax.minorticks_on()

plt.show()
