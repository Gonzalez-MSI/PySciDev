clear
close all
clc

% Physical parameters
lambda = 1550e-9;      % Wavelength in meters
Delta_n = 1e-7;        % Linear birefringence
L = 10;                % Fiber loop length in meters
alpha = 0.5;           % Coupling ratio (50:50)
g = 0.16;              % Photoelastic coefficient of fiber

% Simulation range
t = linspace(-10, 10, 1000);  % Torsion range (rad/m)

% Calculated parameters
k0 = 2*pi/lambda;      % Wave number
delta = k0 * Delta_n;  % Linear birefringence parameter

% Output arrays
T_sagnac = zeros(size(t));
R_sagnac = zeros(size(t));

% Calculate response for each torsion value
for i = 1:length(t)
    tau = t(i);  % Current torsion value
    
    % Phase difference due to torsion for the Sagnac loop
    % For counter-propagating beams in the Sagnac loop
    phi_torsion = 2 * g * tau * L;
    
    % Transmittance and reflectance with torsion-induced non-reciprocity
    T_sagnac(i) = (1 - cos(phi_torsion))/2;  % Transmitted intensity (normalized)
    R_sagnac(i) = (1 + cos(phi_torsion))/2;  % Reflected intensity (normalized)
end

% Plot results
figure;
plot(t, T_sagnac, 'r-', 'LineWidth', 1.5);
hold on;
plot(t, R_sagnac, 'b--', 'LineWidth', 1.5);
xlabel('Torsion Rate (rad/m)', 'Interpreter', 'latex');
ylabel('Normalized Intensity', 'Interpreter', 'latex');
title('Sagnac Interferometer Response to Torsion', 'Interpreter', 'latex');
legend('Transmission', 'Reflection', 'Interpreter', 'latex');
grid on;
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
    'TickLength', [0.02, 0.04], ...
    'LineWidth', 0.5);
grid minor;
set(gca, 'GridLineStyle', ':', ...
         'GridColor', [0.5, 0.5, 0.5], ...
         'GridAlpha', 0.7, ...
         'MinorGridLineStyle', ':', ...
         'MinorGridColor', [0.8, 0.8, 0.8], ...
         'MinorGridAlpha', 0.5);

% Add detailed caption with parameters
caption = sprintf(['Sagnac interferometer response to torsion rate.\n' ...
                  'Parameters: L = %g m, λ = %g nm, g = %g'], ...
                  L, lambda*1e9, g);
annotation('textbox', [0.15, 0.01, 0.7, 0.05], ...
           'String', caption, ...
           'EdgeColor', 'none', ...
           'HorizontalAlignment', 'center');
