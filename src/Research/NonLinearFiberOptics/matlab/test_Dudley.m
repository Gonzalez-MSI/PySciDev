% Simulate supercontinuum generation for parameters similar
% to Fig.3 of Dudley et. al, RMP 78 1135 (2006)
% Written by J.C. Travers, M.H Frosz and J.M. Dudley (2009)
% Please cite this chapter in any publication using this code.
% Updates to this code are available at www.scgbook.info

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

n = 2^13;                   % number of grid points
twidth = 12.5;              % width of time window [ps]
c = 299792458*1e9/1e12;     % speed of light [nm/ps]
wavelength = 835;           % reference wavelength [nm]
w0 = (2.0*pi*c)/wavelength; % reference frequency [2*pi*THz]
T = linspace(-twidth/2, twidth/2, n); % time grid
% === input pulse
power = 10000;              % peak power of input [W]
t0 = 0.0284;                % duration of input [ps]
A = sqrt(power)*sech(T/t0); % input field [W^(1/2)]

%******************* Bessel-gaussian beam *******************%
% q = 1;                          % Bessel function order
% Wo = 30;                        % Beam waist
% L = T/t0;
% J = abs(besselj(q,L));          % Bessel beam 1D envelope
% G = exp(-(L.^2)/(Wo.^2));       % Gaussian 1D envelope
% A = sqrt(power) * J.*G;                       % Bessel-Gaussian beam

figure;
plot(T/t0,A)
title('Pulse profile', "Interpreter", "latex"); 
xlabel('$\frac{T}{t_0}$', "Interpreter", "latex"); 
ylabel('$|E|$', "Interpreter", "latex");
grid on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
'TickLength', [0.02, 0.04], ...
'LineWidth', 0.5);
grid minor; % Adds minor grid lines
set(gca, 'GridLineStyle', ':', ...    % Dashed grid lines
         'GridColor', [0.5, 0.5, 0.5], ... % Gray grid lines
         'GridAlpha', 0.7, ...         % Transparency of major grid
         'MinorGridLineStyle', ':', ...% Dotted minor grid lines
         'MinorGridColor', [0.8, 0.8, 0.8], ... % Light gray minor grid
         'MinorGridAlpha', 0.5);       % Transparency of minor grid
% === fibre parameters
flength = 0.15;             % fibre length [m]
% betas = [beta2, beta3, ...] in units [ps^2/m, ps^3/m ...]
betas = [-11.830e-3, 8.1038e-5, -9.5205e-8, 2.0737e-10, ...
         -5.3943e-13, 1.3486e-15, -2.5495e-18, 3.0524e-21, ...
         -1.7140e-24];
gamma = 0.11;               % nonlinear coefficient [1/W/m]
loss = 0;                   % loss [dB/m]
% === Raman response
fr = 0.18;                  % fractional Raman contribution
tau1 = 0.0122; tau2 = 0.032;
RT = (tau1^2+tau2^2)/tau1/tau2^2*exp(-T/tau2).*sin(T/tau1);
RT(T<0) = 0;          % heaviside step function
%RT = RT/trapz(T,RT);  % normalise RT to unit integral
% === simulation parameters
nsaves = 200;     % number of length steps to save field at
% propagate field
[Z, AT, AW, W] = gnlse(T, A, w0, gamma, betas, loss, ...
                       fr, RT, flength, nsaves);
% === plot output
figure;
lIW = 10*log10(abs(AW).^2); % log scale spectral intensity
mlIW = max(max(lIW));       % max value, for scaling plot
WL = 2*pi*c./W; iis = (WL>400 & WL<1350); % wavelength grid
subplot(1,2,1);             
pcolor(WL(iis), Z, lIW(:,iis)); % plot as pseudocolor map
caxis([mlIW-40.0, mlIW]);  xlim([400,1350]); shading interp; 
xlabel('Wavelength / nm'); ylabel('Distance / m');
colormap(slanCM('magma'))

lIT = 10*log10(abs(AT).^2); % log scale temporal intensity
mlIT = max(max(lIT));       % max value, for scaling plot
subplot(1,2,2);
pcolor(T, Z, lIT);          % plot as pseudocolor map
caxis([mlIT-40.0, mlIT]);  xlim([-0.5,5]); shading interp;
xlabel('Delay / ps'); ylabel('Distance / m');
colormap(slanCM('magma'))

% === spectral and time evolution line plots === %
% Select the desired propagation distance in meters
desired_distance_in_meters = 0.0; 

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

figure;
WLGN = 2 * pi * c ./ W;
plot(WLGN, spectrum_db)
xlim([400 1800])
xlabel('Wavelength (nm)',  "Interpreter", "latex");
ylabel('Spectrum (dB)', "Interpreter", "latex");
title(sprintf('Spectral Evolution'), 'Interpreter', 'latex');
grid on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
'TickLength', [0.02, 0.04], ...
'LineWidth', 0.5);
grid minor; % Adds minor grid lines
set(gca, 'GridLineStyle', ':', ...    % Dashed grid lines
         'GridColor', [0.5, 0.5, 0.5], ... % Gray grid lines
         'GridAlpha', 0.7, ...         % Transparency of major grid
         'MinorGridLineStyle', ':', ...% Dotted minor grid lines
         'MinorGridColor', [0.8, 0.8, 0.8], ... % Light gray minor grid
         'MinorGridAlpha', 0.5);       % Transparency of minor grid
     
% Check if the exact distance is available
if abs(Z(desired_distance_index) - desired_distance_in_meters) < 1e-6
    % Extract the temporal data at the desired propagation distance
    temporal_field_intensity = abs(AT(desired_distance_index, :)).^2; % Intensity in time
else
    % Find the nearest available distance
    [~, nearest_index] = min(abs(Z - desired_distance_in_meters));
    % Extract the temporal data at the nearest available distance
    temporal_field_intensity = abs(AT(nearest_index, :)).^2; % Intensity in time
end

figure;
plot(T*1e3, temporal_field_intensity)                 
xlim([0 6000])
xlabel('Time (fs)', 'Interpreter', 'latex');
ylabel('Intensity (a.u.)', 'Interpreter', 'latex');
title(sprintf('Time Evolution'), 'Interpreter', 'latex');
grid on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
'TickLength', [0.02, 0.04], ...
'LineWidth', 0.5);
grid minor; % Adds minor grid lines
set(gca, 'GridLineStyle', ':', ...    % Dashed grid lines
         'GridColor', [0.5, 0.5, 0.5], ... % Gray grid lines
         'GridAlpha', 0.7, ...         % Transparency of major grid
         'MinorGridLineStyle', ':', ...% Dotted minor grid lines
         'MinorGridColor', [0.8, 0.8, 0.8], ... % Light gray minor grid
         'MinorGridAlpha', 0.5);       % Transparency of minor grid