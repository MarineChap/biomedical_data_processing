%--------------------------------------------------------------------------
%
% EX 4.3 : Supervised classification
%
%--------------------------------------------------------------------------
clear all;
close all;
clc;
% --- Extract features & labels of EEG data
[feat_tr, labels_tr] = main('session4_train_2018.mat');

%% Part 1: on training data

% --- Perform leave-one-out cross-validation and predict the label of the
% test sample using the distance function, kNN and LDA

for i = 1:length(feat_tr)
    data = feat_tr; 
    data(i,:) = [];
    label = labels_tr; 
    label(i) = [];
       
%%% --- Distance function
    pred_label_df(i) = df(data,label,feat_tr(i,:));
%%% --- KNN
    pred_label_nn1(i) = knn(data,label,feat_tr(i,:), 1);
    pred_label_nn3(i) = knn(data,label,feat_tr(i,:), 3);
    pred_label_nn5(i) = knn(data,label,feat_tr(i,:), 5);
    pred_label_nn7(i) = knn(data,label,feat_tr(i,:), 7);

%%% --- LDA
    tree = fitcdiscr(data,label);
    pred_label_lda(i) = predict(tree, feat_tr(i,:));
end
   
[acc(1),sens(1),spec(1)] = performance(pred_label_df,labels_tr);
[acc(2),sens(2),spec(2)] = performance(pred_label_nn1,labels_tr);
[acc(3),sens(3),spec(3)] = performance(pred_label_nn3,labels_tr);
[acc(4),sens(4),spec(4)] = performance(pred_label_nn5,labels_tr);
[acc(5),sens(5),spec(5)] = performance(pred_label_nn7,labels_tr);
[acc(6),sens(6),spec(6)] = performance(pred_label_lda,labels_tr);

  
% --- Compute performance (accuracy, sensitivity and specificity)
method = {'df' 'knn with k=1' 'knn with k=3' 'knn with k=5' 'knn with k=7', 'LDA' }';
acc=acc';
sens = sens';
spec= spec';
T = table(method, acc,sens,spec)
%% Part 2: on new, unseen test data

% --- Train LDA classifier using training data and apply on test data

[feat_ts, labels_ts] = main('session4_test_2018.mat');

tree = fitcdiscr(feat_tr,labels_tr);
[label,score] = predict(tree,feat_ts);

% --- Make ROC curve & compute area under curve
% Compute ROC
ind_prev =0;
i=0;
for th = 0:0.01:1
    pred_label_lda = score(:,2)*0;
    ind = find(score(:,2)>=th);
    pred_label_lda(ind) = 1; 
    [acc,sens(round(th*100)+1),spec(round(th*100)+1)] = performance(pred_label_lda,labels_ts);
end
[sens, ind] = unique(sens);
spec = spec(ind);

% Plotting ROC curve
FPF = 1-spec;
figure; 
plot(FPF, sens, 'r');
xlabel('FPF = 1-spec');
ylabel('TPF = sensitivity'); 
title('ROC curve');
% Compute and display AUC
AUC = trapz(FPF, sens)
% --- Mark requested working point on ROC curve
working_point = spec(sens == 0.8)

