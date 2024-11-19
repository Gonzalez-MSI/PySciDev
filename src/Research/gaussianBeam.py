import LightPipes.units
import numpy as np
import matplotlib.pyplot as plt

r = np.arange(-0.1, 0.1, 0.001)
wavelength = 632.8*LightPipes.units.nm
L = 1000
Wo = 1.5e-2
Fo = 100
k = 2*np.pi/wavelength
theta0 = 1 + L/Fo
lambda0 = 2*L / (k*Wo**2)

Ao = 1/(theta0**2 + lambda0**2) * np.exp(-r**2/Wo**2)

fig = plt.figure()
ax = fig.add_subplot()
ax.plot(r, Ao, color='red', label=f'\u03BB = {wavelength} m')
ax.axvline(x=-Wo, color='blue', linestyle='-', linewidth=1.2, label='-Wo')
ax.axvline(x=Wo, color='purple', linestyle='-', linewidth=1.2, label='Wo')
ax.legend(
    fancybox=True,  # Rounded corners
    shadow=True,    # Add shadow
    framealpha=0.9, # Slight transparency
    loc='upper right',
    bbox_to_anchor=(0.98, 0.98),
    edgecolor='gray'
)
ax.set_title('Gaussian beam')
ax.set_xlabel('r [m]')
ax.set_ylabel('Amplitude')
ax.grid()
fig.savefig('gaussian_beam.jpg', format='jpg', dpi=300) 
plt.show()