%% clear
clear
clear figures

%% Setup
Fs = 48e3;
fShaft = (0:3700)/60;        % Pinion bearing shaft frequency (Hz)
t = 0:1/Fs:20-1/Fs;

%% Bearing
n = 7;         % Number of rolling element bearings
d = 0.004;      % Diameter of rolling elements 
p = 0.015;      % Pitch diameter of bearing
thetaDeg = (0:89); % Contact angle in degrees

bpfi = fShaft'*(n/2*(1 + d/p*cosd(thetaDeg))); % Ballpass frequency, inner race
bpfo = fShaft'*(n/2*(1-d/p*cosd(thetaDeg))); % Ballpass frequency, outer race
bsf = fShaft'*(p/d*(1 - (d/p*cosd(thetaDeg)).^2)); % Ball spin frequency
ftf = fShaft'*(1/2*(1-d/p*cosd(thetaDeg))); % Fundamental train frequency

%% DFT length
%BPFO and BPFI
L = Fs.*(1./fShaft).*(15/21);

%% Figures
fig1 = figure(1);
%ax = tiledlayout(1,2);
%nexttile
plot(fShaft, bpfi(:,1), fShaft, bpfo(:,1), '-.', fShaft, bsf(:,1),'--', fShaft, ftf(:,1),':');

grid on
legend('BPFI', 'BPFO', 'BSF', 'FTF', 'Location', 'Best');
xlabel('Shaft Frequency [Hz]');
ylabel('Characteristic Frequency [Hz]');
title(['n= 7, d = 4 mm, D = 15 mm, \phi = 0' char(176)])
xlim([0 61])

%nexttile
% plot(fShaft, bpfi(:,1)./ftf(:,1), fShaft, bpfi(:,1)./bsf(:,1), fShaft, bpfi(:,1)./bpfo(:,1))
% xlabel(['Ratio'])
% ylabel('Shaft frequency [Hz]')
% legend('BPFI/FTF','BPFI/BSF','BPFI/BPFO', 'Location', 'Best')
% grid on
exportgraphics(fig1,'bearing_characteristic_frequencies.pdf','ContentType','vector')

figure(2)
surf(thetaDeg,fShaft,bpfi,'EdgeColor', 'none', 'FaceColor', 'r')
hold on
surf(thetaDeg,fShaft,bpfo,'EdgeColor', 'none', 'FaceColor', 'g')
surf(thetaDeg,fShaft,ftf,'EdgeColor', 'none', 'FaceColor', 'b')
surf(thetaDeg,fShaft,bsf,'EdgeColor', 'none', 'FaceColor', 'y')
    
xlabel(['Angle [' char(176) ']'])
ylabel('Shaft frequency [Hz]')
zlabel('Characteristic frequency [Hz]')
legend('BPFI','BPFO','FTF','BSF')

figure(3)
plot(fShaft,log2(L))
xlim([1 60])
%ylim([min(L) 2^12])
grid on
title('Minimum DFT input length')
ylabel('log_2(L)')
xlabel('Shaft frequency [Hz]')
