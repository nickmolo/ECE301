% Written by Nick Molo and Damian Parton
%% Generating constants

duration = 8;
f_sample = 44100;
t=(((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;

%% Loading in audio files

[x1, ~] = audioread('x1.wav');
x1=x1';

[x2, ~] = audioread('x2.wav');
x2=x2';

[x3, ~] = audioread('x3.wav');
x3=x3';

Wc =1000/pi;

%% Low Pass filter creation
%h = 2*Wc*sinc(2* Wc * t);
h = sin(2*pi*500*t)./(pi*t);

%% Passing signal through low pass filter
x1_lpf = ece301conv(x1, h);
x2_lpf = ece301conv(x2, h);
x3_lpf = ece301conv(x3, h);

soundsc(x1_lpf, f_sample);

%% Picking Filter Frequencies 

fc1 = 900*pi;
fc2 = 2500*pi;
fc3 = 3900*pi;

%% Construct AM Modulated signal
y1 = x1_lpf.*cos(fc1 * t);
y2 = x2_lpf.*cos(fc2 * t);
y3 = x3_lpf.*cos(fc3 * t); 

z = y1+y2+y3;

%% Writing combined signal to file 
audiowrite('radio1.wav', z, f_sample );
