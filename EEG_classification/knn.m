function [label_test] = knn(train,label_train,test,k)
% Perform kNN classification

% Input: - train: features of the training set
%        - label_train: labels of the training set
%        - test: feature of the test sample
%        - k: number of nearest neighbours to take into account

% Output: label_test: label of the test sample

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Compute distance to all other samples

% ...

index_class0 = find(label_train==0);
index_class1 = find(label_train==1);
if k > min([length(index_class0) length(index_class1)])
    k = min([k length(index_class0) length(index_class1)]);
    disp('K is too high. the distance is compute between all samples');
end
c0 = 0;
c1 = 0;
for i = 1:k 
    z1 = train(index_class0(i),:);
    z2 = train(index_class1(i),:);
    d1 = sqrt((test - z1)*(test-z1)');
    d2 = sqrt((test - z2)*(test-z2)');
    if d1<d2
        c0 = c0 +1;
    else 
        c1 = c1 + 1;
    end
end

% --- Assign the label of majority of k closest samples

if c0 > c1 
    label_test = 0; 
else 
    label_test = 1; 

end

