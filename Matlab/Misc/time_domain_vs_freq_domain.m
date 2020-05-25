clear 

Fs = 200e3;
T = 1/Fs;
N=1000;
t = (0:N-1)*T;
f = (0:N/2-1)*Fs;

f1 = 3e3;
f2 = 5e3;
f3 = 1e3;
f4 = 8e3;


sig = 0.5*sin(2*pi*f1*t+0.5*pi)+0.4*sin(2*pi*f2*t-0.2)+ ...
    1*sin(2*pi*f3*t+0.7)+0.2*sin(2*pi*f4*t-0.3);
P = abs(fft(sig))./N;

fig = figure(1);
tl = tiledlayout(2,1,'TileSpacing','Compact');
ylabel(tl,'Amplitude')

% Tile 1
nexttile
plot(t,sig, 'color', '#0047ab')
title('Time domain signal')
xlabel('Time [s]')
% Tile 2
nexttile
stem(f(1:N/20),2*P(1:N/20), 'color','#228B22')
title('Frequency domain signal')
xlabel('Frequency [Hz]')

exportgraphics(fig,'time_vs_freq_domain.pdf','ContentType','vector')