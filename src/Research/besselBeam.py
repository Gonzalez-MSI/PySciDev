"""
Self healing Bessel beam. A disk is placed at some distance from the origin.
This obstacle disturbs the beam, but it heals itself.
"""
import LightPipes
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

wavelength = 2.3*LightPipes.um
size = 30*LightPipes.mm
N = 500
x0=y0=1*LightPipes.mm
a1=a2=0.1/LightPipes.mm
w = size/3.5
z = 0 *LightPipes.cm
dz = 2 *LightPipes.cm
alpha = 1.0
phi = (180 - 2*alpha) * np.pi/180
n1 = 1.5
fig, ax = plt.subplots(); ax.axis('off')
ims = []

F0=LightPipes.Begin(size,wavelength,N)
F0=LightPipes.GaussBeam(F0, w)
F0=LightPipes.Axicon(F0, phi, n1, 0, 0)

for i in range(1000):
    if i == 20: # at z = 40 cm an obstacle is placed
        F0 =LightPipes.CircScreen(F0,w)
    F = LightPipes.Fresnel(F0,z)
    I = LightPipes.Intensity(F)
    im = ax.imshow(I, animated = True, cmap='jet')
    s = r'$z = {:4.0f}$ cm'.format(z/LightPipes.cm)
    t = ax.annotate(s,(100,100), color = 'w') # add text
    ims.append([im,t])
    z += dz

ani = animation.ArtistAnimation(fig, ims, interval=5, blit=True,
                                repeat_delay=1000)
ani.save("BesselBeamPropagation_a01.mp4")
plt.show()