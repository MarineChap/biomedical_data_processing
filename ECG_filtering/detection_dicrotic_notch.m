function [ s_up, Npos  ] = detection_dicrotic_notch(signal, fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[P,Q] = rat(256/fs,0.0001);
signal_dws = resample(signal,P,Q);
A_f1 = 4;
B_f1 = [1 2 1];
signal_dws = filter(B_f1,A_f1, signal_dws); 

p = zeros(length(signal_dws),1);
for n= 3:(length(signal_dws)-2) 
    p(n) = 2*signal_dws(n-2) - signal_dws(n-1) - 2*signal_dws(n) - signal_dws(n+1) + 2*signal_dws(n+2);
end


M = 16;
s = zeros(length(signal_dws),1);
for n=3:(length(signal_dws)-2) 

    for k= 1:M 
        if M <= n
            s(n) = s(n) + p(n-k+1)^2*(M-k+1);
        end
    end
end


peak = find(s >0.1*max(s));
s_peak = s*NaN; 
s_peak(peak) = s(peak);
[b,Npos] = findpeaks(s_peak); 


Npos = round(Npos*1000/256);
[P,Q] = rat(fs/256,0.0001);
s_up = resample(s,P,Q);

end

