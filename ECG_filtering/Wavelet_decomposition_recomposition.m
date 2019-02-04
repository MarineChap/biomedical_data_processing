% session_5_2_1
% November 2018

clear; close all; clc; 

load ECG
dwtmode('per','nodisp'); %periodic extension for decomposition


%% Wavelet decomposition
% decompose the signal using Daubechies wavelet 4 (db4)
% use functions wavedec, waverec, appcoef, detcoef

% wavedec = wavelet decomposition  
% appcoef = obtain approximation coeff using the wavelet decomposition
% detcoef = obtain detail coeff using the wavelet decomposition
% waverec = wavelet recomposition

[C,L] = wavedec(ecg,5,'db4'); 
A = appcoef(C,L,'db4',5); 
D = detcoef(C,L,1:5); 

figure; 
subplot(7,1,1);
t = (0:length(ecg)-1)/fs;
plot(t, ecg); 
xlabel('time (sec)');
ylabel('ECG');

subplot(7,1,2); 
t = (0:32:length(ecg)-1)/fs;
stem(t, A,'.'); 
xlabel('time (sec)');
ylabel('A5')

subplot(7,1,3); 
t = (0:32:length(ecg)-1)/fs;
stem(t, D{5},'.'); 
xlabel('time (sec)');
ylabel('D5');
title('detail coeff');

subplot(7,1,4); 
t = (0:16:length(ecg)-1)/fs;
stem(t, D{4},'.'); 
xlabel('time (sec)');
ylabel('D4');


subplot(7,1,5); 
t = (0:8:length(ecg)-1)/fs;
stem(t, D{3},'.'); 
xlabel('time (sec)');
ylabel('D3');

subplot(7,1,6); 
t = (0:4:length(ecg)-1)/fs;
stem(t, D{2},'.'); 
xlabel('time (sec)');
ylabel('D2');

subplot(7,1,7); 
t = (0:2:length(ecg)-1)/fs;
stem(t, D{1},'.'); 
xlabel('time (sec)');
ylabel('D1');

%% Wavelet decomposition Q2

[ecg_rec10 , RMSE1] = recomposition( 10,  ecg, fs, 'db4', A, D);
[ecg_rec25 , RMSE2] = recomposition( 25,  ecg, fs, 'db4', A, D);
[ecg_rec50 , RMSE3] = recomposition( 50,  ecg, fs, 'db4', A, D);
[ecg_rec100, RMSE4] = recomposition( 100, ecg, fs, 'db4', A, D);



