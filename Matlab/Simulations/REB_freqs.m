%% Clear
clear
close all

%% REB freqs
rpmPin = (2000:3700);        % Pinion (Input) shaft frequency (Hz)
fPin = rpmPin./60;
n = 7;         % Number of rolling element bearings
d = 0.004;      % Diameter of rolling elements 
p = 0.015;      % Pitch diameter of bearing
thetaDeg = 0;

bpfi = round(n*fPin/2*(1 + d/p*cosd(thetaDeg))); % Ballpass frequency, inner race
bpfo = round(n*fPin/2*(1 - d/p*cosd(thetaDeg))); % Ballpass frequency, outer race


%% Export
fileID = fopen('freqPin.txt','w');
for i = 1:length(fPin)
    fprintf(fileID,'%d',fPin(1,i));
    if mod(i,20) == 0
        fprintf(fileID,',\n');
    else
        fprintf(fileID,', ');
    end
end
fclose(fileID);

fileID = fopen('rpmPin.txt','w');
for i = 1:length(rpmPin)
    fprintf(fileID,'%d',rpmPin(1,i));
    if mod(i,20) == 0
        fprintf(fileID,',\n');
    else
        fprintf(fileID,', ');
    end
end
fclose(fileID);

fileID = fopen('bpfi.txt','w');
for i = 1:length(bpfi)
    fprintf(fileID,'%d',bpfi(1,i));
    if mod(i,20) == 0
        fprintf(fileID,',\n');
    else
        fprintf(fileID,', ');
    end
end
fclose(fileID);

fileID = fopen('bpfo.txt','w');
for i = 1:length(bpfo)
    fprintf(fileID,'%d',bpfo(1,i));
    if mod(i,20) == 0
        fprintf(fileID,',\n');
    else
        fprintf(fileID,', ');
    end
end
fclose(fileID);