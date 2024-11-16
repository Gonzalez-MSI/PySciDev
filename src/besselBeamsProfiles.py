import numpy as np
import matplotlib.pyplot as plt
import scipy
import scipy.special
import LightPipes

from pyrula import pyrulamap
    
# Bessel function order
q0 = 0
q1 = 1
q2 = 3  

# Beam waist
w0 = 10                      

# Beam profile
L = np.arange(-20, 20, 0.001)  

# Bessel function modulation
J0 = np.abs(scipy.special.jv(q0, L))
J1 = np.abs(scipy.special.jv(q1, L))
J2 = np.abs(scipy.special.jv(q2, L))

# Gaussian beam envelope                             
profile0 = np.exp(-(pow(L,2))/(pow(w0,2))) * J0       
profile1 = np.exp(-(pow(L,2))/(pow(w0,2))) * J1       
profile2 = np.exp(-(pow(L,2))/(pow(w0,2))) * J2      

def setPlot(ax, q, profile, plot_color):
    ax.plot(L/w0, profile, color=plot_color, label=rf"$q={q}$")
    ax.legend()
    ax.set_xlabel(r"$\frac{x}{w0}$")
    ax.set_ylabel(r"$|E(x)|$")
    ax.grid()
    ax.minorticks_on()
    ax.tick_params(
        axis='both', 
        which='both', 
        direction='in', 
        top=True,
        right=True,
        left=True,
        bottom=True,
        length=2.5,
        width=1.12
    )
 
# Bessel Beam 2D Profiles
fig1 = plt.figure(figsize=(10, 3))    
fig1.suptitle("Bessel-Gaussian Beam Profiles", fontsize=14, fontname="Times New Roman")
(ax1, ax2, ax3) = fig1.subplots(1, 3)
setPlot(ax1, q0, profile0, "blue")
setPlot(ax2, q1, profile1, "green")
setPlot(ax3, q2, profile2, "red")
plt.figure(1)  # Activate first figure
plt.tight_layout()
fig1.savefig('bessel_2d_profiles.pdf', format='pdf', bbox_inches='tight', dpi=300)

x = np.linspace(-20, 20, 1000)
y = x.reshape(-1, 1)
r = np.sqrt(x**2 + y**2)
J0 = np.abs(scipy.special.jv(q0, r))
J1 = np.abs(scipy.special.jv(q1, r))
J2 = np.abs(scipy.special.jv(q2, r))
beam0 = np.exp(-(r**2)/(w0**2)) * J0
beam1 = np.exp(-(r**2)/(w0**2)) * J1
beam2 = np.exp(-(r**2)/(w0**2)) * J2

# Bessel Beam 3D views
fig2 = plt.figure(figsize=(15, 4))  # Wider rather than taller
fig2.suptitle("3D Bessel-Gaussian Beam Profiles", fontsize=14, fontname="Times New Roman")

# Change to 1x3 layout
ax1 = fig2.add_subplot(131, projection='3d')
ax2 = fig2.add_subplot(132, projection='3d')
ax3 = fig2.add_subplot(133, projection='3d')

# Modified set3DPlot function with better aspect ratio
def set3DPlot(ax, x, y, beam, q, cmap):
    surf = ax.plot_surface(x/w0, y/w0, beam, cmap=cmap, edgecolor='black', linewidth=0.5)
    ax.set_title(rf"$q={q}$")
    ax.set_xlabel(r"$\frac{x}{w0}$")
    ax.set_ylabel(r"$\frac{y}{w0}$")
    ax.set_zlabel(r"$|E(x,y)|$")
    
    ax.set_box_aspect([1, 1, 0.7])  # Adjust height ratio
    ax.grid(True)
    ax.xaxis.pane.fill = False
    ax.yaxis.pane.fill = False
    ax.zaxis.pane.fill = False
    ax.view_init(elev=25, azim=45)
    return surf

surf1 = set3DPlot(ax1, x, y, beam0, q0, pyrulamap)
surf2 = set3DPlot(ax2, x, y, beam1, q1, pyrulamap)
surf3 = set3DPlot(ax3, x, y, beam2, q2, pyrulamap)

plt.tight_layout(rect=[0, 0, 1, 0.95])  # Adjust spacing for suptitle
fig2.savefig('bessel_3d_profiles.pdf', format='pdf', bbox_inches='tight', dpi=300)
plt.show()