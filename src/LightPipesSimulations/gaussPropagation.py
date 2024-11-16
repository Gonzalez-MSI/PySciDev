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

# Generate Bessel beam
Field = LightPipes.Begin(GridSize, wavelength, GridDimension)
Field = LightPipes.GaussBeam(Field, w0)
Field = LightPipes.propagators.Forvard(Field, z)
I = LightPipes.Intensity(Field, 0)

N2 = int(GridDimension/2)
ZoomFactor = 1
NZ = N2/ZoomFactor

fig = plt.figure() 
ax = fig.add_subplot()
ax.imshow(I, cmap='jet')
ax.set_title('Gaussian Beam') 
ax.set_xlabel('x [mm]')
ax.set_ylabel('y [mm]')
ax.axis([N2-NZ, N2+NZ, N2-NZ, N2+NZ])

x = np.linspace(-GridSize/2, GridSize/2, GridDimension)
I_np = np.array(I)
fig2 = plt.figure()
ax2 = fig2.add_subplot()
ax2.plot(x, I_np[N2,:], 'r', label='Intensity')
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

plt.show()