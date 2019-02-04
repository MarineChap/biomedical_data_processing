%--------------------------------------------------------------------------
%
% EX 4.2 : Unsupervised classification
%
%--------------------------------------------------------------------------

clear all;
close all;
clc;

% --- Extract features & labels of EEG data
[data, labels] = main('session4_train_2018.mat');
features = {'Relative power delta','Relative power theta','Relative power alpha','Relative power beta'};

% --- Perform k-means clustering & visualize the results of the clustering
% (use 1 figure with different subplots)

cmb = combnk(1:4,2); % all possible feature combinations

figure;
for i=1:length(cmb)
    subplot(3,2,i);
    hold on;
    X= [data(:,cmb(i,1)) data(:,cmb(i,2))];
    [idx, C, sumd_plus(i,:)] = kmeans(X, 2);
    centroid1_C0(:,i) = C(1,:);
    centroid1_C1(:,i) = C(2,:);
    
    plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
    plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
    plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3)
    
    ylabel(features(cmb(i,2)));
    xlabel(features(cmb(i,1)));
    hold off;
end

cmb = combnk(1:4,2); % all possible feature combinations

figure;
for i=1:length(cmb)
    subplot(3,2,i);
    hold on;
    X= [data(:,cmb(i,1)) data(:,cmb(i,2))];
    [idx, C, sumd_sample(i,:)] = kmeans(X, 2, 'Start', 'sample');
    centroid2_C0(:,i) = C(1,:);
    centroid2_C1(:,i) = C(2,:);
    
    plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
    plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
    plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3)
    ylabel(features(cmb(i,2)));
    xlabel(features(cmb(i,1)));
    hold off;
end

figure;
for i=1:length(cmb)
    subplot(3,2,i);
    hold on;
    X= [data(:,cmb(i,1)) data(:,cmb(i,2))];
    [idx, C, sumd_uniform(i,:)] = kmeans(X, 2, 'Start', 'uniform', 'Replicates', 10);
    centroid3_C0(:,i) = C(1,:);
    centroid3_C1(:,i) = C(2,:);
    
    plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
    plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
    plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3)
    ylabel(features(cmb(i,2)));
    xlabel(features(cmb(i,1)));
    hold off;
end

figure;
for i=1:length(cmb)
    subplot(3,2,i);
    hold on;
    plot(data(labels==1,cmb(i,1)),data(labels==1,cmb(i,2)),'r.','MarkerSize',12)
    plot(data(labels==0,cmb(i,1)),data(labels==0,cmb(i,2)),'b.','MarkerSize',12)
    plot([centroid3_C0(1,i) centroid3_C1(1,i)],[centroid3_C0(2,i) centroid3_C1(2,i)],'yx','MarkerSize',15,'LineWidth',3)
    plot([centroid2_C0(1,i) centroid2_C1(1,i)],[centroid2_C0(2,i) centroid2_C1(2,i)],'gx','MarkerSize',15,'LineWidth',3)
    plot([centroid1_C0(1,i) centroid1_C1(1,i)],[centroid1_C0(2,i) centroid1_C1(2,i)],'kx','MarkerSize',15,'LineWidth',3)
    legend('without epilepsy', 'epilepsy', 'init = uniform', 'init = sample', 'init = plus');
    ylabel(features(cmb(i,2)));
    xlabel(features(cmb(i,1)));
    hold off;
end

label = features';
T = table( sumd_plus, sumd_sample, sumd_uniform ) 


