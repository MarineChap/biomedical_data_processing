% session_5_2_2
% November 2018

clear; close all; clc; 

%% 0) preparing the data
load session4_traintest_2018.mat

%segment the data (2s with 50% overlap) as before
fs = EEG_train.srate; 

% Train dataset 
i=0;
start = 1; 
while (start+2*fs-1)<= length(EEG_train.data)
    i=i+1;
    segment_EEG_train(i,:) = EEG_train.data(start:(start+2*fs-1));
    segment_start(i) = start;
    start =  start+fs;
end 
train_labels = zeros(1,length(segment_start));
train_labels(segment_start>(EEG_train.seizureStart*fs) & segment_start<(EEG_train.seizureEnd*fs)) = 1;

% Test dataset 
i=0;
start = 1; 
while (start+2*fs-1)<= length(EEG_test.data)
    i=i+1;
    segment_EEG_test(i,:) = EEG_test.data(start:(start+2*fs-1));
    segment_start(i) = start;
    start =  start+fs;
end 
test_labels = zeros(1,length(segment_start));
test_labels(segment_start>(EEG_test.seizureStart*fs) & segment_start<(EEG_test.seizureEnd*fs)) = 1;


%% 1) Plot the training segments in two adjacent subplots, one for each class

t = (0:length(segment_EEG_train(1,:))-1)/fs;
figure; 
subplot(1,2,1); 
plot(t, segment_EEG_train(train_labels == 0,:)) ; 
xlabel('time (sec)'); 
ylabel('EEG');
stdmean = mean(std(segment_EEG_train(train_labels == 0,:)'));
title({'Without epilepsy', ['Mean standard deviation =' num2str(stdmean)]});
subplot(1,2,2); 
plot(t, segment_EEG_train(train_labels == 1,:)); 
xlabel('time (sec)'); 
ylabel('EEG');
stdmean = mean(std(segment_EEG_train(train_labels == 1,:)'));
title({'With epilepsy', ['Mean standard deviation =' num2str(stdmean)]});


%% 2) Calculate the signal energy for the training and test segments.

for i = 1:size(segment_EEG_train,1)
    E_train(i) = sum(segment_EEG_train(i,:).^2);
end

for i = 1:size(segment_EEG_test,1)
    E_test(i) = sum(segment_EEG_test(i,:).^2);
end


%% 3) Calculate the frequency band energies based on the discrete wavelet decomposition
 %    Decompose each segment (for both training and test) into wavelet coefficients
 %    Calculate the energy contained in the coefficients for each band (A1, D1, D2,..., D5)

for i = 1:size(segment_EEG_train,1)
   [C,L] = wavedec(segment_EEG_train(i,:),5,'db4'); 
    A = appcoef(C,L,'db4',5); 
   [D1, D2, D3, D4, D5] = detcoef(C,L,1:5);
    Edc_train(i,1) = sum(A.^2);
    Edc_train(i,6) = sum(D1.^2);
    Edc_train(i,5) = sum(D2.^2);
    Edc_train(i,4) = sum(D3.^2);
    Edc_train(i,3) = sum(D4.^2);
    Edc_train(i,2) = sum(D5.^2);
end

for i = 1:size(segment_EEG_test,1)
   [C,L] = wavedec(segment_EEG_test(i,:),5,'db4'); 
    A = appcoef(C,L,'db4',5); 
   [D1, D2, D3, D4, D5] = detcoef(C,L,1:5);
    Edc_test(i,1) = sum(A.^2);
    Edc_test(i,6) = sum(D1.^2);
    Edc_test(i,5) = sum(D2.^2);
    Edc_test(i,4) = sum(D3.^2);
    Edc_test(i,3) = sum(D4.^2);
    Edc_test(i,2) = sum(D5.^2);
end


%% 4) Display all the training features as boxplots
 %    full energy of the signals and 6 subband energies (7 subplots in total)
figure; 
subplot(4,2,1:2)
boxplot([E_train(train_labels==0)' E_train(train_labels==1)'], [0 1], 'labels', {'No seyzure' 'Seyzure'});
title('Full energy');
str1 = ['Energy A5'; 'Energy D5'; 'Energy D4'; 'Energy D3'; 'Energy D2'; 'Energy D1']; 
str2 = ['Freq range: 0- 8 Hz  '; 'Freq range: 8-16 Hz  '; 'Freq range:16-32 Hz  '; 'Freq range:32-64 Hz  '; 'Freq range:64-128 Hz ';'Freq range:128-256 Hz'];
for i = 1:size(Edc_train,2)
    subplot(4,2,i+2)
    boxplot([Edc_train(train_labels==0,i) Edc_train(train_labels==1,i)],[0 1], 'labels', {'No seizure' 'Seizure'});
    title({str1(i,:), str2(i,:)});
end



%% 5) Predict the test data with the predict function
 %    using only the full signal energies
 %    using only the subband energies
 %    Note: would it make sense to combine both? Why (not)?

tree  = fitcdiscr(E_train', train_labels);
pred_labels = predict(tree,  E_test');

full_energy = performance(pred_labels,test_labels);

tree  = fitcdiscr(Edc_train, train_labels);
pred_labels = predict(tree,  Edc_test);

subband_energy = performance(pred_labels,test_labels);

tree  = fitcdiscr( [E_train' Edc_train], train_labels);
pred_labels = predict(tree,  [E_test' Edc_test]);

whole_feature = performance(pred_labels,test_labels);


%% 6) Evaluate your classifiers (accuracy, sensitivity, specificity)

T = table(full_energy',subband_energy','VariableNames', {'full_energy','Subband_energy'},'RowNames', {'Accuracy', 'Sensitivity', 'Specificity'} )
