function [label_test] = df(train,label_train,test)
% Perform classification based on the distance function

% Input: - train: features of the training set
%        - label_train: labels of the training set
%        - test: feature of the test sample

% Output: label_test: label of the test sample

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Compute the prototypes
z1 = mean(train(label_train==0,:),1);
z2 = mean(train(label_train==1,:),1);

% --- Compute the distance to both prototypes

d1 = sqrt((test - z1)*(test-z1)');
d2 = sqrt((test - z2)*(test-z2)');


% --- Assign label of the closest prototype
if d1 < d2 
    label_test = 0; 
else 
    label_test = 1; 
% ...

end

