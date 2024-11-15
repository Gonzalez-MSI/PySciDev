import numpy as np
import matplotlib.pyplot as plt
import scipy
import scipy.special
    
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

# Bessel Beam 3D view
x = np.linspace(-20, 20, 1000)
y = x.reshape(-1, 1)
r = np.sqrt(x**2 + y**2)
J3D = np.abs(scipy.special.jv(q0, r))
beam = np.exp(-(r**2)/(w0**2)) * J3D
fig2 = plt.figure(2)  
ax = plt.axes(projection='3d')
ax.plot_surface(x/w0, y/w0, beam, cmap='viridis', edgecolor='black', linewidth=0.5)
ax.set_title("3D Bessel-Gaussian Beam")
ax.set_xlabel(r"$\frac{x}{w0}$")
ax.set_ylabel(r"$\frac{y}{w0}$")
plt.tight_layout()


plt.show()