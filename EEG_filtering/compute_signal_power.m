function [ signal_power ] = compute_signal_power( noise_power, yavg, M, N )
%COMPUTE_SIGNAL_POWER Summary of this function goes here
%   Detailed explanation goes here
    signal_power = sum(yavg.^2)/N - noise_power/M;
end

