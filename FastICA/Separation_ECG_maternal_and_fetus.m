% session_5_1_2.m
% November 2018

clear; close all; clc; 
addpath ./FastICA_25/

%% Data
load abdominalECG; 

% visualize the abdominal channels and direct signals, including the spectra
fs = 1000;
t = (0:(length(abdomen)-1))/fs;
f = fs/size(t,2)*(0:size(t,2)/2-1);
% correlate the abdominal data with the reference
RHO  = abs(corr(abdomen',direct'));
[maxvalue,pair] = max(RHO); 


%% Filtering

% construct appropriate filters for your signals and filter your data (and direct reference).
% continue with your filtered data
r =0.8;
A = [1 -r];
B = [fs -fs];
for i = 1:size(abdomen,1)
    abdomen_f(i,:) = filter(B,A,abdomen(i,:));
end
direct_f = filter(B,A,direct);

j=0;
figure; 
for i = 1:size(abdomen,1)
    j = j+1;
    subplot(5,2,j);
    plot(t, abdomen(i,:)); 
    xlabel('Time in sec');
    
    ylabel(['ECG' num2str(i)]);
    j=j+1;
    sig_fft = abs(fft(abdomen(i,:))).^2;
    subplot(5,2,j);
    plot(f, sig_fft(1:end/2)); 
    xlabel('Frequence in Hz'); 
    xlim([0 100]);
end
subplot(5,2,9);
plot(t, direct); 
xlabel('Time in sec'); 
ylabel('Fetus ECG');
sig_fft = abs(fft(direct)).^2;
subplot(5,2,10);
plot(f, sig_fft(1:end/2)); 
xlabel('Frequence in Hz'); 
xlim([0 100]);



% correlate the filtered abdominal data with the filtered reference

RHO_f  = abs(corr(abdomen_f',direct_f'));
[maxvalue,pair_f] = max(RHO_f); 
% Visualize the best result

figure; 

subplot(3,2,1)
plot(t, direct_f);
ylabel('Fetal ECG');
xlabel('time (sec)');
xlim([20 22]);
subplot(3,2,2)
plot(t,abdomen_f(pair_f,:));
ylabel('Identified ECG signal');
xlabel('time (sec)');
xlim([20 22]);
title('By simple correlation');

%% Apply PCA
mu = repmat(mean(abdomen_f,2),[1,length(abdomen_f)]); 
% centering data before applying pca;
abdomen_f = abdomen_f - mu;
[eig, score] = pca(abdomen_f'); 
% we are taking the lead component to compute the new dataset
% without forgeting mu
abdomen_pca = (score(:,1) * eig(:,1)')' + mu;
% No need to correlate as we are taking only one component, 4 signals in
% output are almost exactly the same. 

% Visualize the best result

subplot(3,2,3)
plot(t, direct_f);
ylabel('Fetal ECG');
xlabel('time (sec)');
xlim([20 22]);
subplot(3,2,4)
plot(t,abdomen_pca(1,:));
ylabel('Identified ECG signal');
xlabel('time (sec)');
xlim([20 22]);
title('By correlation after PCA algo');

%% Apply fastICA
% Normalization before using fastICA 
A = repmat(mean(abdomen_f,2),[1,length(abdomen_f)]); 
B = repmat(std(abdomen_f,0,2),[1,length(abdomen_f)]);
abdomen_ica = (abdomen_f - A)./ B;
y = fastica(abdomen_ica);
% to compare with other result, we cancel the effect of normalization 
% on the output of the algorithm
y = y.*B + A;

% correlate the sources with the filtered reference
RHO  = abs(corr(direct_f',y'));
[maxvalue,pair1] = max(RHO); 

% Visualize the best result
subplot(3,2,5)
plot(t, direct_f);
ylabel('Fetal ECG');
xlabel('time (sec)');
xlim([20 22]);
subplot(3,2,6)
plot(t, y(pair1, :));
ylabel('Identified ECG signal');
xlabel('time (sec)');
xlim([20 22]);
title('By correlation after ICA algo');

RMSE = sqrt(min(sum((abdomen_f(pair_f,:) - direct_f).^2), sum(( -abdomen_f(pair_f,:) -direct_f).^2))/length(abdomen_f));
RMSE_2 = sqrt(min(sum((abdomen_pca(pair,:) - direct_f).^2), sum((-abdomen_pca(pair,:) - direct_f).^2))/length(abdomen_pca));
RMSE_3 = sqrt(min(sum((y(pair1, :) - direct_f).^2), sum((-y(pair1, :) -direct_f).^2))/length( y));

T = table(RMSE, RMSE_2, RMSE_3,'VariableNames',  {'Simple_correlation','PCA','ICA'},'RowNames', {'RMSE'} )

