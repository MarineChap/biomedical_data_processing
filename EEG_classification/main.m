function [features, labels] = main(filename)
% Perform feature extraction & create labels 

% Input: name of the file you want to extract the features from

% Output: - features: feature matrix containing the relative power in
%                     different frequency bands for each 2s window
%         - labels: seizure (1) or non-seizure (0) label for each 2s window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Load the data

load(filename);
fs = EEG.srate;
data = EEG.data;
% --- Segment the EEG signal in 2s segments with 50% overlap & extract the
% features for each segment
i=0;
start = 1; 
while (start+2*fs-1)<= length(data)
    i=i+1;
    segment_EEG(i,:) = data(start:(start+2*fs-1));
    segment_start(i) = start;
    start =  start+fs;
    [psd_segment_EEG(i,:),f] = pwelch(segment_EEG(i,:), [], 0, 2*fs,fs);
    features(i,1) = trapz(psd_segment_EEG(i,f>=1 & f<4))/trapz(psd_segment_EEG(i,:));
    features(i,2) = trapz(psd_segment_EEG(i,f>=4 & f<7))/trapz(psd_segment_EEG(i,:));
    features(i,3) = trapz(psd_segment_EEG(i,f>=7 & f<12))/trapz(psd_segment_EEG(i,:));
    features(i,4) = trapz(psd_segment_EEG(i,f>=12 & f<20))/trapz(psd_segment_EEG(i,:));
end

% --- Create seizure/non-seizure labels

labels = zeros(1,length(segment_start));
labels(segment_start>(62*fs)) = 1;

% --- Perform normalization (if needed)

% ...

end

