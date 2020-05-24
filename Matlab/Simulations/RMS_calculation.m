%% Clear
clear 
close all

%% Import data
dataInner = load(fullfile('MFPT Fault Data Sets\4 - Seven Inner Race Fault Conditions\InnerRaceFault_vload_1.mat'));
dataNoFault = load(fullfile('MFPT Fault Data Sets\1 - Three Baseline Conditions\baseline_3.mat'));
% Data from faulty inner bearing
xInner = dataInner.bearing.gs;
xNoFault = dataNoFault.bearing.gs;

% Sampling rate
Fs1 = dataInner.bearing.sr;
Fs2 = dataNoFault.bearing.sr;
% Time vector
t1 = (0:length(xInner)-1)/Fs1;
t2 = (0:length(xNoFault)-1)/Fs2;

%% Calculate RMS

%xInner = lowpass(xInner, 400, Fs1);

xInnerRMS = zeros(length(xInner),1);
xNoFaultRMS = zeros(length(xNoFault),1);

N=10000;

for i=(1:(length(xInner)-N))
    xInnerRMS(i) = sqrt(mean(xInner(i:i+N).^2));
    xNoFaultRMS(i) = sqrt(mean(xNoFault(i:i+N).^2));
end

plot(t1, xInnerRMS, t2, xNoFaultRMS)
xlabel('Time [s]')
ylabel('Acceleration_{RMS} [g]')
legend('Bearing w. fault on inner ring','Non faulty bearing')
xlim([0 1])
