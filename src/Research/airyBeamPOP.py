"""
Self healing Airy beam. A disk is placed at some distance from the origin.
This obstacle disturbs the beam, but it heals itself.
"""
import LightPipes
import matplotlib.pyplot as plt
import matplotlib.animation as animation

wavelength = 2.3*LightPipes.um
size = 30*LightPipes.mm
N = 500
x0 = y0 =1*LightPipes.mm
a1 = a2 = 0.1/LightPipes.mm
w =1*LightPipes.mm
z = 0 *LightPipes.cm
dz = 2 *LightPipes.cm
fig, ax = plt.subplots(); ax.axis('off')
ims =[]

F0=LightPipes.Begin(size,wavelength,N)
F0=LightPipes.AiryBeam2D(F0,x0=x0, y0=y0, a1=a1, a2=a2)

for i in range(1000):
    if i == 20: # at z = 40 cm an obstacle is placed
        F0=LightPipes.CircScreen(F0,w)
    F=LightPipes.Fresnel(F0,z)
    I=LightPipes.Intensity(F)
    im = ax.imshow(I, animated = True, cmap='jet')
    s = r'$z = {:4.0f}$ cm'.format(z/LightPipes.cm)
    t = ax.annotate(s,(100,100), color = 'w') # add text
    ims.append([im,t])
    z += dz

ani = animation.ArtistAnimation(fig, ims, interval=5, blit=True,
                                repeat_delay=1000)
ani.save("AiryBeamPropagation.mp4")