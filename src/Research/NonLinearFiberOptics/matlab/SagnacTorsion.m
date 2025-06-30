clear
clc
close all

lambda = 1550e-9;       % Wavelength (nm)
L_fiber = 1;           % Fiber length (m)
alpha = 0.5;            % Coupler rate
Lb = 2;               % Beat length
Ln = L_fiber/Lb;        % Beat length                 
g = 0.16;               % Silica fiber parameter
t = -10:0.01:10;        % Torsion
psi0 = 0;               % Fiber main axis rotation angle 
theta = 0;              % Port 3 Fiber main axis rotation angle 
DeltaN = lambda/Lb;     % Estimated birefringence  
L1 = 1;                 % Arm length B1
L2 = 1;                 % Arm length B2
t1 = 0;                 % Arm torsion B1
t2 = 0;                 % Arm torsion B2

E1 = [1;0];             % Input field
Iin = norm(E1).^2;      % Input intensity

J = zeros(2,2,length(t));
I_out = zeros(1, length(t));

for i = 1:length(t)
    delta_lb1 = (2*pi/lambda)*(L1*DeltaN);
    delta_c1= (1-g/2)*t1;
    
    delta_lb2 = (2*pi/lambda)*(L2*DeltaN);
    delta_c2= (1-g/2)*t2;
    
    etaB1 = etaBn(delta_lb1, delta_c1);
    etaB2 = etaBn(delta_lb2, delta_c2);
    
    Q1 = Qn(etaB1, delta_c1);
    Q2 = Qn(etaB2, delta_c2);
    
    P1 = Pn(etaB1, delta_lb1);
    P2 = Pn(etaB2, delta_lb2);
    
    B1 = BnMat(P1, Q1);
    B2 = BnMat(P2, Q2);
    
    C1 = C1Mat(theta);
    C2 = C2Mat(psi0, Ln, t(i));
    
    delta_cL = (1-g/2)*t(i);
    etaFL = etaL(psi0, Ln, delta_cL);
    QFL = QL(psi0, Ln, delta_cL, etaFL);
    PFL = PL(etaFL, Ln);
    FL = FLMat(PFL, QFL);
    
    J(:,:,i) = B1 * C1 * FL * C2 * B2; 
    E2 = Eout(E1, J(:,:,i), alpha);
    I_out(i) = norm(E2).^2;
end

T = I_out/Iin;
plot(t, T,'LineWidth', 0.93, 'Color', [1 0 0]);
xlabel('Torsion rate (rad)', "Interpreter","latex");
ylabel('Transmittance', "Interpreter","latex");
title('Sagnac Interferometer', "Interpreter", "latex");
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



function C1 = C1Mat(theta)

    C1 = [[cos(theta), -sin(theta)];[sin(theta), cos(theta)]];

end

function C2 = C2Mat(psi0, Ln, t)

    C2 = [[cos(psi0*Ln + t), -sin(psi0*Ln + t)];[sin(psi0*Ln + t), cos(psi0*Ln + t)]];
end

%==========================================================
% Arm matrices
%==========================================================
function B = BnMat(P, Q)

    B = [[P, conj(Q)];[Q, conj(P)]];
end

function P = Pn(etaB, delta_lb)
    
    P = cos(etaB) - 1j*(delta_lb/2)*(sin(etaB)/etaB);
end

function Q = Qn(etaB, delta_c)

    Q = delta_c*(sin(etaB)/etaB);
end

function etaB = etaBn(delta_lb, delta_c)

    etaB = sqrt((delta_lb/2).^2 + (delta_c).^2);
end
%==========================================================
% Loop matrices
%==========================================================
function FL = FLMat(P,Q)

    FL = [[P,conj(Q)];[Q,conj(P)]];
end

function P = PL(eta, Ln)

    P = cos(eta) - pi*1j*Ln*(sin(eta)/eta);
end

function Q = QL(psi0, Ln, delta_c, eta)

    Q = (psi0*Ln + delta_c)*(sin(eta)/eta);
end

function eta = etaL(psi0, Ln, delta_c)

    eta = sqrt((pi*Ln).^2 + (psi0*Ln + delta_c).^2);
end

%==========================================================
% Output field
%==========================================================
function E2 = Eout(E1, J, alpha)

    Jxx = J(1,1);
    Jxy = J(1,2);
    Jyx = J(2,1);

    E2 = [[(2*alpha-1)*Jxx, (1-alpha)*Jxy + alpha*Jyx];
        [-alpha*Jxy - (1-alpha)*Jyx, (1-2*alpha)*Jxx]] * E1;
end
