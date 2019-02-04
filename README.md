# biomedical_data_processing (H03I2A - KU Leuven)

Objective : Apply algorithms saw in class

### EEG filtering : 
- Application : <br>
  - Human subject that is doing the so-called “detection task”: <br>
The subject was asked to press a button when a certain (circular) shape appeared on the screen. This shape could appear in five regions on the screen: the upper (UR) and down right (DR), the upper (UL) and down left (DL) and the center of the screen (CE). During the session, EEG was measured so the responses of the brain related to these particular stimuli could be extracted. <br>

- Filter used : <br>
  - Synchronized average filter : By averaging each epoch related to a particular event, random noises are easily removed. <br>

### EEG classification : 
- Application : <br> 
  - EEG from an epileptic during both a seizure and a normal state: <br> 

The objective is to create a model to detect seizure by using an EEG with epileptic seizure segment labeled. <br> Features used : 
- Case 1 : Relative power delta,  Relative power theta, Relative power alpha, Relative power beta
- Case 2 : Full energy
- Case 3 : Wavelet decomposition - range frequency : <br>
  - Energy A5 - 0-4 Hz (delta rhythm) <br>
  - Energy D5 - 4-8 Hz (theta rhythm) <br>
  - Energy D4 - 8-16 Hz (alpha rhythm) <br>
  - Energy D3 - 16-32 Hz (beta rhythm) <br>
  - Energy D2 - 32-64 Hz <br>
  - Energy D1 - 64-128 Hz <br>

- Model used : <br>
  - Kmeans clustering <br>
  - Leave-on-out cross-validation <br>
    - distance function <br>
    - knn <br>
    - LDA <br>

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

### FastICA : 
- Application: <br> 
  - Random signals. Test of the fastICA algorithm on different mixing matrices. <br>

### Segmentation of the systolic and the diastolic part : 
- Application: <br> 
  - Human subject with an artery stenosis creating a murmur in his heart. PCG, ECG, carotid pulse has been recorded simultaneously. <br>
- Algorithms used: <br> 
  - Pan-Tompkins algo : Detection of PQR peaks in an ECG signal --> PQR = S1 start <br> 
  - Detection of the dicrotic notch in the carotid pulse --> dicrotic notch - 52.5 ms = S2 start <br> 
  - Segmentation of the PCG and average of each segment <br> 
  
## Bibliography :

[1] M.Rangayyan Rangaraj. Biomedical Signal Analysis. IEEE Press, 2015. <br>
[2] Ramesh Rajagopalan, Adam Dahlstrom. A pole radius varying notch filter with transient suppression for electrocardiogram.<br>
[3] Yue-Der Lin, Yu Hen Hu*. Power-Line Interference Detection and Suppression in ECG Signal Processing. 2014. <br>

## Comments :

To run the project, we need to use a version of matlab upper to R2015b.
