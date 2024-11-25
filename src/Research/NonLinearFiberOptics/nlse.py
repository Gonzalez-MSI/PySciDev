import numpy as np
import scipy.special
import matplotlib.pyplot as plt

"""
SSFM code for solving the normalized NLS equation
Adapted to python from the 6th edition of the book
"Nonlinear Fiber Optics"
by Govind Agrawal

l_D: dispersion length

GVD (group velocity dispersion):
the frequency dependence of the group velocity in a
medium, or (quantitatively) the derivative of the 
inverse group velocity with respect to angular frequency
--------------------------------------------------------
"""

def sech(x):
    return 2/(np.exp(x) + np.exp(-x))
    
fiblen = 100    # fiber length in units of L_D
beta2 = -1    # sign of GVD parameter beta_2
N = 1         # soliton order 

# --- Set simulation parameters --- #
nt = 2048     # number of spectral points (FFT points)
Tmax = 128     # FFT window size
step_num = round(20*fiblen*np.power(N,2)) # number of z steps
delta_z = fiblen/step_num   # step size in z
delta_tau = (2*Tmax)/nt     # step size in tau

t_ns = np.arange(-nt/2, nt/2-1)
tau = delta_tau*t_ns                       # time array
omega = np.fft.fftshift(t_ns)*(np.pi/Tmax) # omega array
# Bessel function order
q0 = 5
# Beam waist
w0 = 10                      
# Bessel function modulation
J0 = np.abs(scipy.special.jv(q0, tau))  
uu = np.exp(-(pow(tau,2))/(pow(w0,2))) * J0  # initial pulse shape

temp = np.fft.fftshift(np.fft.ifft(uu)) # Fouerier transform
spectrum = np.power(np.abs(temp), 2)    # input spectrum
spectrum = spectrum/max(spectrum)       # normalize 
freq = np.fft.fftshift(omega)/(2*np.pi) # freq. array

# --- Plot input pulse shape and spectrum --- #

inout_pulsefig = plt.figure(figsize=(10, 8))
((ax1, ax2), (ax3, ax4)) = inout_pulsefig.subplots(2,2)
ax1.plot(tau, np.abs(uu)**2, label=r'Bessel beam (in)', linewidth=0.9)
ax1.set_xlabel(r'Normalized Time')
ax1.set_ylabel(r'Normalized Power')
ax1.legend(loc='upper right')
ax1.set_title('Input Pulse Shape')
ax1.grid()
ax1.minorticks_on()
ax1.tick_params(axis='both', which='both', direction='in', top=True, right=True, left=True, bottom=True, length=6, width=1)

ax2.plot(freq, spectrum, color=[0.89, 0, 0.89])
ax2.set_title('Input Spectrum')
ax2.set_xlabel(r'Normalized Frequency')
ax2.set_ylabel(r'Spectral Power')
ax2.set_xlim(-0.5, 0.5)
ax2.set_ylim(0, np.max(spectrum))
ax2.grid()
ax2.minorticks_on()
ax2.tick_params(axis='both', which='both', direction='in', top=True, right=True, left=True, bottom=True, length=6, width=1)

# --- Store disspersive phase shifts --- #
dispersion = np.exp(0.5j*beta2*np.power(omega,2)*delta_z) #phase factor
hhz = 1j*np.power(N,2)*delta_z # nonlinear phase factor
 
# scheme: 1/2N-> D-> 1/2N; first half step nonlinear
temp = uu*np.exp(np.power(np.abs(uu),2) * (-hhz/2))

for n in range(1, step_num):
    f_temp = np.fft.ifft(temp) * dispersion
    uu = np.fft.fft(f_temp)
    temp = uu * np.exp(np.power(np.abs(uu),2) * (-hhz/2))

temp = np.fft.fftshift(np.fft.ifft(uu)) # Fourier transform
spectrum = np.power(np.abs(temp), 2)       # output spectrum
spectrum = spectrum/max(spectrum)                # normalize

ax3.plot(tau, np.abs(uu)**2, label=r'Bessel beam (out)', color='red', linewidth=0.9)
ax3.set_xlabel(r'Normalized Time')
ax3.set_ylabel(r'Normalized Power')
ax3.set_title('Output Pulse Shape')
ax3.legend(loc='upper right')
ax3.grid()
ax3.minorticks_on()
ax3.tick_params(axis='both', which='both', direction='in', top=True, right=True, left=True, bottom=True, length=6, width=1)

ax4.plot(freq, spectrum, color=[0.89, 0, 0.89])
ax4.set_title('Output Spectrum')
ax4.set_xlabel(r'Normalized Frequency')
ax4.set_ylabel(r'Spectral Power')
ax4.set_xlim(-0.5, 0.5)
ax4.set_ylim(0, np.max(spectrum))
ax4.grid()
ax4.minorticks_on()
ax4.tick_params(axis='both', which='both', direction='in', top=True, right=True, left=True, bottom=True, length=6, width=1)
plt.tight_layout(pad=2.0)
plt.show()