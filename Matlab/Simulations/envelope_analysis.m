%% Clear
clear
close all
%% Import data
dataInner = load(fullfile('MFPT Fault Data Sets\4 - Seven Inner Race Fault Conditions\InnerRaceFault_vload_1.mat'));
dataNoFault = load(fullfile('MFPT Fault Data Sets\1 - Three Baseline Conditions\baseline_1.mat'));
% Data from faulty inner bearing
xInner = dataInner.bearing.gs;
xNoFault = dataNoFault.bearing.gs;
% Sampling rate
Fs1 = dataInner.bearing.sr;
Fs2 = dataNoFault.bearing.sr;
% Time vector
t1 = (0:length(xInner)-1)/Fs1;
t2 = (0:length(xNoFault)-1)/Fs2;
%xInner = xInner + awgn(20*sin(2*pi*20*t1'),25,'measured');

%% Plot raw data 
ax1 = tiledlayout(2,1);
figure(1)
nexttile
% Time domain
plot(t1, xInner, t2, xNoFault)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('Raw Signal time signal')
xlim([0 0.1])
legend('Bearing w. fault on inner ring','Non faulty bearing')

nexttile
% Frequency domain
[pInner,fpInner] = pspectrum(xInner, Fs1);
[pNoFault,fpNoFault] = pspectrum(xNoFault, Fs2);
plot(fpInner, pow2db(pInner),fpNoFault, pow2db(pNoFault))
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('Raw Signal Power Spectrum')
legend('Bearing w. fault on inner ring','Non faulty bearing')
xlim([0 20e3])

%% Plot power sepctrum and BPFI comblines
% Ball pass frequency found from time series data
BPFI = 118.875; % [Hz]  

figure(2)
plot(fpInner, pow2db(pInner))
ncomb = 10; % Number of comblines
helperPlotCombs(ncomb, BPFI) % Matlab function to plot comblines
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('Raw Signal: Inner Race Fault')
legend('Power Spectrum', 'BPFI Harmonics')
xlim([0 1000])

%% High pass filter data
xInnerHPfiltered = highpass(xInner,1000,Fs1);
xNoFaultHPfiltered = highpass(xNoFault,1000,Fs2);

figure(3)
ax2 = tiledlayout(2,1);
nexttile
plot(t1,xInnerHPfiltered, t2, xNoFaultHPfiltered)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('High pass filtered Signal')
legend('Bearing w. fault on inner ring','Non faulty bearing')
xlim([0 0.1])

nexttile
[pInnerHP,fpInnerHP ] = pspectrum(xInnerHPfiltered, Fs1);
[pNoFaultHP,fpNoFaultHP] = pspectrum(xNoFaultHPfiltered, Fs2);
plot(fpInnerHP, pow2db(pInnerHP), fpNoFaultHP, pow2db(pNoFaultHP))
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('High pass filtered Signal Power Spectrum')
legend('Bearing w. fault on inner ring','Non faulty bearing')
xlim([100 20000])

%% Demodulate
xInnerDemod = abs(hilbert(xInnerHPfiltered));
xNoFaultDemod = abs(hilbert(xNoFaultHPfiltered));

figure(4)
ax3 = tiledlayout(2,1);
nexttile
plot(t1,xInnerDemod,t2,xNoFaultDemod)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('Demodulated Signal')
xlim([0 0.1])

nexttile
[pInnerDemod,fpInnerDemod ] = pspectrum(xInnerDemod, Fs1);
[pNoFaultDemod,fpNoFaultDemod] = pspectrum(xNoFaultDemod, Fs2);
plot(fpInnerDemod, pow2db(pInnerDemod), fpNoFaultDemod, pow2db(pNoFaultDemod))
helperPlotCombs(ncomb, BPFI) % Matlab function to plot comblines
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('Demodulated Signal Power Spectrum')
legend('Bearing w. fault on inner ring','Non faulty bearing')
xlim([0 8000])

%% Low pass filter data
xInnerLPfiltered = lowpass(xInnerDemod,500,Fs1);
xNoFaultLPfiltered = lowpass(xNoFaultDemod,500,Fs2);
figure(5)
ax4 = tiledlayout(2,1);
nexttile
plot(t1,xInnerLPfiltered, t2, xNoFaultLPfiltered)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('Low pass filtered Signal')
legend('Bearing w. fault on inner ring','Non faulty bearing')
xlim([0 0.1])

nexttile
[pInnerLP,fpInnerLP ] = pspectrum(xInnerLPfiltered, Fs1);
[pNoFaultLP,fpNoFaultLP ] = pspectrum(xNoFaultLPfiltered, Fs2);
plot(fpInnerLP, pow2db(pInnerLP),fpNoFaultLP, pow2db(pNoFaultLP))
helperPlotCombs(ncomb, BPFI) % Matlab function to plot comblines
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('Low pass filtered Signal Power Spectrum')
legend('Bearing w. fault on inner ring','Non faulty bearing')
xlim([0 1400])
ylim([-30 5])

%% Combined plot for faulty bearing
figure(6)
ax5 = tiledlayout(4,2);

% Raw
nexttile
plot(t1, xInner)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('Raw Signal: Inner Race Fault')
xlim([0 0.1])

nexttile
% Frequency domain
[pInner,fpInner ] = pspectrum(xInner, Fs1);
plot(fpInner, pow2db(pInner))
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('Raw Signal: Inner Race Fault')
legend('Power Spectrum')

% HP filtered
nexttile
plot(t1,xInnerHPfiltered)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('High pass filtered Signal: Inner Race Fault')
xlim([0 0.1])

nexttile
[pInnerHP,fpInnerHP ] = pspectrum(xInnerHPfiltered, Fs1);
plot(fpInnerHP, pow2db(pInnerHP))
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('High pass filtered Signal: Inner Race Fault')
legend('Power Spectrum')
xlim([100 20000])

% Demodulated
nexttile
plot(t1,xInnerDemod)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('Demodulated Signal: Inner Race Fault')
xlim([0 0.1])

nexttile
[pInnerDemod,fpInnerDemod ] = pspectrum(xInnerDemod, Fs1);
plot(fpInnerDemod, pow2db(pInnerDemod))
helperPlotCombs(ncomb, BPFI) % Matlab function to plot comblines
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('Demodulated Signal: Inner Race Fault')
legend('Power Spectrum')
xlim([0 8000])

% LP filtered
nexttile
plot(t1,xInnerLPfiltered)
xlabel('Time, (s)')
ylabel('Acceleration (g)')
title('Low pass filtered Signal: Inner Race Fault')
xlim([0 0.1])

nexttile
[pInnerLP,fpInnerLP ] = pspectrum(xInnerLPfiltered, Fs1);
plot(fpInnerLP, pow2db(pInnerLP))
helperPlotCombs(ncomb, BPFI) % Matlab function to plot comblines
xlabel('Frequency [Hz]')
ylabel('Power Spectrum [dB]')
title('Low pass filtered Signal: Inner Race Fault')
legend('Power Spectrum')
xlim([0 1400])
ylim([-30 5])


%% Spectrogram of envelope
% Highpass to remove DC-bias
[psp,fsp,tsp] = pspectrum(highpass(xInnerLPfiltered,50,Fs1), Fs1,'spectrogram',...
    'FrequencyResolution', 12,'FrequencyLimits',[0 600]);
figure(7)
waterfall(fsp,tsp,psp')
title('Envelope spectrogram')
xlabel('Frequency (Hz)')
ylabel('Time (seconds)')
view([30 45])