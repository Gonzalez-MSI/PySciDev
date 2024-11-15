import LightPipes
import matplotlib.pyplot as plt

wavelength = 1000.0*LightPipes.nm
size = 10*LightPipes.mm
N = 1000

N2 = int(N/2)
ZoomFactor = 10
NZ = N2/ZoomFactor

phi = 179.7/180*3.1415;
n1=1.5
z =0.001*LightPipes.cm; 

F = LightPipes.Begin(size,wavelength,N);
F = LightPipes.GaussBeam(F, size/3.5)
F = LightPipes.Axicon(phi,n1,0,0,F)
F = LightPipes.Fresnel(F,z)
I = LightPipes.Intensity(F,0)

fig = plt.figure()
ax = fig.add_subplot()
ax.imshow(I, cmap='jet')
ax.set_title("Non-Difractive Beam")
ax.set_xlabel(r"$x [mm]$")
ax.set_ylabel(r"$y [mm]$")
plt.show()
