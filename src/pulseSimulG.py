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
    
fig = plt.figure(figsize=(11.5, 3.5))    
fig.suptitle("Bessel-Gaussian Beam Profiles", fontsize=14, fontname="Times New Roman")
(ax1, ax2, ax3)  = fig.subplots(1, 3)
setPlot(ax1, q0, profile0, "blue")
setPlot(ax2, q1, profile1, "green")
setPlot(ax3, q2, profile2, "red")
plt.tight_layout()
plt.savefig("BesselGaussianBeamProfiles.png", dpi=600)
plt.show()
