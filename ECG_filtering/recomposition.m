function [ signal_rec, RMSE, A, D ] = recomposition(M,signal,fs, wave, A, D )

for i = 1: length(D)
    [value, ind] = sort(abs(D{i}), 'descend');
    save('function');
    coeff = zeros(size(D{i})); 
    M1 = min(M,length(D{i}));
    coeff(ind(1:M1)) = D{i}(ind(1:M1));
    D{i} =  coeff;
end
[value, ind] = sort(abs(A), 'descend');
coeff = zeros(size(A)); 
M1 = min(M,length(D{i}));
coeff(ind(1:M1)) = A(ind(1:M1));
A = coeff; 

CR = A;
LR = length(A);

for i = length(D):-1:1
    CR=[CR D{i}];
    LR=[LR length(D{i})];
end
LR = [LR length(signal)];
signal_rec = waverec(CR,LR',wave);

RMSE = sqrt(sum((signal-signal_rec).^2)/length(signal));

figure; 
subplot(length(D)+3,1,1);
t = (0:(length(signal)-1))/fs;
plot(t, signal); 
ylabel('ECG');

subplot(length(D)+3,1,2);
plot(t, signal_rec); 
title({'ECG reconstructed', ['RMSE =' num2str(RMSE)]});

subplot(length(D)+3,1,3); 
sampling = 2^length(D); 
t = (0:sampling:(length(signal)-1))/fs;
stem(t, A, '.'); 
label = ['A ' num2str(length(D))];
ylabel(label)

j=3;
for i = length(D):-1:1
    j=j+1;
    subplot(length(D)+3,1,j); 
    sampling = 2^i; 
    t = (0:sampling:(length(signal)-1))/fs;
    stem(t, D{i}, '.'); 
    label = ['D ' num2str(i)];
    ylabel(label)
end
xlabel('Time (sec)');

end

