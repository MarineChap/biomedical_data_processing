function [ ecg_int,Rpos ] = Pan_tompkins( ecg,fs )
%PAN_TOMPKINS algorithm. 

% Low-pass Filter

B_lp_1 = [1 zeros(1,5) -2 zeros(1,5) 1]/32;
A_lp_1 = [1 -2 1];
ecg_lp = filter(B_lp_1,A_lp_1,ecg);

% High-Pass Filter

B_lp_2 = [1 zeros(1,31) -1];
A_lp_2 = [1 -1];
ecg_lp_2 = filter(B_lp_2,A_lp_2,ecg_lp);

ecg_lp_ex = [zeros(16,1); ecg_lp];
ecg_hp = ecg_lp_ex(1:end-16)-ecg_lp_2/32;

% Derivative
% implement the derivative filter of the Pan-Tomkins algorithm

B_d = [2 1 0 -1 -2]; 
A_d = [8 0 0 0 0]; 
ecg_d = filter(B_d,A_d,ecg_hp);

% Squaring
% implement the squaring step in the Pan-Tomkins algorithm

ecg_square = ecg_d.^2;

% Integration
% implement the integration step in the Pan-Tomkins algorithm
B_int = ones(1,30);
A_int = [30 zeros(1,29)];
ecg_int = filter(B_int,A_int,ecg_square);

% Detect initial peaks
pos_top= find(ecg_int> 0.5*max(ecg_int));

% Searchback procedure and adaptive thresholding. Correct for delays if
% needed. Use the provided function searchback.mat provided in toledo.
Rpos=unique(searchback(pos_top,ecg,fs));


end

