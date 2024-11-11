"""                  
                GNU GENERAL PUBLIC LICENSE
                 Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
"""

"""
GUI application for analyzing interferograms using Fourier Transform and image processing.

This application provides an interactive interface allowing users to:
- View and analyze interferogram images:
  * Original image display
  * Fourier Transform visualization
  * Real-time threshold adjustment
- Control processing parameters:
  * Threshold level
  * Image filtering
  * FFT visualization
- Image analysis features:
  * Frequency domain analysis
  * Noise reduction
  * Colormap visualization
- Interactive controls:
  * Update processing
  * Real-time preview
  * Parameter validation

Dependencies:
    - tkinter: GUI framework
    - numpy: Numerical computations
    - opencv-python: Image processing
    - PIL: Image handling and display

Author: [Diego Gonzalez Ayala]
Date (D-M-Y): [11-11-2024]
Version: 1.0
"""

import cv2
import numpy as np
import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk

#------------------------------------------------------------------------------
# Main Application Class
#------------------------------------------------------------------------------
class InterferometryViewer:
    def __init__(self, root):
        self.root = root
        self.root.title("Interferometry Analysis")
        
        #------------------------------------------------------------------------------
        # Layout Setup
        #------------------------------------------------------------------------------
        # Main container
        self.main_container = ttk.Frame(root)
        self.main_container.pack(fill=tk.BOTH, expand=True)
        
        # Image frame on left
        self.image_frame = ttk.Frame(self.main_container)
        self.image_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        
        #------------------------------------------------------------------------------
        # Image Display Frames
        #------------------------------------------------------------------------------
        # Create labeled frames for images
        self.interferogram_frame = ttk.LabelFrame(self.image_frame, text="Interferogram")
        self.interferogram_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)

        self.fft_frame = ttk.LabelFrame(self.image_frame, text="Fourier Transform")
        self.fft_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)

        #------------------------------------------------------------------------------
        # Control Panel Setup
        #------------------------------------------------------------------------------
        # Control frame on right
        self.control_frame = ttk.LabelFrame(self.main_container, text="Controls")
        self.control_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=5, pady=5)
        
        # Threshold controls
        threshold_container = ttk.Frame(self.control_frame)
        threshold_container.pack(fill=tk.X, padx=5, pady=5)
        
        ttk.Label(threshold_container, text="Threshold:").pack(side=tk.LEFT)
        self.threshold_var = tk.StringVar(value="0.11")
        self.threshold_entry = ttk.Entry(
            threshold_container, 
            textvariable=self.threshold_var,
            width=10
        )
        self.threshold_entry.pack(side=tk.LEFT, padx=5)
        
        # Control buttons
        ttk.Button(
            threshold_container,
            text="Update",
            command=self.update_image
        ).pack(side=tk.LEFT, padx=5)
        
        ttk.Button(
            self.control_frame,
            text="Exit",
            command=self.root.destroy
        ).pack(side=tk.BOTTOM, pady=10)
        
        #------------------------------------------------------------------------------
        # Image Loading and Processing
        #------------------------------------------------------------------------------
        # Load initial image
        self.imgPath = "C:/Users/glzdi/Documents/MatlabScripts/Images/IFPGas.jpeg"
        self.img = cv2.imread(self.imgPath, cv2.IMREAD_COLOR)
        self.img_gray = cv2.cvtColor(self.img, cv2.COLOR_BGR2GRAY)
        self.img_gray = cv2.GaussianBlur(self.img_gray, (3,3), 0)
        
        # Setup image labels
        self.original_label = ttk.Label(self.interferogram_frame)
        self.original_label.pack(side=tk.TOP, padx=5, pady=5)

        self.dft_label = ttk.Label(self.fft_frame)
        self.dft_label.pack(side=tk.TOP, padx=5, pady=5)
        
        # Initial display update
        self.update_image()
        
    #------------------------------------------------------------------------------
    # Utility Methods
    #------------------------------------------------------------------------------
    def validate_threshold(self):
        """Validate and constrain threshold input value"""
        try:
            value = float(self.threshold_var.get())
            return max(0.01, min(1.0, value))
        except ValueError:
            self.threshold_var.set("0.11")
            return 0.11
            
    #------------------------------------------------------------------------------
    # Image Processing and Display Methods
    #------------------------------------------------------------------------------
    def update_image(self, *args):
        """Update both the original and FFT images"""
        threshold = self.validate_threshold()
        
        # Compute DFT
        img_dft = cv2.dft(np.float32(self.img_gray), flags=cv2.DFT_COMPLEX_OUTPUT)
        img_dft_shift = np.fft.fftshift(img_dft)
        
        # Compute magnitude spectrum
        dft_mag = cv2.magnitude(img_dft_shift[:,:,0], img_dft_shift[:,:,1])
        dft_mag = np.log(dft_mag + 1e-3)
        
        # Apply threshold
        threshold = np.max(dft_mag) * threshold
        dft_mag[dft_mag < threshold] = 0
        
        # Normalize and apply colormap
        dft_mag = cv2.normalize(dft_mag, None, 0, 255, cv2.NORM_MINMAX, cv2.CV_8UC1)
        dft_mag_color = cv2.applyColorMap(dft_mag, cv2.COLORMAP_JET)
        
        # Convert to PIL format
        dft_image = cv2.cvtColor(dft_mag_color, cv2.COLOR_BGR2RGB)
        dft_image = Image.fromarray(dft_image)
        dft_image.thumbnail((400, 400))
        dft_photo = ImageTk.PhotoImage(dft_image)
        self.dft_label.configure(image=dft_photo)
        self.dft_label.image = dft_photo
        
        # Display original image
        original_image = cv2.cvtColor(self.img, cv2.COLOR_BGR2RGB)
        original_image = Image.fromarray(original_image)
        original_image.thumbnail((400, 400))
        original_photo = ImageTk.PhotoImage(original_image)
        self.original_label.configure(image=original_photo)
        self.original_label.image = original_photo

#------------------------------------------------------------------------------
# Main Entry Point
#------------------------------------------------------------------------------
if __name__ == "__main__":
    root = tk.Tk()
    app = InterferometryViewer(root)
    root.mainloop()
