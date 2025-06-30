clear; clf; close all

dataDir = 'C:\Users\glzdi\Documents\OpticsAndCV\PySciDevVS\src\Research\NonLinearFiberOptics\matlab\Data';
cd(dataDir)

numFiles = 300;

for k = 1:numFiles
    fname = sprintf('NLPx%d.csv', k);
  
    M = readmatrix(fname);
    
    if k==1
        t_ps = M(:,1);
        nSamples = numel(t_ps);
        I_all = zeros(nSamples, numFiles);
    end
    
    E_Nx = M(:,2);
    E_Px = M(:,3);
    
    I_all(:,k) = abs(E_Nx).^2 + abs(E_Px).^2;
end

I_min  = min(I_all(:));
I_max  = max(I_all(:));
I_all = (I_all - I_min) ./ (I_max - I_min);

[SampleIdx, TimeGrid] = meshgrid(1:numFiles, t_ps);

figure;
surf(SampleIdx, TimeGrid, I_all, 'EdgeAlpha', 0.0, 'EdgeColor', 'None')
view(135,30)      
xlabel('No. Muestra', "Interpreter","latex")   
ylabel('Tiempo (ps)', "Interpreter","latex")
zlabel('Intensidad (a.u.)', "Interpreter","latex")
title('Evolución de las intensidades a través de la generación de pulsos de ruido', "Interpreter","latex")

shading interp
cmap = slanCM('cosmic');     
cmap = brighten(cmap, 0.51);   % 0 < factor < 1  → lighter
colormap(cmap)
axis tight
grid on