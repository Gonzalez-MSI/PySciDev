import LightPipes
import numpy as np
import matplotlib.pyplot as plt

# Setup parameters
GridSize = 30*(LightPipes.mm)
GridDimension = 250  # Increased for better resolution
wavelength = 633*(LightPipes.nm)

# Create first field
Field1 = LightPipes.Begin(GridSize, wavelength, GridDimension)
Field1 = LightPipes.GaussBeam(Field1, w0=5*LightPipes.mm)

# Create second field with offset
Field2 = LightPipes.Begin(GridSize, wavelength, GridDimension)
Field2 = LightPipes.GaussBeam(Field2, w0=5*LightPipes.mm)
Field2 = LightPipes.Tilt(Field2, 0.5*LightPipes.mrad, 0) # Add tilt for interference

# Combine fields
Field_total = LightPipes.BeamMix(Field1, Field2)

# Get intensity
I = LightPipes.Intensity(Field_total)

# Plot interference pattern
plt.figure()
plt.imshow(I, cmap='jet', extent=[-GridSize/2, GridSize/2, -GridSize/2, GridSize/2])
plt.colorbar(label='Intensity')
plt.title('Interference Pattern')
plt.xlabel('Position X (mm)')
plt.ylabel('Position Y (mm)')
plt.show()