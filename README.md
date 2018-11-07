# biomedical_data_processing (H03I2A - KU Leuven)

Objective : Apply filters saw in class

### EEG filtering : 
- Application : <br>
  - Human subject that is doing the so-called “detection task”: <br>
The subject was asked to press a button when a certain (circular) shape appeared on the screen. This shape could appear in five regions on the screen: the upper (UR) and down right (DR), the upper (UL) and down left (DL) and the center of the screen (CE). During the session, EEG was measured so the responses of the brain related to these particular stimuli could be extracted. <br>

- Filter used : <br>
  - Synchronized average filter : By averaging each epoch related to a particular event, random noises are easily removed. <br>

### ECG filtering : 
- Application 1: <br>
  - Human subject  that is watching a movie. ECG and respiration signals are simultaneously measured. <br>

- Filter used : <br>
  - Comb filter <br>
  
- Application 2: Full report (write for school) on the application is included <br>
  - ECG is recorded from a human subject. Signal is contaminated with a combination of high-frequency noise, low-frequency noise (wandering base-line), and power-line frequency.<br>

- Filter used : <br>
  - Hanning filter <br>
  - Derivative-based filter <br>
  - Comb filter <br>
  
  
## Bibliography :

[1] M.Rangayyan Rangaraj. Biomedical Signal Analysis. IEEE Press, 2015. <br>
[2] Ramesh Rajagopalan, Adam Dahlstrom. A pole radius varying notch filter with transient suppression for electrocardiogram.<br>
[3] Yue-Der Lin, Yu Hen Hu*. Power-Line Interference Detection and Suppression in ECG Signal Processing. 2014. <br>

## Comments :

To run the project, we need to use a version of matlab upper to R2015b.
