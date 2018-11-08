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

Rpos = Pan_tompkins( ecg,fs );


%%
%   Detecting Rpeaks in the patients. Insert a piece of code to detect the
%   R-peaks in the signals from the patients.
close all; 

[B_f2,A_f2] = Derivative_based_filter(0.984,fs);
ECG_1 = (ECG_1 - mean(ECG_1))/std(ECG_1);
ECG_1 = filter(B_f2,A_f2, ECG_1); 

ECG_1_ds = ECG_1((1:5:length(ECG_1)-1));
Rpos_1 = Pan_tompkins( ECG_1_ds,fs );

t = (0:length(ECG_1_ds)-1)/fs;
figure;
hold on;
plot(t,ECG_1_ds);
stem(t(Rpos_1),ECG_1_ds(Rpos_1));
hold off;
legend('ECG','R-peaks')
ylabel('ECG')
axis tight;


index_2 = 0.89*1000:17.23*1000;
ECG_2 = ECG_2(index_2);
ECG_2 = (ECG_2 - mean(ECG_2))/std(ECG_2);
ECG_2_ds = ECG_2((1:5:length(ECG_2)-1));

Rpos_2 = Pan_tompkins( ECG_2_ds,fs );


%% Detection of the Dichrotic notch
% Implement a piece of code to detect the Dicrotic notch in the signals In
% this section.

PCG_2 =PCG_2(index_2);
%% Figure 1.1
% A figure showing the steps to segment the PCG signals on its sistolic and
% diastolic parts. See figure 4.30 in the textbook. The same figure should
% be shown here. Do this for patient one here
t1 = (0:length(PCG_1)-1)/1000;
figure

subplot 511                 

plot(t1, PCG_1)
legend('PCG signal','QRS complex location','Dicrotic notch location')
ylabel('PCG')
axis tight;


subplot 512                 
hold on;
plot(t1, ECG_1);
stem(t1(Rpos_1*1000/250),ECG_1(Rpos_1*1000/250));
hold off;
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
t2 = (0:length(PCG_2)-1)/1000;
figure

subplot 511                 

plot(t2, PCG_2)
legend('PCG signal','QRS complex location','Dicrotic notch location')
ylabel('PCG')
axis tight;

subplot 512   
hold on;
plot(t2, ECG_2);
stem(t2(Rpos_2*1000/250),ECG_2(Rpos_2*1000/250));
hold off;
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