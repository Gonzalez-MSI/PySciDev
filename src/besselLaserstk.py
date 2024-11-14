import LightPipes
import numpy as np
import matplotlib.pyplot as plt

# Setup parameters
gridSize = 10*(LightPipes.mm)
gridDimension = 128
wavelength = 533*(LightPipes.nm)
R = 0.1*(LightPipes.mm)
x_shift = 0*(LightPipes.mm)
y_shift = 0*(LightPipes.mm)

Field = LightPipes.Begin(gridSize, wavelength, gridDimension)
Field = LightPipes.CircAperture(R,x_shift,y_shift,Field)
I = LightPipes.Intensity(Field, 2)
fig = plt.figure()
ax = plt.subplot()
ax.imshow(I, cmap='rainbow')
ax.set_title('Young\'s double slit')
ax.set_xlabel('x [mm]')
ax.set_ylabel('y [mm]')
plt.show()
