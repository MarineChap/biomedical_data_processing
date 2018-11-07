# EEG Filtering 

“Detection task”: <br>
The Human subject was asked to press a button when a certain (circular) shape appeared on the screen. 
This shape could appear in five regions on the screen: <br>
- the upper (UR) and down right (DR), <br>
- the upper (UL) and down left (DL), <br>
- the center of the screen (CE). <br>
During the session, EEG was measured so the responses of the brain related to these particular stimuli could be extracted. 

## Synchronized average filter:
1. Separate epochs in segment of 100ms before the event and 600ms after
2. Average all epochs 
3. Compute SNR and Euclidian distance with equation from [2]

We assume the average signal obtain is the signal without noise.
SNR measures the ratio signal/noise. 
Euclidian distance measures the spread of the noise around the signal. 

## Bibliography: 

[1] Textbook: Biomedical signal processing, Rangaraj M. Rangayyan [2] Jonathan Raz, Bruce Turetsky, and George Fein, “Confidence Intervals for the Signal-to-Noise Ratio When a Signal Embedded in Noise is Observed Over Repeated Trials”, 
IEEE TRANSACTIONS ON BIOMEDICAL ENGINEERING, VOL. 35, NO. 8, AUGUST 1988
