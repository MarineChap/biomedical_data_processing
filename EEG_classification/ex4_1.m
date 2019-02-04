%--------------------------------------------------------------------------
%
% EX 4.1 : Descriptive statistics
%
%--------------------------------------------------------------------------
clear all;
close all;
clc;

% --- Extract features & labels of EEG data
[data, labels] = main('session4_train_2018.mat');
features = {'Relative power delta','Relative power theta','Relative power alpha','Relative power beta'};

% --- Make a scatter plot of all possible feature combinations

cmb = combnk(1:4,2); % all possible feature combinations

% go with a for loop through all possible feature combinations and
% visualize the features (make 1 figure with 6 subplots)

figure;
for i=1:length(cmb)
subplot(3,2,i);
hold on;
h = scatter(data(labels==0,cmb(i,1)), data(labels==0,cmb(i,2)));
h1 = scatter(data(labels==1,cmb(i,1)), data(labels==1,cmb(i,2)));
ylabel(features(cmb(i,2)));
xlabel(features(cmb(i,1)));
legend([h h1],'Without epilepsy', 'With epilepsy');
hold off;
end

% --- Make boxplots for each feature

figure; 
hold on;

for i=1:4
    subplot(2,2,i);
    boxplot([data(labels==0,i) data(labels==1,i)], [0 1], 'labels', {'No epilepsy' 'Epilespy'});
    ylabel(features(i));
end 

% --- Compute & display mean and standard deviation
% (Use a table with the features in the rows & mean and standard deviation
% for each class in the columns)

for i=1:4
    standard_dev(i,1) = std(data(labels==0,i));
    standard_dev(i,2) = std(data(labels==1,i));
    mean_data(i,1) = mean(data(labels==0,i));
    mean_data(i,2) = mean(data(labels==1,i));
end 
label =features';
T = table(label, standard_dev, mean_data)