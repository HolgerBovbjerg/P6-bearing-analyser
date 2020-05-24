clear 

Fs = 1000;
T = 1/Fs;
N = 1000;
t = (0:1/Fs:N-1);
f = (0:N/2-1)*Fs;

sig = chirp(t,100,t(end),150);
sig(floor(length(sig)/2):end) = sin(2*pi*100*t(floor(length(sig)/2):end)); 
sig = sig + 0.01*randn(size(t));
sig = sig + sin(2*pi*50*t);
idx = floor(length(sig)/6);
sig(1:idx) = sig(1:idx) + 0.15*cos(2*pi*t(1:idx)*170);


fig = figure(1);
tiledlayout(2,1,'TileSpacing','Compact');
nexttile
pspectrum(sig,Fs,'spectrogram', ...
    'FrequencyLimits',[30 200],'TimeResolution',0.5)
hold on
nexttile
pspectrum(sig,Fs,'spectrogram', ...
    'FrequencyLimits',[30 200],'FrequencyResolution',0.5)

exportgraphics(fig,'spectrogram_example.pdf','ContentType','vector')