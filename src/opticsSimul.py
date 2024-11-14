"""
Optical Interference Pattern Simulation
This script simulates interference between two Gaussian laser beams using LightPipes library.
"""

# Function Arguments Documentation:

# LightPipes.Begin(GridSize, wavelength, GridDimension)
# - GridSize: Physical size of simulation window (30mm)
# - wavelength: Laser wavelength (633nm - red light)
# - GridDimension: Number of pixels (250x250 grid)

# LightPipes.GaussBeam(Field, w0)
# - Field: Input field from Begin()
# - w0: Beam waist radius (8mm) - radius where intensity falls to 1/e²

# LightPipes.Tilt(Field, angle, direction)
# - Field: Input field
# - angle: Tilt angle (0.5 milliradians)
# - direction: 0 for x-axis tilt, π/2 for y-axis tilt

# LightPipes.BeamMix(Field1, Field2)
# - Field1, Field2: Two fields to be coherently combined
# Returns: Complex sum of fields

# LightPipes.Intensity(Field)
# - Field: Input field
# Returns: 2D array of intensity values

# plt.imshow(data, cmap, extent)
# - data: 2D intensity array
# - cmap: Color map ('jet' = blue-to-red)
# - extent: Physical dimensions [-15mm to +15mm]

"""
Units used:
- LightPipes.mm: millimeters
- LightPipes.nm: nanometers
- LightPipes.mrad: milliradians

The simulation creates:
1. Two identical Gaussian beams (8mm waist)
2. Adds angular tilt to second beam (0.5mrad)
3. Combines beams to create interference
4. Plots resulting intensity pattern
"""

import LightPipes
import numpy as np
import matplotlib.pyplot as plt

# Setup parameters
GridSize = 30*(LightPipes.mm)
GridDimension = 250  # Increased for better resolution
wavelength = 633*(LightPipes.nm)

# Create first field
Field1 = LightPipes.Begin(GridSize, wavelength, GridDimension)
Field1 = LightPipes.GaussBeam(Field1, w0=8*LightPipes.mm)

# Create second field with offset
Field2 = LightPipes.Begin(GridSize, wavelength, GridDimension)
Field2 = LightPipes.GaussBeam(Field2, w0=8*LightPipes.mm)
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