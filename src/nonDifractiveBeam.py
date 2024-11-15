import LightPipes
import matplotlib.pyplot as plt

wavelength = 1540.0*LightPipes.nm
size = 10*LightPipes.mm
N = 1024
phi = 179.7/180*3.1415;
n1 = 1.5
z = 1*LightPipes.um; 

F = LightPipes.Begin(size,wavelength,N);
F = LightPipes.GaussBeam(F, size/3.5)
F = LightPipes.Axicon(phi,n1,0,0,F)
F = LightPipes.Fresnel(F,z)
I = LightPipes.Intensity(F,0)

# Keep all previous code the same until plotting section
fig = plt.figure()
ax = fig.add_subplot()

# Create image with proper scaling
extent = [-size/2/LightPipes.mm, size/2/LightPipes.mm, -size/2/LightPipes.mm, size/2/LightPipes.mm]
im = ax.imshow(I, cmap='jet', extent=extent)

# Add colorbar
plt.colorbar(im, label='Intensity (a.u.)')

# Improved labels
ax.set_title(f"Non-Diffractive Beam\n(z = {z/LightPipes.cm:.3f} cm, λ = {wavelength/LightPipes.nm:.0f} nm)")
ax.set_xlabel("x [mm]")
ax.set_ylabel("y [mm]")

plt.tight_layout()
plt.show()
