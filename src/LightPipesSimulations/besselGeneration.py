import LightPipes
import numpy as np
import matplotlib.pyplot as plt
from pyrula import pyrulamap

# Gaussian beam parameters
GridSize = 10*LightPipes.mm
GridDimension = 2000
wavelength = 632.8*LightPipes.nm
w0 = 5*LightPipes.mm
z = 250*LightPipes.cm

# Generate Gaussian beam
Field = LightPipes.Begin(GridSize, wavelength, GridDimension)
Field = LightPipes.GaussBeam(Field, w0)
FGB = LightPipes.Forvard(Field, z)
IGB = LightPipes.Intensity(FGB, 0)

# Bessel beam generation
Field = LightPipes.Axicon(Field, phi=np.deg2rad(179.5), n1=1.5, x_shift=0, y_shift=0)
Field = LightPipes.Fresnel(Field, z)
I = LightPipes.Intensity(Field, 0)

N2 = int(GridDimension/2)
ZoomFactor = 1
NZ = N2/ZoomFactor

# Create figure with two subplots side by side
fig, (ax1, ax2) = plt.subplots(1, 2)

# Bessel-Gaussian Beam
im1 = ax1.imshow(I, cmap='jet')
ax1.set_title('Bessel-Gaussian Beam')
ax1.set_xlabel('x [mm]')
ax1.set_ylabel('y [mm]')
ax1.axis([N2-NZ, N2+NZ, N2-NZ, N2+NZ])
# Gaussian Beam
im2 = ax2.imshow(IGB, cmap='jet')
ax2.set_title('Gaussian Beam')
ax2.set_xlabel('x [mm]')
ax2.set_ylabel('y [mm]')
ax2.axis([N2-NZ, N2+NZ, N2-NZ, N2+NZ])
plt.tight_layout()


x = np.linspace(-GridSize/2, GridSize/2, GridDimension)
I_np = np.array(I) 
IGB_np = np.array(IGB)

fig2 = plt.figure(figsize=(9, 3.5))
(ax1, ax2) = fig2.subplots(1,2)
ax1.plot(x, I_np[N2,:], 'r', label='Intensity')
ax1.legend()
ax1.set_title('Bessel-Gaussian Beam - Intensity')
ax1.set_xlabel('x [mm]')
ax1.set_ylabel('Intensity')
ax1.grid()
ax1.minorticks_on()
ax1.tick_params(
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

ax2.plot(x, IGB_np[N2,:], 'r', label='Intensity')
ax2.legend()
ax2.set_title('Gaussian Beam - Intensity')
ax2.set_xlabel('x [mm]')
ax2.set_ylabel('Intensity')
ax2.grid()
ax2.minorticks_on()
ax2.tick_params(
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
plt.tight_layout()

plt.show()