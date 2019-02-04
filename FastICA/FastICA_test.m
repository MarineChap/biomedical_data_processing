% session_5_1_1.m
% November 2018

clear; close all; clc; 
addpath ./FastICA_25/
rng('default');

%% Data
t = (0:9999)/1000; 
load icadata.mat
ecg = Sources(1,:);
reference1 = Sources(2,:); 
reference2 = Sources(4,:); 
Sources = (Sources - repmat(mean(Sources,2),[1,length(Sources)]))./ repmat(std(Sources,0,2),[1,length(Sources)]);

%display the sources
figure;
for i = 1:size(Sources,1)
    subplot(size(Sources,1),1,i);
    plot(t, Sources(i,:));
    title(['Source #', num2str(i)]);
    xlabel('Time (s)');

end

%mix the sources
X = A*Sources;
% normalize the sources
X = (X - repmat(mean(X,2),[1,length(X)]))./ repmat(std(X,0,2),[1,length(X)]);


%display the mixtures
figure;
for i = 1:size(X,1)   
    subplot(size(X,1),1,i);
    plot(t, X(i,:));
    title(['Mixture #', num2str(i)]);
    xlabel('Time (s)');
end

%% Source separation

% 1) Apply fastICA on the mixtures in X to obtain the originals, save the components in a variable y 
y =  fastica(X);
       
 %% Display the source estimates
figure;
for i = 1:size(y,1)   
    subplot(size(y,1),1,i);
    plot(t, y(i,:));
    title(['y-estimate #', num2str(i)]);
    xlabel('Time (s)');
end


%% Normalization, pairing and performance

% 2) Normalize the y-estimates: set mean value to 0 and variance to 1. Do you know why?

y = (y - repmat(mean(y,2),[1,length(y)]))./ repmat(std(y,0,2),[1,length(y)]);


% 3) Automatically match each Source with (one of) its best estimate(s))
%    Use squared or absolute correlation as matching criterion

RHO  = abs(corr(Sources',y'));
[maxvalue,pair] = max(RHO,[],2); 

figure;
j=0;
for i = 1:size(Sources,1)
    j=j+1;
    subplot(size(Sources,1),2,j);
    plot(t, Sources(pair(i),:));
    title(['Sources #', num2str(pair(i))]);
    xlabel('Time (s)');
    j=j+1;
    subplot(size(y,1),2,j);
    plot(t, y(i,:));
    title(['y-estimate #', num2str(i)]);
    xlabel('Time (s)');
end

% 4) calculate the Root Mean Squared Error (RMSE) between matched Source and estimate
%    y(t). Pay attention that the signals are zero mean, standardized and that they have the same sign. 
%    That is, use lower RMSE value (e.g. RMSE (Source_i, y_j ) and RMSE (Source_i, -y_j))

for i = 1:size(Sources,1)  
    RMSE(i) = sqrt(min(sum((y(pair(i),:) - Sources(i,:)).^2), sum((-y(pair(i),:) - Sources(i,:)).^2))/length(y));
end

%% Number of components

X2 = A2*Sources;
X2 = (X2 - repmat(mean(X2,2),[1,length(X2)]))./ repmat(std(X2,0,2),[1,length(X2)]);

X3 = A2*Sources + 0.1*rand(6,length(Sources));
X3 = (X3 - repmat(mean(X3,2),[1,length(X3)]))./ repmat(std(X3,0,2),[1,length(X3)]);

% 5) Apply fastICA for mixtures X2 and X3. Perform the normalization of the components and match them to the Sources.
%    What do you observe? How does it work or why doesn't it?

y2 =  fastica(X2);
y3 =  fastica(X3);

RHO2  = abs(corr(Sources',y2')); 
[maxvalue,pair2] = max(RHO2,[],2); 

RHO3  = abs(corr(Sources',y3'));
[maxvalue,pair3] = max(RHO3,[],2); 
    
    
figure;
j=0;
for i = 1:size(Sources,1)
    j=j+1;
    subplot(size(Sources,1),3,j);
    plot(t, Sources(i,:));
    title(['Sources #', num2str(i)]);
    xlabel('Time (s)');
    
    j=j+1;
    subplot(size(Sources,1),3,j);
    plot(t, y2(pair2(i),:));
    title(['y-estimate #', num2str(pair2(i))]);
    xlabel('Time (s)');
    
    j=j+1;
    subplot(size(Sources,1),3,j);
    plot(t, y3(pair3(i),:));
    title(['y-estimate #', num2str(pair3(i))]);
    xlabel('Time (s)');
    
     RMSE_3(i) = sqrt(min(sum((y3(pair3(i),:) - Sources(i,:)).^2), sum((-y3(pair3(i),:) - Sources(i,:)).^2))/length(y3));
     RMSE_2(i) = sqrt(min(sum((y2(pair2(i),:) - Sources(i,:)).^2), sum((-y2(pair2(i),:) - Sources(i,:)).^2))/length(y2));
   
end
cleanfigure();

T = table(RMSE', RMSE_2', RMSE_3','VariableNames',  {'Mixture_1','Mixture_2','Mixture_3'},'RowNames', {'ECG', 'EMG', 'PPG','White noise'} )

%% Artefact removal
% 6) Use fastICA to remove the noise and emg signals and reconstruct the mixtures signal. 
%    These signals are saved in the variables reference1 and reference2
%    so USE these variable to find the emg and noise component and
%    change the estimated mixing matrix A in order to remove it from the mixtures
%    hint: x=A*y (should y be normalized here, why (not)?)

clear Sources X2 X3 X4 %we don't use the original sources anymore 
% use the original mixture X and find the components with fastICA  

[y, A, W] = fastica(X); 
[max1, ref1_estim] = max(abs(corr(reference1', y')));
[max2, ref2_estim] = max(abs(corr(reference2', y')));

A_new = inv(W); 
A_new(:,ref2_estim) = zeros(size(W(ref2_estim,:)));
A_new(:,ref1_estim) = zeros(size(W(ref1_estim,:)));

x = A_new*y;

% make subplots of the original mixtures next to the mixtures from which white noise and emg have been removed

figure;
j=0;
for i = 1:size(X,1) 
    j=j+1;
    subplot(size(X,1),2,j);
    plot(t, X(i,:));
    title(['Mixture #', num2str(i)]);
    xlabel('Time (s)');
    
    j=j+1;
    subplot(size(X,1),2,j);
    plot(t, x(i,:));
    title(['Mixture filtered #', num2str(i)]);
    xlabel('Time (s)');
end
