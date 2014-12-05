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
h = 2*Wc*sinc(2* Wc * t);
%h = sin(2*pi*Wc*t)./(pi*t);

%% Passing signal through low pass filter
x1_lpf = ece301conv(x1, h);
x2_lpf = ece301conv(x2, h);
x3_lpf = ece301conv(x3, h);

%soundsc(x1_lpf, f_sample);

%% Picking Filter Frequencies 

fc1 = 900*pi;
fc2 = 2500*pi;
fc3 = 3900*pi;

%% Construct AM Modulated signal
y1 = x1_lpf.*cos(fc1 * t);
y2 = x2_lpf.*cos(fc2 * t);
y3 = x3_lpf.*cos(fc3 * t); 

z = y1+y2+y3;

% 
% audiowrite('radio1.wav', z, f_sample );
% 

%% demodulation
w1 = z.*cos(fc1 * t);
w1 = ece301conv(w1, h);
w1 = w1.*2;

w2 = z.*cos(fc2 * t);
w2 = ece301conv(w2, h);
w2 = w2.*2;

w3 = z.*cos(fc3 * t);
w3 = ece301conv(w3, h);
w3 = w3.*2;


%% Graphing 
f = f_sample*(0:19999)/100000;

figure;
subplot(3,3,1);
plot(t, x1_lpf, t, w1);
title('x1 demodulated over x1 lpf');

subplot(3,3,4); 
plot(t, x2_lpf, t, w2);
title('x2 demodulated over x2 lpf');

subplot(3,3,7);
plot(t, x3_lpf, t, w3);
title('x3 demodulated over x3 lpf');


subplot(3,3,2);
plot(t, x1_lpf, t, w1);
title('x1 demodulated over x1 lpf zoomed');
axis([-2.28, -2.255, -0.08 0.08]);

subplot(3,3,5);
plot(t, x2_lpf, t, w2);
title('x2 demodulated over x2 lpf zoomed');
axis([-2.28, -2.255, -0.08 0.08]);

subplot(3,3,8);
plot(t, x3_lpf, t, w3);
title('x3 demodulated over x3 lpf zoomed');
axis([-2.28, -2.255, -0.08 0.08]);

y1fft = abs(fft(y1));
y1fft = y1fft(1:20000);

subplot(3,3,3);
plot(f, y1fft);

y2fft = abs(fft(y2));
y2fft = y2fft(1:20000);

subplot(3,3,6);
plot(f, y2fft);

y3fft = abs(fft(y3));
y3fft = y3fft(1:20000);

subplot(3,3,9);
plot(f, y3fft);
