import LightPipes
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Simulation parameters
wavelength = 2.3 * LightPipes.um  # Wavelength of the beam
size = 30 * LightPipes.mm  # Size of the simulation grid
N = 500  # Number of grid points
z = 0 * LightPipes.cm  # Initial propagation distance
dz = 2 * LightPipes.cm  # Step size for propagation

# Set up the figure for animation
fig, ax = plt.subplots()
ax.axis('off')  # Hide axis
ims = []  # List to hold animation frames

# Initial Gaussian beam parameters
w0 = 1*LightPipes.mm  # Beam waist

# Create initial Gaussian beam
F0 = LightPipes.Begin(size, wavelength, N)
F0 = LightPipes.GaussBeam(F0, w0)

# Propagate the Gaussian beam and visualize its broadening
for i in range(1000):
    # Propagate the beam
    F = LightPipes.Fresnel(F0, z)
    
    # Compute intensity at the current position
    I = LightPipes.Intensity(F)
    
    # Add the intensity image and text annotation to the animation
    im = ax.imshow(I, animated=True, cmap='jet')
    s = r'$z = {:4.0f}$ cm'.format(z / LightPipes.cm)
    t = ax.annotate(s, (100, 100), color='w')  # Annotate with propagation distance
    ims.append([im, t])
    
    # Increase the propagation distance for the next step
    z += dz

# Create and save the animation
ani = animation.ArtistAnimation(fig, ims, interval=5, blit=True, repeat_delay=1000)
ani.save("GaussianBeamPropagation.mp4")
