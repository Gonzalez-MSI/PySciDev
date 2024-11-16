import LightPipes
import numpy as np
import matplotlib.pyplot as plt 

wavelength = 652*LightPipes.nm      # Wavelength
size = 10*LightPipes.mm             # Size of the grid
N = 500                             # Number of grid points
z = 50 * LightPipes.cm              # Propagation distance
R = 0.3 * LightPipes.mm             # Radius of the slit aperture
d = 1.2 * LightPipes.mm             # Separation between the slits

Field = LightPipes.Begin(size, wavelength, N)
F1 = LightPipes.CircAperture(R/2.0, -d/2.0, 0, Field)   # Left slit
F2 = LightPipes.CircAperture(R/2.0, d/2.0, 0, Field)    # Right slit
Field = LightPipes.BeamMix(F1, F2)                      # Combine the two beams passing through the slits        
Field = LightPipes.Fresnel(z, Field)                    # Propagate the field
I = LightPipes.Intensity(Field, 2)                      # Calculate the intensity

fig = plt.figure()
ax = plt.subplot()
ax.imshow(I, cmap='jet')
ax.set_title('Young\'s double slit')
ax.set_xlabel('x [mm]')
ax.set_ylabel('y [mm]')
plt.show()

