%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%     3.2     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear 
clc
% Initializing parameters

load('ExerciseData.mat')        ;   % loading the ECGsignal
fs      = 200 ;   % Sampling frequency
ecg = ecg(70*fs : 210*fs);
ecg = (ecg - mean(ecg))/std(ecg);
t    = (0:length(ecg)-1)/fs  ;   % Creating a Time Vector

%% Pan-Tompkins algorithm
% Complete the implementation of the Pan-Tompkins algorithm. Use the test
% signal to design the algorithm. Then, apply the method in the signals
% from the patients.
% Low-pass Filter
close all
B_lp_1 = [1 zeros(1,5) -2 zeros(1,5) 1]/32;
A_lp_1 = [1 -2 1];
ecg_lp = filter(B_lp_1,A_lp_1,ecg);

% High-Pass Filter

B_lp_2 = [1 zeros(1,31) -1];
A_lp_2 = [1 -1];
ecg_lp_2 = filter(B_lp_2,A_lp_2,ecg_lp);

ecg_lp_ex = [zeros(16,1); ecg_lp];
ecg_hp = ecg_lp_ex(1:end-16)-ecg_lp_2/32;

% Derivative
% implement the derivative filter of the Pan-Tomkins algorithm

B_d = [2 1 0 -1 -2]; 
A_d = [8 0 0 0 0]; 
ecg_d = filter(B_d,A_d,ecg_lp_2);

% Squaring
% implement the squaring step in the Pan-Tomkins algorithm

ecg_square = ecg_d.^2;

% Integration
% implement the integration step in the Pan-Tomkins algorithm
B_int = ones(1,30);
A_int = [30 zeros(1,29)];
ecg_int = filter(B_int,A_int,ecg_square);

% Detect initial peaks

pos_top = find(ecg_int>0.5*max(ecg_int));

% Searchback procedure and adaptive thresholding. Correct for delays if
% needed. Use the provided function searchback.mat provided in toledo.
Rpos=searchback(pos_top,ecg_int,fs);

figure(8);
subplot(511); 
plot(t,ecg_clean);
xlim([16,18]);
subplot(512);
plot(t,ecg_hp);
xlim([16,18]);
subplot(513);
plot(t,ecg_d);
xlim([16,18]);
subplot(514);
plot(t,ecg_square);
xlim([16,18]);
subplot(515);
hold on;
plot(t, ecg, t, ecg_int);
stem(t(Rpos), ecg_int(Rpos));
hold off;
xlim([16,18]);


%%
%   Detecting Rpeaks in the patients. Insert a piece of code to detect the
%   R-peaks in the signals from the patients.



%% Detection of the Dichrotic notch
% Implement a piece of code to detect the Dicrotic notch in the signals In
% this section.


%% Figure 1.1
% A figure showing the steps to segment the PCG signals on its sistolic and
% diastolic parts. See figure 4.30 in the textbook. The same figure should
% be shown here. Do this for patient one here

figure

subplot 511                 


legend('PCG signal','QRS complex location','Dicrotic notch location')
ylabel('PCG')
axis tight;


subplot 512                 


legend('ECG','R-peaks')
ylabel('ECG')
axis tight;

subplot 513                 


ylabel('Integral')
legend('Integrated','Detected events')
axis tight;


subplot 514                 %Plot the estimations using a Hanning window


ylabel('Carotid')
legend('Carotid','Dicrotich notch')
axis tight;


subplot 515                 %Plot the estimations using a Hanning window

title('Squared of second derivative')
legend('Signal','Detected events')
axis tight;
ylim([0 10])
suptitle('Patient 1')


%% Figure 1.2
% A figure showing the steps to segment the PCG signals on its sistolic and
% diastolic parts. See figure 4.30 in the textbook. The same figure should
% be shown here. Do this for patient two here

figure

subplot 511                 

legend('PCG signal','QRS complex location','Dicrotic notch location')
ylabel('PCG')
axis tight;

subplot 512                 

legend('ECG','R-peaks')
ylabel('ECG')
axis tight;

subplot 513                 

ylabel('Integral')
legend('Integrated','Detected events')
axis tight;

subplot 514                 %Plot the estimations using a Hanning window

ylabel('Carotid')
legend('Carotid','Dicrotich notch')
axis tight;


subplot 515                 %Plot the estimations using a Hanning window

title('Squared of second derivative')
legend('Signal','Detected events')
axis tight;
ylim([0 10])
suptitle('Patient 2')


%% Figure 2
% A figure of the ECG signals with the detected R-peaks and the
% corresponding tachogram for the signal ECG_test
figure
subplot 211

title('ECG signal and detected R-peaks')
legend('ECG signal','R-peaks')

subplot 211

title('Tachogram')
suptitle('Computation of the tachogram in the test signal')