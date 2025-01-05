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

format long e
fprintf(1,'\n\n\n----------------------------------------------');
fprintf(1,'\nSimulating Supercontinuum Generation in PCF');

% INPUT PARAMETERS *****************************************************

c = 299792.458;                     %speed of ligth nm/ps

% Input Field Paramenters
tfwhm = 28.4e-3;                    % ps
ni = 1/tfwhm;                       % ps^-1
lamda_central = 835;
fo=c/lamda_central;                 % central pulse frequency (Thz)

% Fiber Parameters
gamma = 95;                        % W^-1 * km^-1
alpha = 0;                          % atenuation coef. (km^-1)
L = 0.001;                         % fiber length (km)
betaw = [0 0 -11.830 8.1038e-2 -9.5205e-5 2.0737e-7 -5.3943e-10 1.3486e-12 -2.5495e-15 3.0524e-18 -1.714e-21]; % beta coefficients (ps^n/ nm)


% Numerical Parameters
nt = 2^15;                              % number of spectral points`
time = 32;                              % ps
dt = time/nt;                           % ps
t = -time/2:dt:(time/2-dt);             % ps
dz = 1e-7;                              % initial longitudinal step (km)
v = [(0:nt/2-1),(-nt/2:-1)]/(dt*nt);    % frequencies frequencies (THz)

% INPUT FIELD ***********************************************************
w0 = 15;
q = 1;
PeakPower = 10000; % W, change here the Input Power!
% u0 = sqrt(PeakPower)*sech(ni*t); %initial field shape in W^0.5
u0 = sqrt(PeakPower)*BesselPulseFunction(ni*t, w0, q);

% PLOT INPUT FIELD ******************************************************
figure();
plot(ni*t, u0)
xlim([-100 100])
title('Input Pulse', 'Interpreter', 'latex')
xlabel('Normalized time',  'Interpreter', 'latex')
ylabel('Power (W)', 'Interpreter', 'latex')
grid on
box on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
'TickLength', [0.02, 0.04], ...
'LineWidth', 0.5);

% NON DIFFRACTIVE BEAM 3D ************************************************
figure();
x3D = linspace(-time, (time - dt), 200);
y3D = x3D';
r3D = sqrt(x3D.^2 + y3D.^2);
J3D = abs(besselj(q, r3D));
u03D = sqrt(PeakPower)*exp(-(r3D.^2)/(w0.^2)).*J3D;
surf(x3D/w0, y3D/w0, u03D*ni, 'EdgeAlpha', 0.4);
title('Input Pulse - 3D', 'Interpreter', 'latex')
zlabel('$|E(x,y)|$', 'Interpreter', 'latex'); 
xlabel('$\frac{x}{w0}$', 'Interpreter', 'latex'); 
ylabel('$\frac{y}{w0}$', 'Interpreter', 'latex'); 
box on

% PR0PAGATE finding numerical solution **********************************
%************************************************************************
fprintf(1,'\n\nInteraction Picture Method started');
tol = 1e-2; % photon error number, or local error, depending on the used method. 
tic

% uncomment one of the following four lines according to the method youwant
% to use
[u,nf] = IP_CQEM_FD(u0,dt,L,dz,alpha,betaw,gamma,fo,tol);
% [u,nf] = IP_CQEM_TD(u0,dt,L,dz,alpha,betaw,gamma,fo,tol);
% [u,nf] = IP_LEM_FD(u0,dt,L,dz,alpha,betaw,gamma,fo,tol);
% [u,nf] = IP_LEM_TD(u0,dt,L,dz,alpha,betaw,gamma,fo,tol);

tx = toc;

fprintf(1, '\n\nSimulation lasted (s) = ');
fprintf(1, '%5.2f%', tx );

%  ---------plot output spectrum------------------
specnorm = fftshift(abs(fft(u)).^2);
specnorm = specnorm/max(specnorm);
figure();
hold on
plot(c./(fftshift(v) + fo),10*log10(specnorm));
grid on;
xlabel('wavelength (nm)', 'Interpreter', 'latex');
ylabel('Normalized Spectrum (a.u.)', 'Interpreter', 'latex');
title ('Output Spectrum', 'Interpreter', 'latex');
axis([480 1550 -70 1])
grid on
box on
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', ...
'TickLength', [0.02, 0.04], ...
'LineWidth', 0.5);
fprintf(1,'\n----------------------------------------------\n\n');
