clc; clear; close all;

%% Parameters
N = 1024;                % Number of sample points
Tmax = 5;                % Time window (in ps)
t = linspace(-Tmax, Tmax, N); % Time axis (ps)

lambda = 1550e-9;        % Wavelength (m)
T0 = 1;                  % Initial pulse width (ps)
A0 = 1;                  % Peak amplitude (normalized)

L = 1;                   % Fiber length (km)
Nz = 100;                % Number of steps in propagation

n2 = 2.6e-20;            % Nonlinear refractive index (m^2/W)
Aeff = 80e-12;           % Effective core area (m^2)
Gamma = (2*pi*n2) / (lambda*Aeff); % Nonlinear parameter (1/W/km)

%% Initial Pulse (Sech Pulse)
A = A0 * sech(t/T0);     % Initial field amplitude

%% Split-Step Fourier Method (SSFM) Simulation

% Step size
dz = L / Nz;            % Step size in km

% Frequency axis
fs = 1 / (t(2) - t(1)); 
f = (-N/2:N/2-1) * (fs / N);
omega = 2 * pi * f;     % Angular frequency

% Initialize field
A_z = A;

for n = 1:Nz
    % Nonlinear Phase Shift (SPM)
    phi_nl = Gamma * abs(A_z).^2 * dz;
    A_z = A_z .* exp(1j * phi_nl);
end

%% Plot Results
figure;
subplot(2,1,1);
plot(t, abs(A).^2, 'k', 'LineWidth', 1.5); hold on;
plot(t, abs(A_z).^2, 'r', 'LineWidth', 1.5);
legend('Input Pulse', 'Output Pulse');
xlabel('Time (ps)'); ylabel('Power (arb. units)');
title('Effect of Self-Phase Modulation'); grid on;

subplot(2,1,2);
plot(t, angle(A_z), 'b', 'LineWidth', 1.5);
xlabel('Time (ps)'); ylabel('Phase (rad)');
title('Phase Evolution Due to SPM'); grid on;