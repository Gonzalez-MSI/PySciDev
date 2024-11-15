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
z_start =0.001*LightPipes.cm; 
z_end = 150*LightPipes.cm;
steps =11;
delta_z = (z_end-z_start)/steps
z = z_start

F = LightPipes.Begin(size,wavelength,N);
F = LightPipes.GaussBeam(F, size/3.5)
F = LightPipes.Axicon(phi,n1,0,0,F)

for i in range(1,steps): 
    F = LightPipes.Fresnel(delta_z,F);
    I = LightPipes.Intensity(0,F);
    plt.subplot(2,5,i)
    s ='z= %3.1f m' % (z/LightPipes.m)
    plt.title(s)
    plt.imshow(I,cmap='jet');plt.axis('off')
    plt.axis([N2-NZ, N2+NZ, N2-NZ, N2+NZ])
    z=z+delta_z
plt.show()
