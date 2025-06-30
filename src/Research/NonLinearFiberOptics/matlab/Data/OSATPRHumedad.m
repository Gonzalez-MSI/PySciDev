clear

cd 'C:\Users\glzdi\Documents\OpticsAndCV\PySciDevVS\src\Research\NonLinearFiberOptics\matlab\Data';% Trace B
% Trace F
% Read the data from the CSV file
data = readmatrix('C:\Users\glzdi\Documents\OpticsAndCV\PySciDevVS\src\Research\NonLinearFiberOptics\matlab\Data\W0036.CSV');

% Extract wavelength and power columns
wavelength = data(:, 1);
power = data(:, 2);

% Remove the first 21 elements from both vectors
wavelength(1:21) = [];
power(1:21) = [];

% Plot the remaining data
figure;
hold on
plot(wavelength, power, "LineWidth", 1.02, "Color", [1 0 0], 'DisplayName', 'Trace F');
xlabel('Wavelength (nm)', "Interpreter","latex");
ylabel('Power (dBm)',"Interpreter","latex");
title('Optical Spectrum Analysis',"Interpreter","latex");
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

% Trace G
% Read the data from the CSV file
data2 = readmatrix('C:\Users\glzdi\Documents\OpticsAndCV\PySciDevVS\src\Research\NonLinearFiberOptics\matlab\Data\W0037.CSV');

% Extract wavelength and power columns
wavelength2 = data2(:, 1);
power2 = data2(:, 2);

% Remove the first 21 elements from both vectors
wavelength2(1:21) = [];
power2(1:21) = [];

% Plot the remaining data
% figure;
plot(wavelength2, power2, "LineWidth", 1.02, "Color", '#ff3333', 'DisplayName', 'Trace G');
xlabel('Wavelength (nm)', "Interpreter","latex");
ylabel('Power (dBm)',"Interpreter","latex");
title('Optical Spectrum Analysis',"Interpreter","latex");
box on
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

% Read the data from the CSV file
data3 = readmatrix('C:\Users\glzdi\Documents\OpticsAndCV\PySciDevVS\src\Research\NonLinearFiberOptics\matlab\Data\W0037.CSV');

% Extract wavelength and power columns
wavelength3 = data3(:, 1);
power3 = data3(:, 2);

% Remove the first 21 elements from both vectors
wavelength3(1:21) = [];
power3(1:21) = [];

% Trace B
% Plot the remaining data
% figure;
plot(wavelength3, power3, "LineWidth", 1.02, "Color", '#4633ff', "DisplayName", 'Trace B');
xlabel('Wavelength (nm)', "Interpreter","latex");
ylabel('Power (dBm)',"Interpreter","latex");
title('Optical Spectrum Analysis',"Interpreter","latex");
box on
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
hold off

legend('Interpreter',"latex")
hold off
