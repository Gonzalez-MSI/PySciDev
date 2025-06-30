% Simulate supercontinuum generation for parameters similar
% to Fig.3 of Dudley et. al, RMP 78 1135 (2006)
% Written by J.C. Travers, M.H Frosz and J.M. Dudley (2009)
% Please cite this chapter in any publication using this code.
% Updates to this code are available at www.scgbook.info
% Minor bug fix: 16/03/2020
close all
% Define the target directory
targetDir = 'C:\Users\glzdi\Documents\OpticsAndCV\PySciDevVS\src\Research\NonLinearFiberOptics\matlab';

% Get the current directory
currentDir = pwd;

% Check if the current directory is the target directory
if ~strcmp(currentDir, targetDir)
    % Change to the target directory
    try
        cd(targetDir);
        fprintf('Changed to directory: %s\n', targetDir);
    catch ME
        fprintf('Error: Unable to change to directory "%s".\n', targetDir);
        fprintf('Reason: %s\n', ME.message);
    end
else
    fprintf('Already in the target directory: %s\n', targetDir);
end

% numerical grid
n = 2^13;                   % number of grid points
twidth = 12.5e-12;          % width of time window [s]
c = 299792458;              % speed of light [m/s]
wavelength = 835e-9;        % reference wavelength [m]
w0 = (2*pi*c)/wavelength;   % reference frequency [Hz]
dt = twidth/n;
T = (-n/2:n/2 - 1).*dt; % time grid

% === input pulse
power = 10000;              % peak power of input [W]
t0 = 28.4e-15;              % duration of input [s]
A = sqrt(power)*sech(T/t0); % input field [W^(1/2)]

%******************* Bessel-gaussian beam *******************%
% q = 1;                          % Bessel function order
% Wo = 30;                        % Beam waist
% L = T/t0;
% J = abs(besselj(q,L));          % Bessel beam 1D envelope
% G = exp(-(L.^2)/(Wo.^2));       % Gaussian 1D envelope
% A = sqrt(power) * J.*G;                       % Bessel-Gaussian beam

% Plot the pulse profile
figure()
plot((T/t0), A)
% xlim([-2 2])
title('Pulse profile', "Interpreter", "latex"); 
xlabel('$\frac{x}{w_0}$', "Interpreter", "latex"); 
ylabel('$|E|$', "Interpreter", "latex");
grid on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
'TickLength', [0.02, 0.04], ...
'LineWidth', 0.5);

% === fibre parameters
flength = 0.15;             % fibre length [m]
% betas = [beta2, beta3, ...] in units [s^2/m, s^3/m ...]
betas = [-1.1830e-026, 8.1038e-041, -9.5205e-056,  2.0737e-070, ...
         -5.3943e-085,  1.3486e-099, -2.5495e-114,  3.0524e-129, ...
         -1.7140e-144];
gamma = 0.11;               % nonlinear coefficient [1/W/m]
loss = 0;                   % loss [dB/m]

% === Raman response
fr = 0.18;                  % fractional Raman contribution
tau1 = 0.0122e-12; tau2 = 0.032e-12;
RT = (tau1^2+tau2^2)/tau1/tau2^2*exp(-T/tau2).*sin(T/tau1);
RT(T<0) = 0;                % heaviside step function

% === simulation parameters
nsaves = 200;     % number of length steps to save field at

% propagate field
[Z, AT, AW, W] = gnlse(T, A, w0, gamma, betas, loss, ...
                       fr, RT, flength, nsaves);
                   
% === plot output
figure();
tlayout1 = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact'); % 2x2 gridt = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact'); % 2x2 grid

ax1 = nexttile;
WL = 2*pi*c./W; iis = (WL>450e-9 & WL<1350e-9); % wavelength grid
lIW = 10*log10(abs(AW).^2 .* 2*pi*c./WL'.^2); % log scale spectral intensity
mlIW = max(max(lIW));       % max value, for scaling plot         
pcolor(WL(iis).*1e9, Z, lIW(:,iis)); % plot as pseudocolor map
caxis([mlIW-40.0, mlIW]);  xlim([450,1350]); shading interp; 
xlabel('Wavelength / nm'); ylabel('Distance / m');
colormap(slanCM('magma'));

ax2 = nexttile;
lIT = 10*log10(abs(AT).^2); % log scale temporal intensity
mlIT = max(max(lIT));       % max value, for scaling plot
pcolor(T.*1e12, Z, lIT);    % plot as pseudocolor map
caxis([mlIT-40.0, mlIT]);  xlim([-0.5,5]); shading interp;
xlabel('Delay / ps'); ylabel('Distance / m');
colormap(slanCM('magma'));

% Select the desired propagation distance in meters
desired_distance_in_meters = 1; 

% Find the index closest to the desired distance
[~, desired_distance_index] = min(abs(Z - desired_distance_in_meters));

% Check if the exact distance is available
if abs(Z(desired_distance_index) - desired_distance_in_meters) < 1e-6
    % Extract the spectral data at the desired propagation distance
    spectrum = abs(AW(desired_distance_index, :)).^2; % Intensity spectrum
    spectrum_db = 10*log10(spectrum / max(spectrum)); % Convert to dB scale
else
    % Find the nearest available distance
    [~, nearest_index] = min(abs(Z - desired_distance_in_meters));

    % Extract the spectral data at the nearest available distance
    spectrum = abs(AW(nearest_index, :)).^2; % Intensity spectrum
    spectrum_db = 10*log10(spectrum / max(spectrum)); % Convert to dB scale
    fprintf('Using nearest available distance of %.3f meters\n', Z(nearest_index));
end

% Plot the spectral evolution line plot
figure();
plot(2 * pi * c ./ W * 1e9, spectrum_db); % Plot wavelength (nm) vs. spectrum (dB)
xlabel('Wavelength (nm)',  "Interpreter", "latex");
ylabel('Spectrum (dB)', "Interpreter", "latex");
title(sprintf('Spectral Evolution'), 'Interpreter', 'latex');
xlim([400 1200]);
grid on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
     'TickLength', [0.02, 0.04], ...
     'LineWidth', 0.5);

% Check if the exact distance is available
if abs(Z(desired_distance_index) - desired_distance_in_meters) < 1e-6
    % Extract the temporal data at the desired propagation distance
    temporal_field = abs(AT(desired_distance_index, :)).^2; % Intensity in time
else
    % Find the nearest available distance
    [~, nearest_index] = min(abs(Z - desired_distance_in_meters));
    % Extract the temporal data at the nearest available distance
    temporal_field = abs(AT(nearest_index, :)).^2; % Intensity in time
end

% Create time axis (assuming T is your time vector)
time_axis = T * 1e15; % Convert to femtoseconds if T is in seconds

% Plot the time evolution plot
figure();
plot(time_axis, temporal_field);
xlabel('Time (fs)', 'Interpreter', 'latex');
ylabel('Intensity (a.u.)', 'Interpreter', 'latex');
title(sprintf('Time Evolution'), 'Interpreter', 'latex');
xlim([0 4000])
grid on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
'TickLength', [0.02, 0.04], ...
'LineWidth', 0.5);
