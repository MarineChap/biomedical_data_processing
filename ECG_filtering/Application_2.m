%% EX1.2. Rejection of power-line interference from ECG signals
% Read all comments before starting the exercise
% Make sure your data files are in the same folder as your code

%% Clear all previous results and load data

clear all % Clear variables
close all % Close figures
clc

load('ecg2.mat')
ecg = (val(2,:)-mean(val(2,:)))/std(val(2,:)); 
resp = (val(1,:)-mean(val(1,:)))/std(val(1,:));
fs = 250;

% Example : plot of the original ECG and respiration signal

slen = length(ecg);
t=[1:slen]/fs;


% Plot the power spectrum of the original signal to verify which notch
% filter you need : you can use the function fft() to calculate the power
% spectrum of the ECG signal

ecg_fft = abs(fft(ecg).^2);
f = fs/size(t,2)*(0:size(t,2)/2-1);


%% Design the notch filter and apply it to the ECG signal. Observe the effect in the time and frequency domain

% omega

omega = 2*pi*[60;70;120]/fs;
[B0, A0]=Comb_filter(omega,0);
ecg_f0= filter(B0, A0, ecg); 
ecg_f0_fft = abs((fft(ecg_f0).^2));

%% Introduce poles in the notch filter. Try at least 3 values between 0.8 and 0.99 and study the effect. Which filter gives the best result

r1=0.8;
[B1, A1]=Comb_filter(omega,r1);
ecg_f1 = filter(B1,A1, ecg);
ecg_f1_fft = abs(fft(ecg_f1).^2);

r2=0.9;
[B2, A2]=Comb_filter(omega,r2);
ecg_f2 = filter(B2,A2, ecg);
ecg_f2_fft = abs(fft(ecg_f2).^2);

r3=0.99;
[B3, A3]=Comb_filter(omega,r3);
ecg_f3 = filter(B3,A3, ecg);
ecg_f3_fft = abs(fft(ecg_f3).^2);

%% Apply the filter to the provided respiration signal.

% Remove base-line drift with a Hanning filter 

resp_f = filter(B3,A3, resp);

B4 =  conv(B3,[1 -1]);
ecg_f = filter(B4,A3, ecg);


%% Plot figures

figure(1);
movegui('northwest')
plot(f, [20*log2(ecg_fft(1:size(t,2)/2)); 20*log2(ecg_f0_fft(1:size(t,2)/2)); 20*log2(ecg_f1_fft(1:size(t,2)/2)); 20*log2(ecg_f2_fft(1:size(t,2)/2)); 20*log2(ecg_f3_fft(1:size(t,2)/2))]) 
grid on;
axis('tight');
xlabel('Frequencies (Hz)')
ylabel('Power spectrum (dB)');
legend('ECG', ' ECG filtered without poles', 'ECG filtered with R=0.8', 'ECG filtered with R=0.9', 'ECG filtered with R=0.99');
title('Power spectrum of ECG with and without comb filters');


figure(2) 
movegui('northeast')
subplot(211)
freqz(B0,A0);hold on;
freqz(B1,A1); hold on;
freqz(B2,A2); hold on;
freqz(B3,A3); hold off;
lines_freq = findall(gcf,'type','line');

lines_freq(1).Color = 'k';
lines_freq(2).Color = 'y' ;
lines_freq(3).Color = 'r' ;
lines_freq(4).Color = 'b' ;
legend('without poles', 'R = 0.8', 'R = 0.9', 'R = 0.99');
title({'Transfer fonction of notch filter',  'with R radius poles differents '})

subplot(212)
phasez(B0,A0);hold on;
phasez(B1,A1); hold on;
phasez(B2,A2); hold on;
phasez(B3,A3); hold off; 
legend('without poles', 'R = 0.8', 'R = 0.9', 'R = 0.99');

figure(3);
movegui('southwest')
subplot(121);
plot(t,ecg);
xlim([4.6 7]);
grid on;
xlabel('Time (sec)');
ylabel('Amplitude (a.u.)');
title('Noisy ECG');

subplot(122);
plot(t, [ecg_f0; ecg_f1; ecg_f2; ecg_f3]);
xlim([4.6 7]);
grid on;
xlabel('Time (sec)');
ylabel('Amplitude (a.u.)');
legend('ECG signal filtred without poles','ECG signal filtred R = 0.8', 'ECG signal filtred R = 0.9', 'ECG signal filtred R = 0.99');
title('ECG filtered');


figure(4);
subplot(221);
plot(t,ecg);
xlim([4.6 7]);
grid on;
xlabel('Time (sec)');
ylabel('Amplitude (a.u.)');
title('Noisy ECG');

subplot(222);
plot(t, ecg_f)
xlim([4.6 7]);
grid on;
xlabel('Time (sec)');
ylabel('Amplitude (a.u.)');
title('ECG filtered');

subplot(223);
plot(t,resp)
grid on;

xlabel('Time (sec)');
ylabel('Amplitude (a.u.)');
title('Noisy respiration signal');

subplot(224);
plot(t,resp_f)
grid on;
xlabel('Time (sec)');
ylabel('Amplitude (a.u.)');
title('Noisy respiration signal');


