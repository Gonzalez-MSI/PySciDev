import LightPipes
import numpy as np
import matplotlib.pyplot as plt

# Simulation parameters
wavelength = 1550*LightPipes.nm     # wavelength 
size = 100*LightPipes.um            # size of grid 
N = 500                             # number of grid points
z = 1000*LightPipes.cm              # propagation distance

# Initialize LightPipes
F = LightPipes.Begin(size, wavelength, N)

# Create Gaussian pulse
w0 = 20*LightPipes.um # beam waist
F = LightPipes.GaussBeam(F, w0)

# Propagate through fiber
F = LightPipes.Forvard(F,z)

# Get intensity distribution
I = LightPipes.Intensity(F,0)

# Plot results
plt.imshow(I, cmap='jet')
plt.colorbar(label='Intensity')
plt.title('Pulse Propagation in Optical Fiber')
plt.xlabel('x' )
plt.ylabel('y')
plt.show()