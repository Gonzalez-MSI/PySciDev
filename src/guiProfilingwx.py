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
- Plot sine waves with custpomizable parameters:
  * Frequency (Hz)
  * Amplitude 
  * Phase (degrees)
  * Vertical offset
- Control view properties:
  * Amplitude scaling
  * Time window
- Add and control Gaussian noise:
  * Mean (μ)
  * Standard deviation (σ)
- Plot appearance:
  * Line color
  * Line width
- Update plot dynamically
- Real-time input validation

Dependencies:
    - tkinter: GUI framework
    - numpy: Numerical computations
    - matplotlib: Plotting library
    - FigureCanvasTkAgg: Matplotlib-tkinter integration

Author: [Diego Gonzalez Ayala]
Date: [2024-02-26]
Version: 1.4
"""

import tkinter as tk
from tkinter import ttk
import numpy as np
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

def validate_number(value):
    if value == "" or value == "-":  # Allow empty string and standalone minus sign
        return True
    try:
        float(value)
        return True
    except ValueError:
        return False

def plot_sine():
    global canvas, current_ax
    
    # Get wave parameters
    f = float(freq_entry.get()) if freq_entry.get() else 1
    amplitude = float(amp_entry.get()) if amp_entry.get() else 1
    phase = float(phase_entry.get()) if phase_entry.get() else 0
    phase = phase * (np.pi/180)  # Convert to radians
    offset = float(offset_entry.get()) if offset_entry.get() else 0
    
    # Get scale values
    amp_scale = float(amp_scale_entry.get()) if amp_scale_entry.get() else 1
    time_scale = float(time_scale_entry.get()) if time_scale_entry.get() else 1
    
    # Get noise parameters
    noise_mean = float(noise_mean_entry.get()) if noise_mean_entry.get() else 0
    noise_std = float(noise_std_entry.get()) if noise_std_entry.get() else 0.0

    # Get plot appearance parameters
    line_width = float(line_width_entry.get()) if line_width_entry.get() else 1.15
    
    # Generate sine wave data
    start = 0.0
    stop = 10.0
    fs = 100*f
    t = np.arange(start, stop, 1/fs)
    signal = amplitude * np.sin(2 * np.pi * f * t + phase) + offset
    
    # Add Gaussian noise
    noise = np.random.normal(noise_mean, noise_std, signal.shape)
    noisy_signal = signal + noise
    
    # Create plot
    fig = Figure(figsize=(6, 4))
    ax = fig.add_subplot(111)
    current_ax = ax
    
    ax.plot(t, noisy_signal, color=color_var.get(), linewidth=line_width)
    ax.set_title(f'Sine Wave: {f}Hz, A={amplitude}, φ={phase:.2f}rad, offset={offset}\nσ={noise_std:.2f} μ={noise_mean:.2f}')
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
    canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

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
root.geometry("1000x600")

# Create main container
main_container = tk.Frame(root)
main_container.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

# Top controls frame with wave parameters
top_frame = tk.Frame(main_container, relief=tk.GROOVE, borderwidth=2)
top_frame.pack(fill=tk.X, pady=5)

# Wave Parameters section
wave_params_frame = tk.Frame(top_frame)
wave_params_frame.pack(pady=5, padx=5)

tk.Label(wave_params_frame, text="Wave Parameters", font=('Arial', 10, 'bold')).pack(pady=5)

params_entry_frame = tk.Frame(wave_params_frame)
params_entry_frame.pack()

# Wave parameter controls
validate_cmd = root.register(validate_number)

# Frequency control
freq_label = tk.Label(params_entry_frame, text="Frequency (Hz):")
freq_label.pack(side=tk.LEFT, padx=5)
freq_entry = tk.Entry(params_entry_frame, width=8, validate='key', validatecommand=(validate_cmd, '%P'))
freq_entry.insert(0, "1")
freq_entry.pack(side=tk.LEFT, padx=5)

# Amplitude control
amp_label = tk.Label(params_entry_frame, text="Amplitude:")
amp_label.pack(side=tk.LEFT, padx=5)
amp_entry = tk.Entry(params_entry_frame, width=8, validate='key', validatecommand=(validate_cmd, '%P'))
amp_entry.insert(0, "1")
amp_entry.pack(side=tk.LEFT, padx=5)

# Phase control
phase_label = tk.Label(params_entry_frame, text="Phase (deg):")
phase_label.pack(side=tk.LEFT, padx=5)
phase_entry = tk.Entry(params_entry_frame, width=8, validate='key', validatecommand=(validate_cmd, '%P'))
phase_entry.insert(0, "0")
phase_entry.pack(side=tk.LEFT, padx=5)

# Offset control
offset_label = tk.Label(params_entry_frame, text="Offset:")
offset_label.pack(side=tk.LEFT, padx=5)
offset_entry = tk.Entry(params_entry_frame, width=8, validate='key', validatecommand=(validate_cmd, '%P'))
offset_entry.insert(0, "0")
offset_entry.pack(side=tk.LEFT, padx=5)

# Plot frame with border
plot_frame = tk.Frame(main_container, relief=tk.GROOVE, borderwidth=2)
plot_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)

# Right controls frame with border
right_frame = tk.Frame(main_container, relief=tk.GROOVE, borderwidth=2)
right_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=5, pady=5)

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

tk.Label(right_frame, text="Noise Mean (μ):").pack(pady=2)
noise_mean_entry = tk.Entry(right_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
noise_mean_entry.insert(0, "0")
noise_mean_entry.pack(pady=2)

tk.Label(right_frame, text="Noise Std Dev (σ):").pack(pady=2)
noise_std_entry = tk.Entry(right_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
noise_std_entry.insert(0, "0.0")
noise_std_entry.pack(pady=2)

# Plot appearance controls
tk.Label(right_frame, text="Plot Controls", font=('Arial', 10, 'bold')).pack(pady=5)

tk.Label(right_frame, text="Line Color:").pack(pady=2)
color_choices = ['red', 'blue', 'green', 'black', 'purple', 'orange']
color_var = tk.StringVar(value='red')
color_menu = ttk.Combobox(right_frame, textvariable=color_var, values=color_choices, width=7)
color_menu.pack(pady=2)

tk.Label(right_frame, text="Line Width:").pack(pady=2)
line_width_entry = tk.Entry(right_frame, width=10, validate='key', validatecommand=(validate_cmd, '%P'))
line_width_entry.insert(0, "1.15")
line_width_entry.pack(pady=2)

# Buttons frame
button_frame = tk.Frame(top_frame)
button_frame.pack(pady=5)

plot_button = tk.Button(button_frame, text="Plot", command=plot_sine)
plot_button.pack(side=tk.LEFT, padx=5)

exit_button = tk.Button(button_frame, text="Exit", command=root.quit)
exit_button.pack(side=tk.LEFT, padx=5)

root.mainloop()