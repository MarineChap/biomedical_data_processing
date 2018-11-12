
clear all % Clear variables
close all % Close figures
clc

load('ecg3.mat')
ecg = ECG23; 
fs = 1000;
slen = length(ecg);
t=[1:slen]/fs;
ecg_fft = abs(fft(ecg)).^2;
f = fs/size(t,2)*(0:size(t,2)/2-1);



%% Design of the Hanning filter 
A_f1 = 4;
B_f1 = [1 2 1];
ecg_f1 = filter(B_f1,A_f1, ecg); 
ecg_f1_fft = abs(fft(ecg_f1).^2);

[H, w] = freqz(B_f1,A_f1,fs,fs);




%% Design of the derivative-based filter

% With a radius pole = 0.984
[B_f2,A_f21] = Derivative_based_filter(0.984,fs);
ecg_f21 = filter(B_f2,A_f21, ecg); 
ecg_f21_fft = abs(fft(ecg_f21)).^2;

% With a radius pole = 0.95
[B_f2,A_f22] = Derivative_based_filter(0.95,fs);
ecg_f22 = filter(B_f2,A_f22, ecg); 
ecg_f22_fft = abs(fft(ecg_f22)).^2;

% With a radius pole = 0.9
[B_f2,A_f23] = Derivative_based_filter(0.9,fs);
ecg_f23 = filter(B_f2,A_f23, ecg); 
ecg_f23_fft = abs(fft(ecg_f23)).^2;


figure(4);

subplot(211)
freqz(B_f2,A_f23,fs,fs); hold on;
freqz(B_f2,A_f22,fs,fs); hold on;
freqz(B_f2,A_f21,fs,fs);hold off;

lines_freq = findall(gcf,'type','line');

lines_freq(1).Color = 'y';
lines_freq(2).Color = 'r' ;
lines_freq(3).Color = 'b' ;
legend('R = 0.9', 'R = 0.95', 'R = 0.984');

title({'Transfer fonction of derivative-based filter',  'with 3 R radius poles differents '})

subplot(212)
phasez(B_f2,A_f23,fs,fs); hold on; 
phasez(B_f2,A_f22,fs,fs); hold on;
phasez(B_f2,A_f21,fs,fs); hold off;
legend('R = 0.9', 'R = 0.95', 'R = 0.984');

figure(5);
subplot(211);
plot(t, ecg, t, [ecg_f23 ecg_f22 ecg_f21]) 
grid on;
xlim([1.46 2.057]);
xlabel('Time (sec)');
ylabel('Amplitude (A.U)');
legend('ECG signal', 'filtered with R = 0.9','filtered with R = 0.95', 'filtered with R = 0.984');
title('Effect of the Derivative-based filter');

subplot(212);
plot(f, [20*log2(ecg_fft(1:size(t,2)/2)) 20*log2(ecg_f23_fft(1:size(t,2)/2)) 20*log2(ecg_f22_fft(1:size(t,2)/2)) 20*log2(ecg_f21_fft(1:size(t,2)/2)) ]) ;
axis('tight');
grid on;
xlabel('Frequencies (Hz)');
ylabel('Amplitude (dB)');
title('Power spectrum');
legend('ECG signal', 'filtered with R = 0.9','filtered with R = 0.95', 'filtered with R = 0.984');


%% Design the comb filter 
% Noise frequence and his harmonics to remove : 50hz - 150hZ - 250hz - 350hz - 450hz

omega= 2*pi*[ 50; 150; 250; 350; 450]/fs;

[ B_f3,A_f3 ] = Comb_filter( omega, 0);
% add a simple high pass
B_f3 =  conv(B_f3,[1 1]);
A_f3(1) = A_f3(1)*2;

ecg_f3 = filter(B_f3,A_f3, ecg); 
ecg_f3_fft = abs(fft(ecg_f3)).^2;

figure(6);
subplot(211)
[H, w] = freqz(B_f3,A_f3,fs,fs);
plot(w, 20*log(abs(H)));
axis('tight');
grid on;
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)')
subplot(212)
phasez(B_f3,A_f3,fs,fs);

title('Transfer fonction of comb filter')

figure(7);
subplot(211);
plot(t, [ecg ecg_f3]) 
axis([1.46 2.057 -300 110]);
grid on;
xlabel('Time (sec)');
ylabel('Amplitude (A.U)');
legend('ECG signal', 'ECG signal filtered');
title('Effect of the comb filter');

subplot(212);
plot(f, [20*log2(ecg_fft(1:size(t,2)/2)) 20*log2(ecg_f3_fft(1:size(t,2)/2))]) ;
axis('tight');
grid on;
xlabel('Frequencies (Hz)');
ylabel('Power Spectrum (dB)');
legend('ECG signal', 'ECG signal filtered');
title('Effect of the comb filter');

%% Design of combined filter 
B_combined = conv(conv(B_f1, B_f2), B_f3);
A_combined = conv(conv(A_f1, A_f21), A_f3);

ecg_fcombined = filter(B_combined,A_combined, ecg); 
ecg_fcombined_fft = abs(fft(ecg_fcombined)).^2;

figure(8);
subplot(211)
[H, w] =freqz(B_combined,A_combined,fs,fs);
plot(w, 20*log(abs(H)));
axis('tight');
grid on;
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
title('Magnitude Response')

subplot(212)
phasez(B_combined,A_combined,fs,fs); 

figure(9);
subplot(211);
plotyy(t, ecg, t, ecg_fcombined) 
grid on;
xlabel('Time (sec)');
ylabel('Amplitude (AU)');
legend('ECG signal', 'ECG signal filtered');
title('Effect of the 3-combined filter');

subplot(212);
plot(f, [20*log2(ecg_fft(1:size(t,2)/2)) 20*log2(ecg_fcombined_fft(1:size(t,2)/2))]) ;
axis('tight');
grid on;
xlabel('Frequencies (Hz)');
ylabel('Power spectrum (dB)');
legend('ECG signal', 'ECG signal filtered');

figure(10)
grpdelay(B_combined,A_combined,fs,fs);
title('Group delay combined filter')
