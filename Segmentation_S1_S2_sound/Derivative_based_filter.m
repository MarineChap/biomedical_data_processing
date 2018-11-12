function [ B,A ] = Derivative_based_filter(r,fs)
A = [1 -r];
B = [fs -fs];
end

