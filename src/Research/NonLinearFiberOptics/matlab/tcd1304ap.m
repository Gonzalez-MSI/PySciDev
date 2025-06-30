%  Main settings
% In this section we are defining the CCD size (i.e. the number of pixels) and the format of
% commands that will be sent to the Nucleo STM32F401RE via UART

CCDsize=3694;
fM = 1; % [MHz] Master clock frequency (fM). Please note that fM in precompiled binary 
        % is 2.0 MHz. Refer to https://tcd1304.wordpress.com/command-line-interface/

%-- Key ---------------------
command = uint8(zeros(1,12));
command(1)=69;
command(2)=82;
command(11)=1;
%-- Shift Gate SH -----------
SH_MSB = 3;
SH_1 = 4;
SH_2 = 5;
SH_LSB = 6;
%-- Integration Clear Gate ICG
ICG_MSB = 7;
ICG_1 = 8;
ICG_2 = 9;
ICG_LSB = 10;
%-- AVG ---------------------
AVG_1 = 11;
AVG_2 = 12;


% Connect to serial port
% The command "instrfind" can be used to verify which COM port is used to 
% communicate with the Nucleo Board. In this example we are connecting to the
% Nucleo board using COM4 with a baud rate of 115200.
% By default, the serial object created in matlab has a Rx and Tx buffer of
% 512 byte, therefore we will modify the buffersize in order to receive a 
% full read of TCD1304ap.
% instrhwinfo('serial') % list all serial port available
instrfind
s1 = serial('COM4','BaudRate',115200,'DataBits',8);
s1.InputBufferSize = 2*CCDsize;

% Define SH and ICG time
% In this exapmple we will use a SH period of 100 microseconds and an ICG
% period of 2 seconds. The CCD will run on electronic shutter mode.
% Refer to https://tcd1304.wordpress.com/command-line-interface/

SH_Period = 100; % [microseconds]
ICG_Period = 2000000; % [microseconds]
n_AVG = 1; % [number of reading to be averaged]

% Set number of reading to average
command(12)=uint8(n_AVG);

% Convert 32 bit data to sequence of 8 bit data
SH_Period_Bin = dec2bin(SH_Period/fM,32); % divide SH_period by fM
command(SH_MSB)=bin2dec(SH_Period_Bin(1:8));
command(SH_1)=bin2dec(SH_Period_Bin(9:16));
command(SH_2)=bin2dec(SH_Period_Bin(17:24));
command(SH_LSB)=bin2dec(SH_Period_Bin(25:32));

ICG_Period_Bin = dec2bin(ICG_Period/fM,32); % divide ICG_period by fM
command(ICG_MSB)=bin2dec(ICG_Period_Bin(1:8));
command(ICG_1)=bin2dec(ICG_Period_Bin(9:16));
command(ICG_2)=bin2dec(ICG_Period_Bin(17:24));
command(ICG_LSB)=bin2dec(ICG_Period_Bin(25:32));

%% Acquire data from Nucleo board

fopen(s1); % Open serial port
fwrite(s1,command); % Send request
A = fread(s1); % Acquire data from serial port
fclose(s1); % Close serial port

evens=mod(1:length(A),2); % Convert couple of bytes to 16-bit data
B=bitshift(A(evens==0),8)+A(evens==1);

%% Plot data
plot(1:length(B),B(:))
% Adjust plot
xlim([0 3600]);
ylim([32 32+3648]);
title('TCD1304ap data')
xlabel('Channel number')
ylabel('Intensity (AU)')
