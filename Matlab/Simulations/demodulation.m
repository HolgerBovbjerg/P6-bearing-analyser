%% Clear
clear 
close all;

%% System setup
fs = 48e3;          % Sample Rate (Hz)
fPin = 30;        % Pinion (Input) shaft frequency (Hz)

t = 0:1/fs:20-1/fs;                       
%% Bearing
n = 7;         % Number of rolling element bearings
d = 0.004;      % Diameter of rolling elements 
p = 0.015;      % Pitch diameter of bearing
thetaDeg = 0;

bpfi = n*fPin/2*(1 + d/p*cosd(thetaDeg)); % Ballpass frequency, inner race
bpfo = n*fPin/2*(1 - d/p*cosd(thetaDeg)); % Ballpass frequency, outer race
fImpact = 5000;
tImpact = 0:1/fs:5e-3-1/fs;
xImpact = 0.4*sin(2*pi*fImpact*tImpact);
AImpact = 1;
window  = kaiser(length(tImpact),40);

xImpactWindowed = xImpact.*window';

xComb = zeros(size(t));
xComb(1:round(fs/bpfi):end) = 1;
xBper = AImpact*conv(xComb,xImpactWindowed,'same');

snr = 45;
xBper = awgn(xBper,snr);

[Envupper,Envlower] = envelope(xBper);
absxBper = abs(xBper);
hilbertxBper = abs(hilbert(xBper));
prodxBper = xBper.*xBper;
EnvDemodabs = lowpass(absxBper,1000,fs);
EnvDemodHilbert = lowpass(hilbertxBper,1000,fs);
EnvDemodProd = real(sqrt(lowpass(prodxBper,1000,fs)));
%% Figure
fig1 = figure;
t1 = tiledlayout(3,1);
title(t1,'Non-coherent Full-Wave Envelope Detection')
nexttile
plot(t, xBper, t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('Bearing signal','True envelope')

nexttile
plot(t,absxBper,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('Demodulated signal','True envelope')

nexttile
plot(t,EnvDemodabs,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('After LP filtering','True envelope')

fig2 = figure;
t2 = tiledlayout(3,1);
title(t2,'Non-coherent Complex Envelope Detection')
nexttile
plot(t, xBper,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('Bearing signal','True envelope')

nexttile
plot(t,hilbertxBper,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('Demodulated signal','True envelope')

nexttile
plot(t,EnvDemodHilbert,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('After LP filtering','True envelope')

fig3 = figure;
t3 = tiledlayout(3,1);
title(t3,'Non-coherent Real Square-Law Envelope Detection')
nexttile
plot(t, xBper,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('Bearing signal','True envelope')

nexttile
plot(t,prodxBper,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('Demodulated signal','True envelope')

nexttile
plot(t,EnvDemodProd,t,Envupper)
xlim([0 5/bpfi])
xlabel('time [s]')
ylabel('acceleration [g]')
legend('After LP filtering  and square root','True envelope')

exportgraphics(fig1,'abs_demod_example.pdf','ContentType','vector')
exportgraphics(fig2,'hilbert_demod_example.pdf','ContentType','vector')
exportgraphics(fig3,'product_demod_example.pdf','ContentType','vector')
%% Combined figure
fig4 = figure;
t4 = tiledlayout(3,3);
width = 40;

% row 1
nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), xBper(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
title('Full-Wave Envelope Detection')
xlabel('Time [s]')
ylabel('acceleration [g]')
legend('True envelope','Input signal','Location', 'southeast')

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), xBper(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
title('Complex Envelope Detection')
xlabel('Time [s]')
ylabel('acceleration [g]')
legend('True envelope','Input signal','Location', 'southeast')

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), xBper(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
title('Real Square-Law Envelope Detection')
xlabel('Time [s]')
ylabel('acceleration [g]')
legend('True envelope','Input signal','Location', 'southeast')

%row 2

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), absxBper(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
xlabel('Time [s]')
ylabel('acceleration [g]')
legend('True envelope','Absolute value','Location', 'southeast')

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), hilbertxBper(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
xlabel('Time [s]')
ylabel('acceleration [g]')
legend('True envelope',['Hilbert transformed' newline '+ absolute value'],'Location', 'southeast')

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), prodxBper(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
xlabel('Time [s]')
ylabel('acceleration [g]')
legend('True envelope','Squared','Location', 'southeast')

% Row 3
nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), EnvDemodabs(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
ylabel('acceleration [g]')
xlabel('Time [s]')
legend('True envelope','LP filtered','Location', 'southeast')

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), EnvDemodHilbert(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
ylabel('acceleration [g]')
xlabel('Time [s]')
legend('True envelope','LP filtered','Location', 'southeast')

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), EnvDemodProd(floor(fs/bpfi-width):floor(fs/bpfi+width)))

xlim([1/bpfi-0.0025 1/bpfi+0.005])
xlabel('Time [s]')
ylabel('acceleration [g]')
legend('True envelope',['LP filtered' newline 'and Squareroot'],'Location', 'southeast')

%exportgraphics(fig4,'combined_demod_example_seperate.pdf','ContentType','vector')

%%
fig5 = figure;
t5 = tiledlayout(3,1);

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), xBper(floor(fs/bpfi-width):floor(fs/bpfi+width)),...
    t(floor(2*fs/bpfi-width):floor(2*fs/bpfi+width)), absxBper(floor(2*fs/bpfi-width):floor(2*fs/bpfi+width)),... 
    t(floor(3*fs/bpfi-width):floor(3*fs/bpfi+width)), EnvDemodabs(floor(3*fs/bpfi-width):floor(3*fs/bpfi+width))... 
)

xlim([1/bpfi-0.0025 4/bpfi-0.0025])
title('Non-coherent Complex Envelope Detection')
ylabel('acceleration [g]')
legend('True envelope','Input signal','Demodulated signal', 'Lowpass filtered','Location', 'bestoutside')

nexttile
plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), xBper(floor(fs/bpfi-width):floor(fs/bpfi+width)),...
    t(floor(2*fs/bpfi-width):floor(2*fs/bpfi+width)), hilbertxBper(floor(2*fs/bpfi-width):floor(2*fs/bpfi+width)),... 
    t(floor(3*fs/bpfi-width):floor(3*fs/bpfi+width)), EnvDemodHilbert(floor(3*fs/bpfi-width):floor(3*fs/bpfi+width))... 
)
xlim([1/bpfi-0.0025 4/bpfi-0.0025])
title('Non-coherent Complex Envelope Detection')
ylabel('acceleration [g]')
legend('True envelope','Input signal','Demodulated signal', 'Lowpass filtered','Location', 'bestoutside')

nexttile

plot(t,Envupper,...
    t(floor(fs/bpfi-width):floor(fs/bpfi+width)), xBper(floor(fs/bpfi-width):floor(fs/bpfi+width)),...
    t(floor(2*fs/bpfi-width):floor(2*fs/bpfi+width)), prodxBper(floor(2*fs/bpfi-width):floor(2*fs/bpfi+width)),... 
    t(floor(3*fs/bpfi-width):floor(3*fs/bpfi+width)), EnvDemodProd(floor(3*fs/bpfi-width):floor(3*fs/bpfi+width))... 
)
    
xlim([1/bpfi-0.0025 4/bpfi-0.0025])
title('Non-coherent Real Square-Law Envelope Detection')
legend('True envelope','Input signal','Demodulated signal', ['Lowpass filtered' newline 'and Squareroot'],'Location', 'bestoutside')
ylabel('acceleration [g]')

exportgraphics(fig5,'combined_demod_example.pdf','ContentType','vector')

