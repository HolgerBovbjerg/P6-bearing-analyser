%% Clear
clear 
close all;

%% Filter requirements
Fs = 48e3; % Sampling frequency [Hz]
fstop = 800; % Stopband frequency [Hz]
fpass = 1000; % Passband frequency [Hz]
As = 85; %  Desired stopband attenuation[dB]

%% Filter design
Fc = 1000 % Filter cutoff frequency;
order = 120 % Filter order (Determines steepness of cutoff);
win = blackman(order+1); % Generates Blackman window 
flag = 'scale';  % Flag that tells the fir1 function to normalize the coefficients
b  = fir1(order, Fc/(Fs/2), 'high', win, flag); % Generate FIR coefficients
q = 15; % Q15-format
b_fixed_point = round(bitsll(b,q)); % Scale and round to integer

fvtool(b,1, b_fixed_point./2^q,1)

Hd = dfilt.dffir(b);
% Set the arithmetic property.
set(Hd, 'Arithmetic', 'fixed', ...
    'CoeffWordLength', 16, ...
    'CoeffAutoScale', true, ...
    'Signed',         true, ...
    'InputWordLength', 16, ...
    'inputFracLength', 15, ...
    'FilterInternals',  'FullPrecision');
denormalize(Hd);

fvtool(Hd);

%fcfwrite(Hd,'FIR_HP_1000Hz.fcf');