import LightPipes
import numpy as np
import matplotlib.pyplot as plt

# Setup parameters
waveLength = 632.8*LightPipes.nm
w0 = 1*LightPipes.mm
Power = 100
z = 100000*LightPipes.m

# Calculate beam parameters
zR = np.pi * w0**2 / waveLength     # Rayleigh range
theta = waveLength/(np.pi * w0)     # Divergence angle
w_z = w0 * np.sqrt(1 + (z/zR)**2)   # Beam width at distance z

# Calculate required GridSize
margin_factor = 4                   # Safety margin to avoid edge effects
GridSize = margin_factor * w_z
GridDimension = 3000
N2 = int(GridDimension/2)
ZoomFactor = 30
NZ = N2/ZoomFactor

Field = LightPipes.Begin(GridSize, waveLength, GridDimension)
Field = LightPipes.GaussBeam(Field, w0)
Field = LightPipes.Axicon(Field, phi=np.deg2rad(179.5), n1=1.5, x_shift=0, y_shift=0)
Field = LightPipes.Fresnel(Field, z)
I = LightPipes.Intensity(Field, 0)
I = Power * np.array(I)/np.max(I)  # Normalize and scale to desired power

fig = plt.figure(figsize=(9, 3.5))
(ax1, ax2) = fig.subplots(1,2)
ax1.imshow(I, cmap='jet')
ax1.set_title('Gaussian Beam')
ax1.set_xlabel('x [mm]')
ax1.set_ylabel('y [mm]')
ax1.axis([N2-NZ, N2+NZ, N2-NZ, N2+NZ])

x = np.linspace(-GridSize/2, GridSize/2, GridDimension)
I = np.array(I)
ax2.plot(x, I[int(GridDimension/2), :], 'r', label='\u03BB = 632.8nm')
ax2.legend()
ax2.set_title('Bessel Beam')
ax2.set_xlabel('x [mm]')
ax2.set_ylabel('Intensity')
ax2.grid()
plt.tight_layout()
plt.show()


