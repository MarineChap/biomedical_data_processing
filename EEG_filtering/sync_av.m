%% EX1.1. Removal of random noise by synchronized averaging 

%% Clear all previous results and load data

clear all % Clear variables
close all % Close figures
clc

load('detectiontask.mat') % Load signals
fs = 250; % Sampling frequency

% Example: Plots the full signal of electrode C3

C3 = EEGdata(5,:); %The signals of individual electrodes are stored as rows in the EEGdata matrix
tt=linspace(1/fs, length(C3)/fs, length(C3)); % Construct time signal
figure(1);
plot(tt,C3)
axis('tight');
xlabel('Time in seconds');
ylabel('Amplitude in \muV');
title('EEG channel - C3');


%% Start programming your own code here!

chan_PO7 = 59;
chan_PO8 = 60;
%% Segment the data for the UL and UR events in channels PO7 and PO8. 
%The segments (or epochs) should start 100 ms before the stimulus and 600 ms after the stimulus. 
%For each epoch, estimate and subtract the baseline, calculated using the mean of the 100ms PRE-stimulus interval.
pre_stim = 0.1*fs; 
post_stim = 0.6*fs;

for i = 1:size(S2,2)
   indice_segment = S1(i)-pre_stim:S1(i)+post_stim;
   epoch_P07_UL(i,:) = segment_data( EEGdata(chan_PO7,indice_segment), pre_stim);
   epoch_P08_UL(i,:) = segment_data(  EEGdata(chan_PO8,indice_segment), pre_stim);
  
   indice_segment_s2 = (S2(i)-pre_stim):(S2(i)+post_stim);
   epoch_P07_UR(i,:) = segment_data( EEGdata(chan_PO7,indice_segment_s2), pre_stim); 
   epoch_P08_UR(i,:) = segment_data( EEGdata(chan_PO8,indice_segment_s2), pre_stim); 
end

for i = (size(S2,2)+1):size(S1,2)
   indice_segment = S1(i)-pre_stim:S1(i)+post_stim;
   epoch_P07_UL(i,:) = segment_data( EEGdata(chan_PO7,indice_segment), pre_stim);
   epoch_P08_UL(i,:) = segment_data(  EEGdata(chan_PO8,indice_segment), pre_stim);
end

%% Calculate the template (or mean shape) for both tasks in both channels : you should obtain 4 templates in total!

template_P07_UL = sum(epoch_P07_UL, 1)./size(epoch_P07_UL, 1); 
template_P08_UL = sum(epoch_P08_UL, 1)./size(epoch_P08_UL, 1); 
template_P07_UR = sum(epoch_P07_UR, 1)./size(epoch_P07_UR, 1); 
template_P08_UR = sum(epoch_P08_UR, 1)./size(epoch_P08_UR, 1); 


%% Calculate the overal SNR for the UL and UR tasks in both channels. Show the results in a table

noise_power = compute_noise_power(epoch_P07_UL, template_P07_UL);
signal_power = compute_signal_power( noise_power, template_P07_UL, size(epoch_P07_UL,1), size(epoch_P07_UL,2) );
SNR(1,1) = signal_power/noise_power;
D(1,1) = compute_euclidian_dist( epoch_P07_UL, template_P07_UL);

noise_power = compute_noise_power(epoch_P08_UL, template_P08_UL);
signal_power = compute_signal_power( noise_power, template_P08_UL, size(epoch_P08_UL,1), size(epoch_P08_UL,2) );
SNR(2,1) = signal_power/noise_power;
D(2,1) = compute_euclidian_dist(epoch_P08_UL, template_P08_UL);

noise_power = compute_noise_power(epoch_P07_UR, template_P07_UR);
signal_power = compute_signal_power( noise_power, template_P07_UR, size(epoch_P07_UR,1), size(epoch_P07_UR,2) );
SNR(1,2) = signal_power/noise_power;
D(1,2) = compute_euclidian_dist(epoch_P07_UR, template_P07_UR);


noise_power = compute_noise_power(epoch_P08_UR, template_P08_UR);
signal_power = compute_signal_power( noise_power, template_P08_UR, size(epoch_P08_UR,1), size(epoch_P08_UR,2) );
SNR(2,2) = signal_power/noise_power;
D(2,2) = compute_euclidian_dist(epoch_P08_UR, template_P08_UR);

%% Plot the required figures (see assignment)
t = -0.1:1/fs:0.6;

L = size(t,2);
f = fs/L*(0:(L/2-1));

Delta = zeros(size(f))*NaN; 
Theta = zeros(size(f))*NaN; 
Alpha = zeros(size(f))*NaN; 
Beta = zeros(size(f))*NaN; 

figure(7); 

subplot(2,2,4)
FFT = abs(fft(template_P07_UR));
FFT = FFT(1:L/2)/L;

Delta(find(f < 4)) = FFT(find(f< 4));
Theta(find(f > 4 & f < 8)) = FFT(find(f > 4 & f < 8));
Alpha(find(f > 8 & f < 13)) = FFT(find(f > 8 & f < 13));
Beta(find(f > 13 & f < 30)) = FFT(find(f >13 & f < 30));

hold on;
bar(f, Delta, 'r');
bar(f, Theta, 'b');
bar(f, Alpha, 'g');
bar(f, Beta, 'k');
hold off;
axis([0 30 0 2])
grid on;
grid on;
legend('\delta frequencies', '\theta frequencies','\alpha frequencies','\beta frequencies');
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
title({'EEG channel - P07 in response of',' a stimulus in UR at t=0', 'ipsi-lateral side'});

subplot(2,2,1)

FFT = abs(fft(template_P08_UL));
FFT = FFT(1:L/2)/L;

Delta(find(f < 4)) = FFT(find(f< 4));
Theta(find(f > 4 & f < 8)) = FFT(find(f > 4 & f < 8));
Alpha(find(f > 8 & f < 13)) = FFT(find(f > 8 & f < 13));
Beta(find(f > 13 & f < 30)) = FFT(find(f >13 & f < 30));

hold on;
bar(f, Delta, 'r');
bar(f, Theta, 'b');
bar(f, Alpha, 'g');
bar(f, Beta, 'k');
hold off;
axis([0 30 0 2])
grid on;
legend('\delta frequencies', '\theta frequencies','\alpha frequencies','\beta frequencies');
xlabel('Frequency (Hz)');
ylabel('Average amplitude in \muV');
title({'EEG channel - P08 in response of',' a stimulus in UL at t=0','ipsi-lateral side'});


subplot(2,2,2)

FFT = abs(fft(template_P08_UR));
FFT = FFT(1:L/2)/L;

Delta(find(f < 4)) = FFT(find(f< 4));
Theta(find(f > 4 & f < 8)) = FFT(find(f > 4 & f < 8));
Alpha(find(f > 8 & f < 13)) = FFT(find(f > 8 & f < 13));
Beta(find(f > 13 & f < 30)) = FFT(find(f >13 & f < 30));

hold on;
bar(f, Delta, 'r');
bar(f, Theta, 'b');
bar(f, Alpha, 'g');
bar(f, Beta, 'k');
hold off;
axis([0 30 0 2])
grid on;
legend('\delta frequencies', '\theta frequencies','\alpha frequencies','\beta frequencies');
xlabel('Frequencies (Hz)');
ylabel('Average amplitude in \muV');
title({'EEG channel - P08 in response of',' a stimulus in UR at t=0', 'contralateral side'});

subplot(2,2,3)
FFT = abs(fft(template_P07_UL));
FFT = FFT(1:L/2)/L;

Delta(find(f < 4)) = FFT(find(f< 4));
Theta(find(f > 4 & f < 8)) = FFT(find(f > 4 & f < 8));
Alpha(find(f > 8 & f < 13)) = FFT(find(f > 8 & f < 13));
Beta(find(f > 13 & f < 30)) = FFT(find(f >13 & f < 30));

hold on;
bar(f, Delta, 'r');
bar(f, Theta, 'b');
bar(f, Alpha, 'g');
bar(f, Beta, 'k');
hold off;
axis([0 30 0 2])
grid on;
legend('\delta frequencies', '\theta frequencies','\alpha frequencies','\beta frequencies');
xlabel('Frequencies (Hz)');
ylabel('Average amplitude in \muV');
title({'EEG channel - P07 in response of',' a stimulus in UL at t=0', 'contralateral side'});


figure(2);
movegui('northwest')

subplot(2,2,1)
plot(t,template_P08_UL)
grid on;
axis([ -0.1 0.6 -15 12]);
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
title({'EEG channel - P08 in response of',' a stimulus in UL at t=0','ipsi-lateral side'});

subplot(2,2,2)
plot(t,template_P08_UR)
axis([ -0.1 0.6 -15 12]);
grid on;
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
title({'EEG channel - P08 in response of',' a stimulus in UR at t=0', 'contralateral side'});

subplot(2,2,3)
plot(t,template_P07_UL)
grid on;
axis([ -0.1 0.6 -15 12]);
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
title({'EEG channel - P07 in response of',' a stimulus in UL at t=0', 'contralateral side'});

subplot(2,2,4)
plot(t,template_P07_UR)
axis([ -0.1 0.6 -15 12]);
grid on;
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
title({'EEG channel - P07 in response of',' a stimulus in UR at t=0', 'ipsi-lateral side'});


figure(3); 
movegui('north')
plot(t,template_P07_UL,'r',t,template_P07_UR,'g',t,template_P08_UL,'b',t,template_P08_UR,'k');
grid on;
legend('template signal PO7 with the stimulus UL - contralateral side','template signal PO7 with the stimulus UR  - ipsi-lateral side',...
       'template signal PO8 with the stimulus UL - ipsi-lateral side','template signal PO8 with the stimulus UR  - contralateral side') 
axis('tight');
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
title({'EEG channel - template P08 and PO7',' in response of a stimulus in UR and UL at t=0'});

figure(4); 
movegui('south')

subplot(2,2,1)
p = plot(t,epoch_P08_UL(1:24,:),'r', t,template_P08_UL,'b');
grid on;
axis([ -0.1 0.6 -25 25]);
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
legend(p([1 25]), {'24st responses', 'Average signal'});
title({'EEG channel - P08 in response of',' a stimulus in UL at t=0','ipsi-lateral side'});


subplot(2,2,2)
p= plot(t,epoch_P08_UR(1:24,:),'r', t,template_P08_UR,'b');
grid on;
axis([ -0.1 0.6 -25 25]);
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
legend(p([1 25]), {'24st responses', 'Average signal'}); 
title({'EEG channel - P08 in response of',' a stimulus in UR at t=0',' contralateral side'});

subplot(2,2,3)
p = plot(t,epoch_P07_UL(1:24,:),'r', t,template_P07_UL,'b');
grid on;
axis([ -0.1 0.6 -25 25]);
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
legend(p([1 25]), {'24st responses', 'Average signal'}); 
title({'EEG channel - P07 in response of',' a stimulus in UL at t=0', ' contralateral side'});

subplot(2,2,4)
p = plot(t,epoch_P07_UR(1:24,:),'r',t,template_P07_UR,'b');
grid on;
axis([ -0.1 0.6 -25 25]);
xlabel('Time in seconds');
ylabel('Average amplitude in \muV');
legend(p([1 25]), {'24st responses', 'Average signal'});
title({'EEG channel - P07 in response of',' a stimulus in UR at t=0','ipsi-lateral side'});

figure(5);
movegui('northeast')
[nr,nc] = size(SNR);
ax=axes;

str1 = strcat('D(PO7,UL) =   ', num2str(D(1,1),'%.4f'));
str = strcat('SNR(PO7,UL) =   ', num2str(SNR(1,1),'%.4f'));
text(1,1,{str1,' ', '----------------', ' ',str},'horizontalalignment','center')

str1 = strcat('D(PO7,UR) =   ', num2str(D(2,1),'%.4f'));
str = strcat('SNR(PO7,UR) =   ', num2str(SNR(1,2),'%.4f'));
text(2,1,{str1,' ', '----------------', ' ',str},'horizontalalignment','center')

str1 = strcat('D(PO8,UL) =   ', num2str(D(1,2),'%.4f'));
str = strcat('SNR(PO8,UL) =   ', num2str(SNR(2,1),'%.4f'));
text(1,2,{str1,' ', '----------------', ' ',str},'horizontalalignment','center')

str1 = strcat('D(PO8,UR) =   ', num2str(D(2,2),'%.4f'));
str = strcat('SNR(PO8,UR) =   ', num2str(SNR(2,2),'%.4f'));
text(2,2,{str1,' ', '----------------', ' ',str},'horizontalalignment','center')

set(ax,'xlim',[0 nc]+.5, ...
    'ylim',[0 nr]+.5, ...
    'xtick',(0:nc)+.5, ...
    'ytick',(0:nr)+.5, ...
    'xticklabel',[],...
    'yticklabel',[],...
    'box','on', ...
    'dataaspectratio',[1 1 1],...
    'xgrid','on', ...
    'ygrid','on',...
    'gridlinestyle','-')

title('SNR and euclidian distance for the fourth signals') 

