%% Clear
clear 
close all;

%% System setup
fs = 48e3;          % Sample Rate (Hz)
fPin = 30;        % Pinion (Input) shaft frequency (Hz)

t = (0:2^13-1)*1/fs;     
f = (0:length(t)-1)*fs/length(t);
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

snr = 30;
xBper_noisy = awgn(xBper,snr);

absxBper = abs(xBper_noisy);
EnvDemodabs = lowpass(absxBper,1000,fs);
EnvDemodDecimated = zeros(1,2^10);
for i = 1:2^10
        EnvDemodDecimated(i) = EnvDemodabs(i*2^3);
end
fs_decimated = fs/2^3;
t_decimated = (0:2^10-1)*1/fs_decimated;
f_decimated = (0:length(t_decimated)-1)*fs_decimated/length(t_decimated);

figure
ax1 = tiledlayout(2,2);
nexttile
stem(f,2*abs(fft(EnvDemodabs))/2^13)
xlim([0 fs/2])
nexttile
stem(f,2*abs(fft(EnvDemodabs))/2^13)
xlim([0 1e3])
nexttile
stem(f_decimated,2*abs(fft(EnvDemodDecimated))/2^10)
xlim([0 fs_decimated/2])
nexttile
stem(f_decimated,2*abs(fft(EnvDemodDecimated))/2^10)
xlim([0 1e3])
