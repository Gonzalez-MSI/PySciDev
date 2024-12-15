import numpy as np
import matplotlib.pyplot as plt

import gnlse

# Simulation parameters
# ---------------------
setup = gnlse.GNLSESetup()
setup.resolution = 2**14
setup.time_window = 12.5       # [ps]
setup.z_saves = 200

# Physical parameters
# -------------------
setup.wavelength = 835        # [nm]
setup.fiber_length = 0.15     # [m]
setup.nonlinearity = 0.11     # [1/W/m]
setup.raman_model = gnlse.raman_blowwood
setup.self_steepening = True

# Beta Coefficients
# -----------------
loss = 0
betas = np.array([
    -11.830e-3, 8.1038e-5, -9.5205e-8, 2.0737e-10, -5.3943e-13, 1.3486e-15,
    -2.5495e-18, 3.0524e-21, -1.7140e-24
])
setup.dispersion_model = gnlse.DispersionFiberFromTaylor(loss, betas)

# Input pulse parameters
# ----------------------
peak_power = 10000          # [W]
duration = 0.050            # [ps] 
pulse_model = gnlse.SechEnvelope(peak_power, duration)
setup.pulse_model = pulse_model

# Solver
# ------
solver = gnlse.GNLSE(setup)
solution = solver.run()

fig1 = plt.figure()
fig1.suptitle(pulse_model.name)
ax1, ax2 = fig1.subplots(1,2)
gnlse.plot_wavelength_vs_distance(solution, WL_range=[400, 1400], ax=ax1)
gnlse.plot_delay_vs_distance(solution, time_range=[-0.5, 0.5], ax=ax2)



