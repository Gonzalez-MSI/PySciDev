"""                  
                GNU GENERAL PUBLIC LICENSE
                 Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
"""

"""
GUI application for analyzing intensity profiles along lines in images.

This application provides an interactive interface allowing users to:
- Load and display grayscale/color images
- Extract intensity profiles by:
  * Drawing lines with mouse
  * Entering coordinates manually
- Display features:
  * Automatic image scaling
  * Real-time line preview
  * Interactive plot updates
- Profile analysis:
  * Intensity values along line
  * Position tracking
  * Pixel coordinates
- Image information:
  * Dimensions display
  * Scale factor tracking
  * Coordinate mapping

Dependencies:
    - tkinter: GUI framework
    - numpy: Numerical computations
    - matplotlib: Plotting library
    - opencv-python (cv2): Image processing
    - FigureCanvasTkAgg: Matplotlib-tkinter integration

Author: [Diego Gonzalez Ayala]
Date (D-M-Y): [10-11-2024]
Version: 1.4
"""

import numpy as np
import cv2
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import tkinter as tk
from tkinter import filedialog

def get_line_profile(image, start_point, end_point):
    # Create coordinates for points along the line
    num_points = int(np.hypot(end_point[0] - start_point[0], 
                             end_point[1] - start_point[1]))
    x = np.linspace(start_point[0], end_point[0], num_points)
    y = np.linspace(start_point[1], end_point[1], num_points)
    
    # Extract intensity values along the line
    # Convert coordinates to integer indices
    xi = x.astype(np.int32)
    yi = y.astype(np.int32)
    
    # Get intensity profile
    profile = image[yi, xi]
    
    return profile, num_points

class IntensityProfiler:
    def __init__(self, root):
        self.root = root
        self.root.title("Intensity Profile Analyzer")
        
        # Initialize variables
        self.image = None
        self.start_point = None
        self.end_point = None
        
        # Create UI elements
        self.setup_ui()
        
    def setup_ui(self):
        # Main container frame
        self.main_container = tk.Frame(self.root)
        self.main_container.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Configure grid weights
        self.main_container.grid_columnconfigure(0, weight=1)  # Image side
        self.main_container.grid_columnconfigure(1, weight=1)  # Plot side
        
        # Create left frame for image
        self.left_frame = tk.Frame(self.main_container, relief=tk.GROOVE, borderwidth=2)
        self.left_frame.grid(row=0, column=0, sticky="nsew", padx=5, pady=5)
        
        # Create right frame for plot
        self.right_frame = tk.Frame(self.main_container, relief=tk.GROOVE, borderwidth=2)
        self.right_frame.grid(row=0, column=1, sticky="nsew", padx=5, pady=5)
        
        # Control panel in left frame
        self.control_frame = tk.Frame(self.left_frame)
        self.control_frame.pack(fill=tk.X)
        
        # Button frame
        self.button_frame = tk.Frame(self.control_frame)
        self.button_frame.pack(fill=tk.X, pady=5)
        
        # Buttons
        self.load_btn = tk.Button(self.button_frame, text="Load Image", command=self.load_image)
        self.load_btn.pack(side=tk.LEFT, padx=5)
        
        self.plot_btn = tk.Button(self.button_frame, text="Plot Profile", command=self.plot_from_coordinates)
        self.plot_btn.pack(side=tk.LEFT, padx=5)
        
        self.exit_btn = tk.Button(self.button_frame, text="Exit", command=self.exit_program)
        self.exit_btn.pack(side=tk.LEFT, padx=5)
        
        # Coordinate entry frame
        self.coord_frame = tk.Frame(self.control_frame)
        self.coord_frame.pack(fill=tk.X, pady=5)
        
        # Start point entries
        tk.Label(self.coord_frame, text="Start:").pack(side=tk.LEFT, padx=2)
        tk.Label(self.coord_frame, text="X1:").pack(side=tk.LEFT, padx=2)
        self.x1_entry = tk.Entry(self.coord_frame, width=5)
        self.x1_entry.pack(side=tk.LEFT, padx=2)
        
        tk.Label(self.coord_frame, text="Y1:").pack(side=tk.LEFT, padx=2)
        self.y1_entry = tk.Entry(self.coord_frame, width=5)
        self.y1_entry.pack(side=tk.LEFT, padx=2)
        
        # End point entries  
        tk.Label(self.coord_frame, text="End:").pack(side=tk.LEFT, padx=2)
        tk.Label(self.coord_frame, text="X2:").pack(side=tk.LEFT, padx=2)
        self.x2_entry = tk.Entry(self.coord_frame, width=5)
        self.x2_entry.pack(side=tk.LEFT, padx=2)
        
        tk.Label(self.coord_frame, text="Y2:").pack(side=tk.LEFT, padx=2)
        self.y2_entry = tk.Entry(self.coord_frame, width=5)
        self.y2_entry.pack(side=tk.LEFT, padx=2)
        
        # Canvas for image
        self.canvas = tk.Canvas(self.left_frame, width=500, height=500)
        self.canvas.pack(fill=tk.BOTH, expand=True, pady=5)
        
        # Dimensions label
        self.dim_label = tk.Label(self.left_frame, text="Image dimensions: None")
        self.dim_label.pack(pady=2)
        
        # Plot frame
        self.fig, self.ax = plt.subplots(figsize=(8, 6))
        self.ax.set_title("Intensity Profile")
        self.ax.set_xlabel("Position along line")
        self.ax.set_ylabel("Intensity")
        self.ax.minorticks_on()
        self.ax.tick_params(axis='both', which='both', top=True, right=True, direction='in', width=1.15)
        self.ax.grid(True)
        self.canvas_widget = FigureCanvasTkAgg(self.fig, self.right_frame)
        self.canvas_widget.get_tk_widget().pack(fill=tk.BOTH, expand=True)
        
    def load_image(self):
        file_path = filedialog.askopenfilename()
        if file_path:
            self.image = cv2.imread(file_path, cv2.IMREAD_GRAYSCALE)
            self.image_color = cv2.imread(file_path, cv2.IMREAD_COLOR)
            
            # Update dimensions label
            height, width = self.image.shape
            self.dim_label.config(text=f"Image dimensions: {width}x{height} pixels")
            
            self.display_image()
            
    def display_image(self):
        if self.image is not None:
            # Get canvas dimensions
            canvas_width = self.canvas.winfo_width()
            canvas_height = self.canvas.winfo_height()
            
            # Calculate scaling factor
            img_height, img_width = self.image.shape
            scale_width = canvas_width / img_width
            scale_height = canvas_height / img_height
            scale = min(scale_width, scale_height)
            
            # Calculate new dimensions
            new_width = int(img_width * scale)
            new_height = int(img_height * scale)
            
            # Resize image
            resized_image = cv2.resize(self.image, (new_width, new_height))
            resized_image_color = cv2.resize(self.image_color, (new_width, new_height))

            # Store scaling info for profile calculation
            self.scale_factor = scale
            self.image_offset = (
                (canvas_width - new_width) // 2,
                (canvas_height - new_height) // 2
            )
            
            # Convert and display image
            self.photo = tk.PhotoImage(data=cv2.imencode('.png', resized_image_color)[1].tobytes())
            self.canvas.delete("all")  # Clear canvas
            self.canvas.create_image(
                self.image_offset[0], 
                self.image_offset[1], 
                image=self.photo, 
                anchor="nw"
            )
            
            # Bind mouse events
            self.canvas.bind("<Button-1>", self.on_click)
            self.canvas.bind("<B1-Motion>", self.on_drag)
            self.canvas.bind("<ButtonRelease-1>", self.on_release)

    def get_image_coordinates(self, event_x, event_y):
        # Convert canvas coordinates to image coordinates
        image_x = (event_x - self.image_offset[0]) / self.scale_factor
        image_y = (event_y - self.image_offset[1]) / self.scale_factor
        return int(image_x), int(image_y)

    def on_click(self, event):
        self.start_point = self.get_image_coordinates(event.x, event.y)
        
    def on_drag(self, event):
        if self.start_point:
            self.canvas.delete("line")
            current_point = self.get_image_coordinates(event.x, event.y)
            # Draw line in canvas coordinates
            canvas_start = (
                self.start_point[0] * self.scale_factor + self.image_offset[0],
                self.start_point[1] * self.scale_factor + self.image_offset[1]
            )
            canvas_end = (
                current_point[0] * self.scale_factor + self.image_offset[0],
                current_point[1] * self.scale_factor + self.image_offset[1]
            )
            self.canvas.create_line(
                canvas_start[0], canvas_start[1],
                canvas_end[0], canvas_end[1],
                tags="line"
            )
            
    def on_release(self, event):
        self.end_point = self.get_image_coordinates(event.x, event.y)
        if self.image is not None and self.start_point and self.end_point:
            profile, num_points = get_line_profile(self.image, self.start_point, self.end_point)
            self.plot_profile(profile, num_points)
            
    def plot_profile(self, profile, num_points):
        self.ax.clear()
        self.ax.plot(range(num_points), profile)
        
        # Add padding to y-axis limits
        y_min = np.min(profile)
        y_max = np.max(profile)
        y_padding = (y_max - y_min) * 0.1  # 10% padding
        
        self.ax.set_ylim([y_min - y_padding, y_max + y_padding])
        
        self.ax.set_title("Intensity Profile")
        self.ax.set_xlabel("Position along line")
        self.ax.set_ylabel("Intensity")
        self.ax.minorticks_on()
        self.ax.tick_params(axis='both', which='both', top=True, right=True, direction='in', width=1.15)
        self.ax.grid(True)
        self.canvas_widget.draw()

    def plot_from_coordinates(self):
        try:
            x1 = int(self.x1_entry.get())
            y1 = int(self.y1_entry.get())
            x2 = int(self.x2_entry.get())
            y2 = int(self.y2_entry.get())
            
            if self.image is not None:
                # Update canvas line
                canvas_start = (
                    x1 * self.scale_factor + self.image_offset[0],
                    y1 * self.scale_factor + self.image_offset[1]
                )
                canvas_end = (
                    x2 * self.scale_factor + self.image_offset[0],
                    y2 * self.scale_factor + self.image_offset[1]
                )
                self.canvas.delete("line")
                self.canvas.create_line(
                    canvas_start[0], canvas_start[1],
                    canvas_end[0], canvas_end[1],
                    tags="line"
                )
                
                # Get and plot profile
                profile, num_points = get_line_profile(self.image, (x1, y1), (x2, y2))
                self.plot_profile(profile, num_points)
        except ValueError:
            tk.messagebox.showerror("Error", "Please enter valid integer coordinates")

    def exit_program(self):
        """Properly close the application and exit the script"""
        self.root.quit()     # Stops mainloop
        self.root.destroy()  # Destroys the window
        import sys
        sys.exit(0)         # Exits Python

if __name__ == "__main__":

    root = tk.Tk()
    root.title("Intensity Profile Analyzer")
    root.geometry("1280x600")  # Increased from 1024x600
    app = IntensityProfiler(root)
    root.mainloop()