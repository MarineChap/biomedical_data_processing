function [ signal ] = segment_data( EEGdata, trigger)
    base_line = mean(EEGdata(1:trigger));
    signal = EEGdata - base_line*ones(size(EEGdata));
end
