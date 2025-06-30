%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written for Course :- Computational Electromagnetics, Fall 2011
%                       Department of Electrical Engineering
%                       Indian Institute of Technology Madras
%                       Chennai - 600036, India
%
% Authors            :- Sathya Swaroop Ganta, B.Tech., M.Tech. Electrical Engg.
%                       Kayatri, M.S. Engineering Design
%                       Pankaj, M.S. Electrical Engg.
%                       Sumantra Chaudhuri, M.S. Electrical Engg.
%                       Projesh Basu, M.S. Electrical Engg.
%                       Nikhil Kumar CS, M.S. Electrical Engg.
%
% Instructor :- Ananth Krishnan
%               Assistant Professor
%               Department of Electrical Engineering
%               Indian Institute of Technology Madras
%
% Any correspondance regarding this program may be addressed to
% Prof. Ananth Krishnan at 'computational.em.at.iit.madras@gmail.com'
%
% Copyright/Licensing :- For educational and research purposes only. No
% part of this program may be used for any financial benefit of any kind
% without the consent of the instructor of the course.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "A photonic crystal waveguide simulation using 2D FDTD"
% 
%              The photonic crystal structure consists of periodic dielectric 
% or metallo-dielectric structures within a background material of different 
% index. Photons, behaving as waves, propagate through the structure or not, 
% depending on the relation between the dimensions of the periodic structures
% and the wavelength of the propagating waves. 
%                
%              In this program, a 4.65 micron x 4.65 micron structure is taken
% with 7x7 periodic structures of square dimensions (made of silicon i.e n=3.4)  
% having 0.15 micron as the length of a side as a 7x7 square array at the centre 
% of the domain with a separation of 0.45 micron between neighbouring structures
% both horizontally and vertically. The region in between and surrounding that 
% of the structures are filled with air of refractive index, n=1. A central 
% horizontal line of 7 periodic structures are removed to form a central wave
% guide through which the light is guided.
%
%             The smallest dimension in this case is the dimension of the  
% periodic structures i.e 0.15 microns which is again divided into 'factor'
% no of space steps in the 2D FDTD program below and all dimensions in the
% structure including source wavelength are modeled using this smallest 
% dimension iin terms of numer of space steps.
%
%             An option is given in the program to have Mur’s absorbing boundary 
% condition or perfectly matched layer boundary condition. The 2D FDTD codes
% for the two cases are given in a detailed fashion in the previous programs
% and they are being reused here.
%
%             A color scaled plot of the Ez wave travelling through the
% waveguides starting from the left end of the central waveguide as a line
% source along the length of missing periodic structure of the central waveguide. 
% The source is hard and sinusoidal in nature and its free space wavelength 
% is given as 1.55 microns. The epsilon profile of the platform is shown in 
% the background of the plot to give a feel for the location of the travelling 
% wave. The simulation can be stopped by closing this plot window or by waiting 
% till the plots for all the time steps are shown.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Clearing variables in memory and Matlab command screen
close all
clear;
clc;

%Boundary condition selection, any one can be selected by making it 1
pml=1;
abc=0;

factor=10;
%'factor' :- the number of times the smallest dimension (viz. 0.15 micron in 
%             the given spec) is divided to get one space step (delta)
% Increasing value of factor increases resolution of results but if that is done, 
% to see full result, value of time_tot (total time steps) should be increased. 

%Courant stability factor
S=1/(2^0.5);

% Parameters of free space (permittivity and permeability and speed of
% light) are all not 1 and are given real values
epsilon0=(1/(36*pi))*1e-9;
mu0=4*pi*1e-7;
c=3e+8;

% Spatial grid step length (spatial grid step= 0.15 micron/factor; and factor 
% can be changed)
delta=0.15e-6/factor;
% Temporal grid step obtained using Courant condition
deltat=S*delta/c;

%Total no of time steps
time_tot=1000;

% Grid Dimension in x (xdim) and y (ydim) directions
ydim=31*factor;%The domain is 30*factor space steps or 31*0.15=4.65 microns long
xdim=31*factor;%The domain is 80*factor space steps or 31*0.15=4.65 microns wide

%Free-space wavelength in microns
wav=1.55;

%Index of the periodic structures
index=3.4;

% Initialization of permittivity and permeability matrices
epsilon=epsilon0*ones(xdim,ydim);
mu=mu0*ones(xdim,ydim);


% Defining of the permittivity profile of the region:-

% Defining of the 7x7 array of periodic structures
for i=4:4:28
    for j=4:4:28
        epsilon((i-1)*factor+1:i*factor,(j-1)*factor+1:j*factor)=index*index*epsilon0;
    end
end

% Defining of the central waveguide region 
epsilon(:,15*factor+1:16*factor)=epsilon0;


% 2D FDTD update for PML boundary as used in previous program
if pml==1
    
    % Initialization of field matrices
    Ez=zeros(xdim,ydim);
    Ezx=zeros(xdim,ydim);
    Ezy=zeros(xdim,ydim);
    Hy=zeros(xdim,ydim);
    Hx=zeros(xdim,ydim);
    
    % Initializing electric conductivity matrices in x and y directions
    sigmax=zeros(xdim,ydim);
    sigmay=zeros(xdim,ydim);
    
    
    %Perfectly matched layer boundary design
    %Reference:-http://dougneubauer.com/wp-content/uploads/wdata/yee2dpml1/yee2d_c.txt
    %(An adaptation of 2-D FDTD TE code of Dr. Susan Hagness)
    
    %Boundary width of PML in all directions
    bound_width=factor*3;
    
    %Order of polynomial on which sigma is modeled
    gradingorder=6;
    
    %Required reflection co-efficient
    refl_coeff=1e-6;
    
    %Polynomial model for sigma
    sigmamax=(-log10(refl_coeff)*(gradingorder+1)*epsilon0*c)/(2*bound_width*delta);
    boundfact1=((epsilon(xdim/2,bound_width)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
    boundfact2=((epsilon(xdim/2,ydim-bound_width)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
    boundfact3=((epsilon(bound_width,ydim/2)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
    boundfact4=((epsilon(xdim-bound_width,ydim/2)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
    x=0:1:bound_width;
    for i=1:1:xdim
        sigmax(i,bound_width+1:-1:1)=boundfact1*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1));
        sigmax(i,ydim-bound_width:1:ydim)=boundfact2*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1));
    end
    for i=1:1:ydim
        sigmay(bound_width+1:-1:1,i)=boundfact3*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1))';
        sigmay(xdim-bound_width:1:xdim,i)=boundfact4*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1))';
    end
    
    %Magnetic conductivity matrix obtained by Perfectly Matched Layer condition
    %This is also split into x and y directions in Berenger's model
    sigma_starx=(sigmax.*mu)./epsilon;
    sigma_stary=(sigmay.*mu)./epsilon;
    
    %Multiplication factor matrices for H matrix update to avoid being calculated many times
    %in the time update loop so as to increase computation speed
    G=((mu-0.5*deltat*sigma_starx)./(mu+0.5*deltat*sigma_starx));
    H=(deltat/delta)./(mu+0.5*deltat*sigma_starx);
    A=((mu-0.5*deltat*sigma_stary)./(mu+0.5*deltat*sigma_stary));
    B=(deltat/delta)./(mu+0.5*deltat*sigma_stary);
    
    %Multiplication factor matrices for E matrix update to avoid being calculated many times
    %in the time update loop so as to increase computation speed
    C=((epsilon-0.5*deltat*sigmax)./(epsilon+0.5*deltat*sigmax));
    D=(deltat/delta)./(epsilon+0.5*deltat*sigmax);
    E=((epsilon-0.5*deltat*sigmay)./(epsilon+0.5*deltat*sigmay));
    F=(deltat/delta)./(epsilon+0.5*deltat*sigmay);
    
    % Update loop begins
    for n=1:1:time_tot
        
        %matrix update instead of for-loop for Hy and Hx fields
        Hy(1:xdim-1,1:ydim-1)=A(1:xdim-1,1:ydim-1).*Hy(1:xdim-1,1:ydim-1)+B(1:xdim-1,1:ydim-1).*(Ezx(2:xdim,1:ydim-1)-Ezx(1:xdim-1,1:ydim-1)+Ezy(2:xdim,1:ydim-1)-Ezy(1:xdim-1,1:ydim-1));
        Hx(1:xdim-1,1:ydim-1)=G(1:xdim-1,1:ydim-1).*Hx(1:xdim-1,1:ydim-1)-H(1:xdim-1,1:ydim-1).*(Ezx(1:xdim-1,2:ydim)-Ezx(1:xdim-1,1:ydim-1)+Ezy(1:xdim-1,2:ydim)-Ezy(1:xdim-1,1:ydim-1));
        
        %matrix update instead of for-loop for Ez field
        Ezx(2:xdim,2:ydim)=C(2:xdim,2:ydim).*Ezx(2:xdim,2:ydim)+D(2:xdim,2:ydim).*(-Hx(2:xdim,2:ydim)+Hx(2:xdim,1:ydim-1));
        Ezy(2:xdim,2:ydim)=E(2:xdim,2:ydim).*Ezy(2:xdim,2:ydim)+F(2:xdim,2:ydim).*(Hy(2:xdim,2:ydim)-Hy(1:xdim-1,2:ydim));
        
        % Source condition incorporating given free space wavelength 'wav'
        % and having a location at the left end of central waveguide just
        % after PML boundary
        tstart=1;
        N_lambda=wav*1e-6/delta;
        Ezx(bound_width+1,15*factor+1:16*factor)=0.5*sin(((2*pi*(c/(delta*N_lambda))*(n-tstart)*deltat)));
        Ezy(bound_width+1,15*factor+1:16*factor)=0.5*sin(((2*pi*(c/(delta*N_lambda))*(n-tstart)*deltat)));
                
        Ez=Ezx+Ezy;
        
        %Movie type colour scaled image plot of Ez
        h=imagesc(delta*1e+6*(1:1:xdim),(1e+6*delta*(1:1:ydim))',Ez',[-1,1]);colorbar;
        set(h,'AlphaData',2*epsilon'/epsilon0);
        colormap(slanCM('bwr')); % Apply blue-white-red colormap
        title(['\fontsize{20}Color-scaled image plot of Ez in photonic crystal waveguide with PML boundary and at time = ',num2str(round(n*deltat*1e+15)),' fs']);
        xlabel('x (in um)','FontSize',20);
        ylabel('y (in um)','FontSize',20);
        set(gca,'FontSize',20);
        getframe;
    end
end

%Fdtd update for Mur's absorbing boundary conditions
if abc==1
    
    % Initialization of field matrices
    Ez=zeros(xdim,ydim);
    Hy=zeros(xdim,ydim);
    Hx=zeros(xdim,ydim);
    
    % Initializing electric and magnetic conductivity matrices
    sigma=4e-4*ones(xdim,ydim);
    sigma_star=4e-4*ones(xdim,ydim);
    
    %Multiplication factor matrices for H matrix update to avoid being calculated many times
    %in the time update loop so as to increase computation speed
    A=((mu-0.5*deltat*sigma_star)./(mu+0.5*deltat*sigma_star));
    B=(deltat/delta)./(mu+0.5*deltat*sigma_star);
    
    %Multiplication factor matrices for E matrix update to avoid being calculated many times
    %in the time update loop so as to increase computation speed
    C=((epsilon-0.5*deltat*sigma)./(epsilon+0.5*deltat*sigma));
    D=(deltat/delta)./(epsilon+0.5*deltat*sigma);
    
    %Mur's absorbing boundary condition parameters
    p0=1;
    p2=-0.5;
    
    %Co-efficients of present and previous (regarding time-step) boundary Ez values
    %in boundary update equation for forward/up and backward/down boundaries in
    %the domain (as given in [1])
    c0=(c/(2*S))*(1-(p0/S));
    c1=-(c/(2*S))*(1+(p0/S));
    c2=(c/(S^2))*(p0+(p2*S*S));
    c3=-(p2*c)/2;
    c0efffor=-(c0/c1);
    c2efffor=-(c2/c1);
    c3efffor=-(c3/c1);
    c0=(c/(2*S))*(1+(p0/S));
    c1=-(c/(2*S))*(1-(p0/S));
    c2=-(c/(S^2))*(p0+(p2*S*S));
    c3=(p2*c)/2;
    c1effrev=-(c1/c0);
    c2effrev=-(c2/c0);
    c3effrev=-(c3/c0);
    
    %Storage vectors for Ez boundary and boundary-1 values of previous and its
    %previous timesteps
    prev_xfor=zeros(1,ydim);
    prev_x_minus_1for=zeros(1,ydim);
    prev_yfor=zeros(xdim,1);
    prev_y_minus_1for=zeros(xdim,1);
    prev_xrev=zeros(1,ydim);
    prev_x_minus_1rev=zeros(1,ydim);
    prev_yrev=zeros(xdim,1);
    prev_y_minus_1rev=zeros(xdim,1);
    
    % Update loop begins
    for n=1:1:time_tot
        
        %Vector update instead of for-loop for Hy and Hx fields
        Hx(2:xdim-3,2:ydim-3)=A(2:xdim-3,2:ydim-3).*Hx(2:xdim-3,2:ydim-3)-B(2:xdim-3,2:ydim-3).*(Ez(2:xdim-3,3:ydim-2)-Ez(2:xdim-3,2:ydim-3));
        Hy(2:xdim-3,2:ydim-3)=A(2:xdim-3,2:ydim-3).*Hy(2:xdim-3,2:ydim-3)+B(2:xdim-3,2:ydim-3).*(Ez(3:xdim-2,2:ydim-3)-Ez(2:xdim-3,2:ydim-3));
        
        %Vector update instead of for-loop for Ez field
        Ez(3:xdim-3,3:ydim-3)=C(3:xdim-3,3:ydim-3).*Ez(3:xdim-3,3:ydim-3)+(Hy(3:xdim-3,3:ydim-3)-Hy(2:xdim-4,3:ydim-3)-Hx(3:xdim-3,3:ydim-3)+Hx(3:xdim-3,2:ydim-4)).*D(3:xdim-3,3:ydim-3);
        
        %Mur's abc conditions obtained from Mur's difference equation for
        %forward boundary
        if n>1
            Ez(xdim-2,3:1:ydim-3)=c0efffor*(Ez(xdim-3,3:1:ydim-3)+prev_prev_xfor(1,3:1:ydim-3))-prev_prev_x_minus_1for(1,3:1:ydim-3)+c2efffor*(prev_xfor(1,3:1:ydim-3)+prev_x_minus_1for(1,3:1:ydim-3))+c3efffor*(prev_x_minus_1for(1,2:1:ydim-4)+prev_x_minus_1for(1,4:1:ydim-2)+prev_xfor(1,2:1:ydim-4)+prev_xfor(1,4:1:ydim-2));
        end
        
        %Storage vectors for boundary and boundary-1 values of previous and its
        %previous time steps updated at forward boundary
        prev_prev_xfor=prev_xfor;
        prev_prev_x_minus_1for=prev_x_minus_1for;
        prev_xfor(1,1:1:ydim)=Ez(xdim-2,1:1:ydim);
        prev_x_minus_1for(1,1:1:ydim)=Ez(xdim-3,1:1:ydim);
        
        %Mur's abc conditions obtained from Mur's difference equation for
        %backward boundary
        if n>1
            Ez(2,3:1:ydim-3)=-prev_prev_xrev(1,3:1:ydim-3)+c1effrev*(Ez(3,3:1:ydim-3)+prev_prev_x_minus_1rev(1,3:1:ydim-3))+c2effrev*(prev_xrev(1,3:1:ydim-3)+prev_x_minus_1rev(1,3:1:ydim-3))+c3effrev*(prev_x_minus_1rev(1,2:1:ydim-4)+prev_x_minus_1rev(1,4:1:ydim-2)+prev_xrev(1,2:1:ydim-4)+prev_xrev(1,4:1:ydim-2));
        end
        
        %Storage vectors for boundary and boundary-1 values of previous and its
        %previous time steps updated at backward boundary
        prev_prev_xrev=prev_xrev;
        prev_prev_x_minus_1rev=prev_x_minus_1rev;
        prev_xrev(1,1:1:ydim)=Ez(3,1:1:ydim);
        prev_x_minus_1rev(1,1:1:ydim)=Ez(2,1:1:ydim);
        
        %Mur's abc conditions obtained from Mur's difference equation for
        %upward boundary
        if n>1
            Ez(3:1:xdim-3,ydim-2)=c0efffor*(Ez(3:1:xdim-3,ydim-3)+prev_prev_yfor(3:1:xdim-3,1))-prev_prev_y_minus_1for(3:1:xdim-3,1)+c2efffor*(prev_yfor(3:1:xdim-3,1)+prev_y_minus_1for(3:1:xdim-3,1))+c3efffor*(prev_y_minus_1for(2:1:xdim-4,1)+prev_y_minus_1for(4:1:xdim-2,1)+prev_yfor(2:1:xdim-4,1)+prev_yfor(4:1:xdim-2,1));
        end
        
        %Storage vectors for boundary and boundary-1 values of previous and its
        %previous time steps updated at upward boundary
        prev_prev_yfor=prev_yfor;
        prev_prev_y_minus_1for=prev_y_minus_1for;
        prev_yfor(1:1:xdim,1)=Ez(1:1:xdim,ydim-2);
        prev_y_minus_1for(1:1:xdim,1)=Ez(1:1:xdim,ydim-3);
        
        %Mur's abc conditions obtained from Mur's difference equation for
        %downward boundary
        if n>1
            Ez(3:1:xdim-3,2)=-prev_prev_yrev(3:1:xdim-3,1)+c1effrev*(Ez(3:1:xdim-3,3)+prev_prev_y_minus_1rev(3:1:xdim-3,1))+c2effrev*(prev_yrev(3:1:xdim-3,1)+prev_y_minus_1rev(3:1:xdim-3,1))+c3effrev*(prev_y_minus_1rev(2:1:xdim-4,1)+prev_y_minus_1rev(4:1:xdim-2,1)+prev_yrev(2:1:xdim-4,1)+prev_yrev(4:1:xdim-2,1));
        end
        
        %Storage vectors for boundary and boundary-1 values of previous and its
        %previous time steps updated at downward boundary
        prev_prev_yrev=prev_yrev;
        prev_prev_y_minus_1rev=prev_y_minus_1rev;
        prev_yrev(1:1:xdim,1)=Ez(1:1:xdim,3);
        prev_y_minus_1rev(1:1:xdim,1)=Ez(1:1:xdim,2);
        
        %Mirroring of corner values taking the fact that corners are reached by the fields from the previous corners
        %in two time steps as S=1/sqrt(2) viz. sqrt(2)*delta(distance between two corners) is reached in 2 time steps
        Ez(2,2)=prev_prev_xrev(3);
        Ez(2,ydim-2)=prev_prev_xrev(ydim-3);
        Ez(xdim-2,2)=prev_prev_x_minus_1for(3);
        Ez(xdim-2,ydim-2)=prev_prev_x_minus_1for(ydim-3);
        
        % Source condition incorporating given free space wavelength 'wav'
        % and having a location at the left end of central waveguide just
        % at the start of missing periodic structure.
        tstart=1;
        N_lambda=wav*1e-6/delta;
        Ez(3*factor+1,15*factor+1:16*factor)=sin(((2*pi*(c/(delta*N_lambda))*(n-tstart)*deltat)));
        
        
        %Movie type colour scaled image plot of Ez
        h=imagesc(delta*(1:1:xdim)*1e+6,(1e+6*delta*(1:1:ydim))',Ez',[-1,1]);colorbar;
        set(h,'AlphaData',2*epsilon'/epsilon0);
        title(['\fontsize{20}Color-scaled image plot of Ez in photonic crystal waveguide with Mur ABC boundary and at time = ',num2str(round(n*deltat*1e+15)),' fs']);
        xlabel('x (in um)','FontSize',20);
        ylabel('y (in um)','FontSize',20);
        set(gca,'FontSize',20);
        getframe;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  