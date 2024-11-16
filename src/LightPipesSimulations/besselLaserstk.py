import LightPipes
import matplotlib.pyplot as plt
import numpy as np

# Setup parameters
gridSize = 10*(LightPipes.mm)
gridDimension = 512
wavelength = 533*(LightPipes.nm)
phi = 180 * np.pi/180
Field = LightPipes.Begin(gridSize, wavelength, gridDimension)
Field = LightPipes.GaussBeam(Field, w0=1*LightPipes.mm)
Field = LightPipes.Axicon(Field, phi) # axicon with top angle phi, refractive index = 1.5, centered in grid
I = LightPipes.Intensity(Field, 2)
fig = plt.figure()
ax = plt.subplot()
ax.imshow(I, cmap='jet')
ax.set_title('Beam through circular aperture')
ax.set_xlabel('x [mm]')
ax.set_ylabel('y [mm]')
plt.show()
