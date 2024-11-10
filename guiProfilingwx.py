"""                  
                GNU GENERAL PUBLIC LICENSE
                 Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
"""

"""
GUI application for plotting and manipulating sine waves using tkinter and matplotlib.
This application provides an interactive interface allowing users to:
- Plot sine waves with customizable frequency
- Adjust amplitude and time scale of the view
- Add Gaussian noise to the signal
- Update the plot dynamically
- Validate numerical inputs
Dependencies:
    - tkinter
    - numpy
    - matplotlib
Author: [Diego Gonzalez Ayala]
Date: [2024-02-26]
Version: 1.1
"""

import tkinter as tk
from tkinter import ttk
import numpy as np
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

def validate_number(value):
    if value == "":
        return True
    try:
        float(value)
        return True
    except ValueError:
        return False

def plot_sine():
    global canvas, current_ax
    
    # Get frequency from entry field
    f = float(freq_entry.get()) if freq_entry.get() else 1
    
    # Get scale values
    amp_scale = float(amp_scale_entry.get()) if amp_scale_entry.get() else 1
    time_scale = float(time_scale_entry.get()) if time_scale_entry.get() else 1
    
    # Get noise parameters
    noise_mean = float(noise_mean_entry.get()) if noise_mean_entry.get() else 0
    noise_std = float(noise_std_entry.get()) if noise_std_entry.get() else 0.0
    
    # Generate sine wave data
    start = 0.0
    stop = 10.0
    fs = 100*f
    t = np.arange(start, stop, 1/fs)
    signal = np.sin(2 * np.pi * f * t)
    
    # Add Gaussian noise
    noise = np.random.normal(noise_mean, noise_std, signal.shape)
    noisy_signal = signal + noise
    
    # Create plot
    fig = Figure(figsize=(6, 4))
    ax = fig.add_subplot(111)
    current_ax = ax
    
    ax.plot(t, noisy_signal, color='red', linewidth=1.15)
    ax.set_title(f'Sine Wave ({f} Hz) \u03C3={noise_std} \u03BC={noise_mean}') 
    ax.set_xlabel('Time (s)')
    ax.set_ylabel('Amplitude')
    ax.grid(True)
    ax.minorticks_on()
    ax.tick_params(axis='both', which='both', top=True, right=True, direction='in', width=1.15)
    
    # Set view limits based on scale settings
    ax.set_ylim(-amp_scale, amp_scale)
    ax.set_xlim(0, time_scale)
    
    # Update canvas
    if 'canvas' in globals() and canvas:
        canvas.get_tk_widget().destroy()
    canvas = FigureCanvasTkAgg(fig, master=plot_frame)
    canvas.draw()
    canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)

def update_view():
    if 'current_ax' in globals() and current_ax:
        amp_scale = float(amp_scale_entry.get()) if amp_scale_entry.get() else 1
        time_scale = float(time_scale_entry.get()) if time_scale_entry.get() else 1
        current_ax.set_ylim(-amp_scale, amp_scale)
        current_ax.set_xlim(0, time_scale)
        canvas.draw()

# Create main window and frames
root = tk.Tk()
root.title("Sine Wave Plotter")
root.geometry("1000x500")

# Create main container
main_container = tk.Frame(root)
main_container.pack(fill=tk.BOTH, expand=True)

# Top controls frame
top_frame = tk.Frame(main_container)
top_frame.pack(pady=5)

# Plot frame
plot_frame = tk.Frame(main_container)
plot_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

# Right controls frame
right_frame = tk.Frame(main_container)
right_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=10)

# Frequency controls
validate_cmd = root.register(validate_number)
freq_label = tk.Label(top_frame, text="Frequency (Hz):")
freq_label.pack(side=tk.LEFT, padx=5)
freq_entry = tk.Entry(top_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
freq_entry.insert(0, "1")
freq_entry.pack(side=tk.LEFT, padx=5)

# View scale controls
tk.Label(right_frame, text="View Controls", font=('Arial', 10, 'bold')).pack(pady=5)

tk.Label(right_frame, text="Amplitude Scale:").pack(pady=2)
amp_scale_entry = tk.Entry(right_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
amp_scale_entry.insert(0, "1")
amp_scale_entry.pack(pady=2)

tk.Label(right_frame, text="Time Scale (s):").pack(pady=2)
time_scale_entry = tk.Entry(right_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
time_scale_entry.insert(0, "10")
time_scale_entry.pack(pady=2)

# Update view button
update_button = tk.Button(right_frame, text="Update View", command=update_view)
update_button.pack(pady=5)

# Noise controls
tk.Label(right_frame, text="Noise Controls", font=('Arial', 10, 'bold')).pack(pady=5)

tk.Label(right_frame, text="Noise Mean (\u03BC):").pack(pady=2)
noise_mean_entry = tk.Entry(right_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
noise_mean_entry.insert(0, "0")
noise_mean_entry.pack(pady=2)

tk.Label(right_frame, text="Noise Std Dev (\u03C3):").pack(pady=2)
noise_std_entry = tk.Entry(right_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
noise_std_entry.insert(0, "0.0")
noise_std_entry.pack(pady=2)

# Plot and Exit buttons
plot_button = tk.Button(top_frame, text="Plot", command=plot_sine)
plot_button.pack(side=tk.LEFT, padx=5)

exit_button = tk.Button(top_frame, text="Exit", command=root.quit)
exit_button.pack(side=tk.LEFT, padx=5)

root.mainloop()