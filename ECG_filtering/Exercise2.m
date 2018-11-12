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

[ecg_int,Rpos ] = Pan_tompkins( ecg,fs );

for i = 2:length(Rpos)
    tach(i-1)=Rpos(i)-Rpos(i-1);
end
%%
%   Detecting Rpeaks in the patients. Insert a piece of code to detect the
%   R-peaks in the signals from the patients.
index_1 = 0.3*1000:length(ECG_1);
ECG_1 = ECG_1(index_1);
[B_f2,A_f2] = Derivative_based_filter(0.984,fs);
ECG_1 = (ECG_1 - mean(ECG_1))/std(ECG_1);
ECG_1 = filter(B_f2,A_f2, ECG_1); 

ECG_1_ds = ECG_1((1:5:length(ECG_1)-1));
[ ECG_1_int,Rpos_1 ] = Pan_tompkins( ECG_1_ds,fs );

index_2 = 1.89*1000:17.23*1000;
ECG_2 = ECG_2(index_2);
ECG_2 = (ECG_2 - mean(ECG_2))/std(ECG_2);
ECG_2_ds = ECG_2((1:5:length(ECG_2)-1));

[ ECG_2_int,Rpos_2 ] = Pan_tompkins( ECG_2_ds,fs );
%% Detection of the Dichrotic notch
% Implement a piece of code to detect the Dicrotic notch in the signals In
% this section.
Carotid_1 = Carotid_1(index_1);
Carotid_1 = (Carotid_1 - mean(Carotid_1))/std(Carotid_1);
[ s1_up, Npos1   ]  = detection_dicrotic_notch(Carotid_1, 1000);
for i = 1: length(Npos1)-1
    if sum(Npos1(i) == Npos1(i+1)-[0:60]) ==1
        Npos1(i+1) = Npos1(i);
    end
    index = Npos1(i)-20:Npos1(i)+20;
    sign = Carotid_1*NaN; 
    sign(index) = Carotid_1(index);
    [a, Npos1(i)  ] =min(sign);
end

Npos1 = unique(Npos1);
Npos1 = Npos1(2:2:end);

Carotid_2 = Carotid_2(index_2);
Carotid_2 = (Carotid_2 - mean(Carotid_2))/std(Carotid_2);
[ s2_up, Npos2  ]   = detection_dicrotic_notch(Carotid_2, 1000);
for i = 1: length(Npos2)-1
    if sum(Npos2(i) == Npos2(i+1)-[0:200]) ==1
        Npos2(i+1) = Npos2(i);
    end
    index = Npos2(i)-20:Npos2(i)+20;
    sign = Carotid_2*NaN; 
    sign(index) = Carotid_2(index);
    [a, Npos2(i)  ] =min(sign);
end

Npos2 = unique(Npos2);
Npos2 = Npos2(1:2:end);

%% Figure 1.1
% A figure showing the steps to segment the PCG signals on its sistolic and
% diastolic parts. See figure 4.30 in the textbook. The same figure should
% be shown here. Do this for patient one here
PCG_1= PCG_1(index_1);
t1 = (0:length(PCG_1)-1)/1000;
figure

subplot 511                 
sign_S1_1 = t1*NaN;
sign_S1_1(Rpos_1*5) = min(PCG_1);

sign_S2_1 = t1*NaN; 
sign_S2_1(Npos1) = min(PCG_1);

hold on;
plot(t1, PCG_1); 
plot(t1,sign_S1_1, 'r*');
plot(t1, sign_S2_1,'b*');
hold off;
legend('PCG signal','QRS complex location','Dicrotic notch location')
ylabel('PCG')
axis tight;


subplot 512                 
hold on;
plot(t1, ECG_1);
stem(t1(Rpos_1*5),ECG_1(Rpos_1*5));
hold off;
legend('ECG','R-peaks')
ylabel('ECG')
axis tight;

subplot 513   
t1bis = 0:1/200:(length(ECG_1_int)-1)/200; 
hold on;
plot(t1bis, ECG_1_int);
stem(t1bis(Rpos_1),ECG_1_int(Rpos_1));
hold off;
ylabel('Integral')
legend('Integrated','Detected events')
axis tight;


subplot 514                 
hold on; 
plot(t1,Carotid_1);
stem(t1(Npos1),Carotid_1(Npos1));
hold off;
ylabel('Carotid')
legend('Carotid','Dicrotich notch')
axis tight;


subplot 515   
hold on;
plot(t1, s1_up((1:length(t1))) );
stem(t1(Npos1),s1_up(Npos1));
hold off;
title('Squared of second derivative')
legend('Signal','Detected events')
axis tight;
ylim([0 10])
suptitle('Patient 1')


%% Figure 1.2
% A figure showing the steps to segment the PCG signals on its sistolic and
% diastolic parts. See figure 4.30 in the textbook. The same figure should
% be shown here. Do this for patient two here
PCG_2 =PCG_2(index_2);
t2 = (0:length(PCG_2)-1)/1000;


figure

subplot 511                 
sign_S1_2 = t2*NaN;
sign_S1_2(Rpos_2*5) = min(PCG_2);
sign_S2_2 = t2*NaN; 
sign_S2_2(Npos2) = min(PCG_2);

hold on;
plot(t2, PCG_2);
plot(t2, sign_S1_2,'r*')
plot(t2, sign_S2_2,'b*')
hold off;
legend('PCG signal','QRS complex location','Dicrotic notch location')
ylabel('PCG')
axis tight;

subplot 512   
hold on;
plot(t2, ECG_2);
stem(t2(Rpos_2*5),ECG_2(Rpos_2*5));
hold off;
legend('ECG','R-peaks')
ylabel('ECG')
axis tight;

subplot 513  
t2bis = 0:1/200:(length(ECG_2_int)-1)/200; 
hold on;
plot(t2bis, ECG_2_int);
stem(t2bis(Rpos_2),ECG_2_int(Rpos_2));
hold off;
ylabel('Integral')
legend('Integrated','Detected events')
axis tight;

subplot 514                 %Plot the estimations using a Hanning window
t2 = (0:length(Carotid_2)-1)/1000;
hold on; 
plot(t2,Carotid_2);
stem(t2(Npos2),Carotid_2(Npos2));
hold off;
ylabel('Carotid')
legend('Carotid','Dicrotich notch')
axis tight;


subplot 515                 %Plot the estimations using a Hanning window
hold on;
plot(t2, s2_up(1:length(t2)));
stem(t2(Npos2),s2_up(Npos2));
hold off;
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
hold on;
plot(t, ecg);
stem(t(Rpos),ecg(Rpos));
hold off;

title('ECG signal and detected R-peaks')
legend('ECG signal','R-peaks')

subplot 212
plot(tach);
title('Tachogram')
suptitle('Computation of the tachogram in the test signal')