import numpy as np
import matplotlib.pyplot as plt

# Function to generate a Gaussian spectrum
def gaussian_spectrum(wavelengths, peak_wavelength, width, peak_intensity=1):
    """
    Generate a Gaussian spectrum.

    Parameters:
    - wavelengths (array): Array of wavelengths.
    - peak_wavelength (float): Wavelength of the peak of the Gaussian.
    - width (float): Width (standard deviation) of the Gaussian in nm.
    - peak_intensity (float): Maximum intensity of the spectrum.
    
    Returns:
    - intensities (array): The intensities of the spectrum at each wavelength.
    """
    # Gaussian formula: I(w) = I0 * exp(-(wavelength - peak)^2 / (2 * width^2))
    intensities = peak_intensity * np.exp(-(wavelengths - peak_wavelength)**2 / (2 * width**2))
    return intensities

# Function to generate a spectrum with multiple peaks
def generate_multiple_peaks(wavelengths, peaks, widths, intensities):
    """
    Generate a spectrum with multiple Gaussian peaks.
    
    Parameters:
    - wavelengths (array): Array of wavelengths.
    - peaks (list): List of peak wavelengths for each Gaussian.
    - widths (list): List of widths (standard deviations) for each Gaussian.
    - intensities (list): List of intensities for each Gaussian peak.
    
    Returns:
    - total_intensity (array): The combined intensity from all peaks.
    """
    total_intensity = np.zeros_like(wavelengths)
    
    for peak, width, intensity in zip(peaks, widths, intensities):
        total_intensity += gaussian_spectrum(wavelengths, peak, width, intensity)
        
    return total_intensity

# Adding random noise to the spectrum
def add_noise(intensities, noise_level=0.05):
    """
    Add Gaussian noise to the spectrum to simulate real-world fluctuations.
    
    Parameters:
    - intensities (array): The original intensity values.
    - noise_level (float): The standard deviation of the noise to add.
    
    Returns:
    - noisy_intensities (array): Intensities with added noise.
    """
    noise = np.random.normal(0, noise_level, size=intensities.shape)
    noisy_intensities = intensities + noise
    return np.clip(noisy_intensities, 0, None)  # Ensure no negative intensities

# Define parameters for the optical spectrum
min_wavelength = 400  # Minimum wavelength in nm
max_wavelength = 800  # Maximum wavelength in nm
num_points = 1000     # Number of points in the spectrum

# Define the parameters for the multiple peaks
peaks = [450, 520, 650]  # Wavelengths of the peaks (e.g., blue, green, red)
widths = [15, 30, 20]    # Widths of the peaks in nm
intensities = [1, 0.8, 0.6]  # Intensities for each peak

# Generate wavelengths and corresponding intensities
wavelengths = np.linspace(min_wavelength, max_wavelength, num_points)
base_intensities = generate_multiple_peaks(wavelengths, peaks, widths, intensities)

# Add noise to the spectrum
noisy_intensities = add_noise(base_intensities, noise_level=0.1)

# Plot the spectrum with a black background and white grid/ticks
plt.style.use('dark_background')  # Apply dark background style
plt.figure()
plt.plot(wavelengths, base_intensities, label='Base Spectrum (No Noise)', color='y', linestyle='--', alpha=0.7)
plt.plot(wavelengths, noisy_intensities, label='Noisy Spectrum', color='y')
plt.title('Optical Spectrum Analyzer', fontsize=16, color='white')
plt.grid(True, color='white', linestyle='-', linewidth=0.5)  # White grid
plt.minorticks_on()
plt.tick_params(colors='white', which='both', axis='both', direction='in', length=6, width=1, bottom=True, top=True, left=True, right=True)
plt.grid(True, color='white', linestyle='-', linewidth=0.5)  # White grid
plt.savefig('noisy_spectrum.png', format='png', dpi=600)
plt.show()
