import LightPipes
import numpy as np
import matplotlib.pyplot as plt
from pyrula import pyrulamap

# Gaussian beam parameters
GridSize = 10*LightPipes.mm
GridDimension = 2000
wavelength = 632.8*LightPipes.nm
w0 = 10*LightPipes.mm
z = 100*LightPipes.mm

# Generate Bessel beam
Field = LightPipes.Begin(GridSize, wavelength, GridDimension)
Field = LightPipes.GaussBeam(Field, w0)
Field = LightPipes.Axicon(Field, phi=np.deg2rad(179.5), n1=1.5, x_shift=0, y_shift=0)
Field = LightPipes.Fresnel(Field, z)
I = LightPipes.Intensity(Field, 0)

N2 = int(GridDimension/2)
ZoomFactor = 10
NZ = N2/ZoomFactor

fig = plt.figure() 
ax = fig.add_subplot()
ax.imshow(I, cmap='jet')
ax.set_title('Gaussian Beam - Intensity') 
ax.set_xlabel('x [mm]')
ax.set_ylabel('y [mm]')
ax.axis([N2-NZ, N2+NZ, N2-NZ, N2+NZ])
plt.show()