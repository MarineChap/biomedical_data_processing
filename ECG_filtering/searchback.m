function Rpos=searchback(pos_top,signal,fs)
% Now all the peaks are detected, and adaptive thresholding is used to
% determine if the peaks are signal or noise peaks
%   Inputs: 
%           pos_top :   Detected peaks in the signal. This includes noise
%           peaks and signal peaks.
%           signal  :   ECG signal under analysis.
%           fs      :   Sampling frequency in Hz.
%   Output: 
op=signal; 
N = round(0.150/(1/fs));
if length(pos_top)<5
    RR_proc=[];Rpos=[];
else
    RR_average = 600;
    threshold1 = 0;
    SPKI = 0;
    NPKI = 0;

    position_signal_peak = zeros(1,length(pos_top));
    position_signal_peak(1) = pos_top(1);
    position_noise_peak = zeros(1,length(pos_top));

    threshold2 = threshold1/2;
    RR_interval = zeros(1,length(pos_top)-1);
    countsignal = 1;
    countnoise = 0;

    for k = 2:length(pos_top)
        peak = op(pos_top(k));
        RR_low_limit = 0.92*RR_average;
        if RR_low_limit < 200
            RR_low_limit = 200; %low limit for RRI is 200 ms
        end

        RR_high_limit = 1.16*RR_average;
        if RR_high_limit > 1600
            RR_high_limit = 1600; %high limit for RRI is 1600 ms
        end

        if peak >= threshold1 % peak is a signal peak
            countsignal = countsignal + 1;
            SPKI = 0.125*peak + 0.875*SPKI;
            position_signal_peak(countsignal) = pos_top(k);
            RR_interval(countsignal-1) = position_signal_peak(countsignal)-position_signal_peak(countsignal-1);
        elseif peak <= threshold2 % peak is a noise peak
            countnoise = countnoise + 1;
            NPKI = 0.125*peak + 0.875*NPKI;
            position_noise_peak(countnoise) = pos_top(k);
        else % searchback procedure
            if peak >= RR_low_limit+position_signal_peak(countsignal) && peak <= RR_high_limit+position_signal_peak(countsignal-1) %signal peak
                countsignal = countsignal + 1;
                SPKI = 0.25*peak + 0.75*SPKI;
                position_signal_peak(countsignal) = pos_top(k);
                RR_interval(countsignal-1) = position_signal_peak(countsignal)-position_signal_peak(countsignal-1);
            else
                countnoise = countnoise + 1;
                NPKI = 0.125*peak+0.875*NPKI;
                position_noise_peak(countnoise) = pos_top(k);
            end
        end
        threshold1 = NPKI+0.25*(SPKI-NPKI);
        threshold2 = 0.5*threshold1;
        if countsignal>1
            RR_average = mean(RR_interval(1:countsignal-1));
        end
    end

    position_signal_peak = position_signal_peak(2:countsignal); %@beginning, first peak assumed to be a signal peak, now deleted
    position_noise_peak = position_noise_peak(1:countnoise);

    % Now, the exact positions of the R peaks are determined by finding the
    % maximum in the interval [peak-W peak], W = N;
    interval_pos=[];
    W = N*2;%+20;
    pos_R = zeros(1,length(position_signal_peak));
    for i = 1:length(position_signal_peak)
        possp = position_signal_peak(i);
        in=possp-W;
        if in<1,in=1;
        end
        interval_pos = [in:possp];
        [Y,index_pos] = max(signal(interval_pos));
        pos_R(i) = interval_pos(index_pos);
    end

    RR_interval = calc_interval(pos_R);
    RR = RR_interval/fs*1000; %in ms

    if ~isempty(RR)    
        RR_proc = preproc_small(RR);
        Rpos(1) = pos_R(1);
        Rpos(2:length(RR_proc)+1) = cumsum(RR_proc*fs/1000) + pos_R(1);
    else RR_proc = [];Rpos = [];
    end
end

function [interval] = calc_interval(sign)

% Input:    signal      

% Output:   interval

len = length(sign);
interval = zeros(1,len-1);

for i = 1:len-1
    interval(i) = (sign(i+1)-sign(i));
end



function [pos_opt] = calc_pos_opt(signal,step,maxmin,fs)
% Calculation of optima

% Input:    signal      signal
%           step        stepsize according to application
%           maxmin      for finding maxima: maxmin = 1
%                       for finding minima: maxmin = -1
% Output:   pos_opt     positions of the optima
    
sze = length(signal);
difference = zeros(sze-1,1);
pos = zeros(1,sze-step);
time = [1:sze]/fs;
count = 0;

for i = 1:sze-step
    if (signal(i+step)-signal(i))*maxmin > 0
        count = count + 1;
        difference(i,1) = 1;
        pos(count) = i+1;
    else
        difference(i,1) = 0;
    end
end
pos = pos(1:count);

% Next, determination of all the optima
pos_opt = zeros(1,sze-step);
no_opt = 0;

for i = 2:sze-step%step/2+1:sze-step
    real_opt = 1;
    if difference(i-1,1)==1 && difference(i,1)==0 
        j = 1;
        while real_opt==1 && j<step && j<i
            if difference(i-j,1)==1
                real_opt = 1;
            else
                real_opt = 0;
            end
            j = j+1;
        end
        if real_opt==1
            interval = [i:i+step];
            no_opt = no_opt + 1;
            if maxmin == 1
                [Y,index] = max(signal(interval));
            else
                [Y,index] = min(signal(interval));
            end
            pos_opt(no_opt) = interval(index);
        end
    end
end

pos_opt = pos_opt(1:no_opt);


function [RR,nr,prob_big,prob_small] = preproc_small(RR)
%Preprocessing of RR intervals

% Input:    RR          RR intervals (in ms)
% Output:   RR          preprocessed RR intervals (in ms)
%           nr          number of deleted RR intervals
%           prob_big    index of big problem intervals 
%           prob_small  index of small problem intervals 
%           Rampl       preprocessed amplitude of R peak


len = length(RR);
nr = 0; % number of deleted RRI
a = 0.3; % 30% difference
b = 0.8; % missed beat
d = 0.5;
max_k = 10;
i = 2;
prob_big = zeros(1,len); % difference >d*RR_ref
prob_small = zeros(1,len); % difference=[a*RR_ref,d*RR_ref]
RRref_all = zeros(1,len-1);
RRref_all(1) = RR(1);

while i < len-1
    % To check whether RRI is correct. This will be done by comparing
    % RRI with the mean of 3 past RRI's. A past RRI shouldn't be a
    % 'problem' RRI. The mean of 3 'good' past RRI's = RR_ref.
    k = 1;
    sum_ref = 0;
    num = 0;
    wght = [0.5 0.3 0.2]; % weights
    while i-k > 0 && num < 3 && k < max_k
        no_prob_big = nnz(prob_big);
        begin_prob = max(1,no_prob_big-max_k);
        test_prob = abs(prob_big(begin_prob:no_prob_big))==i-k;
        if ~any(test_prob) 
            num = num + 1;
            sum_ref = sum_ref + wght(num)*RR(i-k);
        end
        k = k+1;
    end
    if num == 0
        k = 1;
        while i-k > 0 && num < 3 
            num = num + 1;
            sum_ref = sum_ref + wght(num)*RR(i-k);
            k = k+1;
        end
    end
    RR_ref = sum_ref/sum(wght(1:num));
    no_RR_ref = nnz(RRref_all);
    RRref_all(no_RR_ref+1) = RR_ref;
    
    % Check for small RRI's. Try to summon small RRI's with the next or 
    % previous RRI in order to obtain a better RRI
    if RR(i) < (1-a)*RR_ref || RR(i) < 200
        j = 1;
        test = 1;
        sumRR = RR(i);   
        while test==1 % test = 1 until a good summation is made or when no good summation can be found
            if sumRR < (1-a)*RR_ref || sumRR < 200 %summon next RRI
                sumRR = sumRR + RR(i+j);
                test = 1;
                j = j + 1;
                if i + j > len
                    test = 0;
                    proc = 0; % 0 means that no good summation was found
                    RRnew = sumRR;
                    ind = i;
                    to_del = j - 1;
                end
            elseif abs(sumRR-RR_ref)< a*RR_ref  %good summation, but before replacing RRI by the sum, check first if including the next RRI gives a better result
                if i + j <= len
                    test2 = 1; % test2 = 1 until the best summation is found
                    while test2==1
                        sumRR2 = sumRR + RR(i+j);
                        diff1 = abs(RR_ref-sumRR)/RR_ref;
                        diff2 = abs(RR_ref-sumRR2)/RR_ref;
                        if diff1 < diff2
                            test = 0;
                            test2 = 0;
                            RRnew = sumRR;
                            ind = i;
                            to_del = j-1; % delete j-1 last RRI
                            proc = 1;
                        else
                            sumRR = sumRR2;
                            j = j + 1;
                            test2 = 1;
                            if i + j > len
                                test = 0;
                                test2 = 0;
                                RRnew = sumRR2;
                                ind = i;
                                to_del = j - 1;
                                proc = 1;
                            end
                        end
                    end
                else
                    test = 0;
                    RRnew = sumRR;
                    ind = i;
                    to_del = j - 1;
                    proc = 1;
                end
            else 
                proc = 0; % no good summation was found, but maybe RR(i) belongs to previous RRI
                test = 0;
                to_del = j - 2;
                RRnew = sumRR - RR(i+j-1);
                ind = i;
            end
        end
        
        % Check if a summation with the previous RRI gives better results
        if i>1
            sum2 = RR(i) + RR(i-1); 
        else
            sum2 = RR(i);
        end
        diffnew = abs(RRnew-RR_ref)/RR_ref;
        diffsum2 = abs(sum2-RR_ref)/RR_ref;
        if diffsum2 < diffnew
            if diffsum2 < a
                proc = 1;
            end
            RRnew = sum2;
            ind = i - 1;
            to_del = 1;
        end
        if proc ~= 1 
            if abs(RRnew-RR_ref)/RR_ref > d || RRnew < 200
                no_prob_big = nnz(prob_big);
                prob_big(no_prob_big + 1) = i;
            elseif a < abs(RRnew-RR_ref)/RR_ref < d
                no_prob_small = nnz(prob_small);
                prob_small(no_prob_small + 1) = i;
            end
        end
    elseif RR(i) > (1+a)*RR_ref || RR(i) > 1600
        if abs(RR(i)-RR_ref)/RR_ref > d || RR(i)>1600
            no_prob_big = nnz(prob_big);
            prob_big(no_prob_big + 1) = -i;
        elseif a < abs(RR(i)-RR_ref)/RR_ref < d
            no_prob_small = nnz(prob_small);
            prob_small(no_prob_small + 1) = -i;
        end
        proc = 2;
        ind = i;
        to_del = 0;
    else 
        proc = 2;
        ind = i;
        to_del = 0;
    end
    if proc~=2
        RR(ind) = RRnew;
        RR(ind+1:len-to_del) = RR(ind+to_del+1:end);
        RR = RR(1:len-to_del);
        len = length(RR);
        nr = nr + to_del;
        
    end
    if ind==i-1
        i=i-1;
    elseif to_del>0
        i = i;
    else %to_del==0
        i = i+1;   
    end
end

no_prob_big = nnz(prob_big);
prob_big = prob_big(1:no_prob_big);
no_prob_small = nnz(prob_small);
prob_small = prob_small(1:no_prob_small);
