import numpy as np
import findiff as fd
import matplotlib.pyplot as plt

from numpy import pi as PI
"""
Beta2(w) = (1/c) * (2*dn/dw  + w*d^2n/dw^2) 

Beta2(lambda) = 
"""

# Light speed in vacuum
c = 3e8

# Selmeier coefficients for fused silica
A1 = 0.6961663; A2 = 0.4079426; A3 = 0.8974794
B1 = 0.0684043**2; B2 = 0.1162414**2; B3 = 9.896161**2

def sellmeier(wavelength, A1, A2, A3, B1, B2, B3):
    """
    Calculate refractive index using Sellmeier equation for fused silica.
    
    Args:
        wavelength (float or array): Wavelength in micrometers
        
    Returns:
        float or array: Refractive index (dimensionless)
    """
    lambda2 = wavelength**2
    
    M1 = A1 * lambda2 / (lambda2 - B1)
    M2 = A2 * lambda2 / (lambda2 - B2)
    M3 = A3 * lambda2 / (lambda2 - B3)
    
    n = np.sqrt(1 + M1 + M2 + M3)
    return n

# Wavelength range in microns
lambda_um = np.linspace(1, 1.6) # wavelength range in microns

dn_dw = fd.FinDiff(0, lambda_um, 1)(sellmeier(lambda_um, A1, A2, A3, B1, B2, B3))
d2n_dw2 = fd.FinDiff(0, lambda_um, 2)(sellmeier(lambda_um, A1, A2, A3, B1, B2, B3))
Beta2 = (lambda_um**3/(2*PI * c**2))*(2*dn_dw + lambda_um*d2n_dw2)

fig = plt.figure()
ax = fig.add_subplot()
ax.plot(lambda_um, Beta2)
ax.set_xlabel(r'Wavelength $\lambda$ ($\mu$m)')
ax.set_ylabel(r'$\beta_2 (\frac{s^2}{/m})$')
ax.set_title('Group Velocity Dispersion Parameter')
ax.grid()

plt.show()


