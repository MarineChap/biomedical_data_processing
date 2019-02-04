function [acc,sens,spec] = performance(pred_label,true_label)
% Compute the accuracy, sensitivity and specificity of the classifier

% Input: - pred_label: label predicted by the classifier
%        - true_label: true label

% Output: - acc: accuracy
%         - sens: sensitivity
%         - spec: specificity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...
TP = 0;
FN = 0; 
TN = 0; 
FP = 0;
for i = 1:length(pred_label)
    if true_label(i) == 1
        % with epilepsy
        if true_label(i) ==  pred_label(i) 
            TP = TP+1; 
        else 
            FN = FN + 1; 
        end
    else 
        % without epilepsy
        if true_label(i) ==  pred_label(i) 
            TN = TN+1; 
        else 
            FP= FP + 1; 
        end
    end
end

acc = (TP + TN) / (TP+TN+FP+FN);
sens= TP/(TP+FN);
spec = TN/(TN+FP) ;

end

