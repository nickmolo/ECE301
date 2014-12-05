%% Written by Nick Molo and Damian Parton
% This generates the SSB audio file named radio2.wav

%% Givens
duration = 8;
f_sample = 44100;
t = (((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;
f = f_sample * (1:20000)/100000;
f2 = f_sample * (-9999:10000)/100000;

%% Load the samples
[x1, ~]=audioread('x1.wav');
x1=x1';

[x2, ~]=audioread('x2.wav');
x2=x2';

[x3, ~]=audioread('x3.wav');
x3=x3';

[x4, ~]=audioread('x4.wav');
x4=x4';

[x5, ~]=audioread('x5.wav');
x5=x5';

[x6, ~]=audioread('x6.wav');
x6=x6';

%% Initinal low pass filter

W=1000/pi;
h = 2 * W * sinc(2 * W * t);

%% Putting signals through low pass filter

x1_lpf = ece301conv(x1, h);
x2_lpf = ece301conv(x2, h);
x3_lpf = ece301conv(x3, h);
x4_lpf = ece301conv(x4, h);
x5_lpf = ece301conv(x5, h);
x6_lpf = ece301conv(x6, h);


%% Construct AM DSB signals

% Chosen carrier frequencies
fc1 = 320*pi;
fc2 = 1000*pi;
fc3 = 1700*pi;
fc4 = 2400*pi;
fc5 = 3100*pi;
fc6 = 3850*pi;

% Modulating filtered signal over carrier frequency
y1 = x1_lpf .* cos(fc1* t);
y2 = x2_lpf .* cos(fc2* t);
y3 = x3_lpf .* cos(fc3* t);
y4 = x4_lpf .* cos(fc4* t);
y5 = x5_lpf .* cos(fc5* t);
y6 = x6_lpf .* cos(fc6* t);

%% Single Side band lpf filter

% Removing lower side frequencies 
W1 = fc1/pi;
W2 = fc2/pi;
W3 = fc3/pi;
W4 = fc4/pi;
W5 = fc5/pi;
W6 = fc6/pi;


% Removing lower side filters
x1_ssb_lpf = 2 * W1 * sinc(2 * W1 * t) .* sin(fc1 * t);
x2_ssb_lpf = 2 * W2 * sinc(2 * W2 * t) .* sin(fc2 * t);
x3_ssb_lpf = 2 * W3 * sinc(2 * W3 * t) .* sin(fc3 * t);
x4_ssb_lpf = 2 * W4 * sinc(2 * W4 * t) .* sin(fc4 * t);
x5_ssb_lpf = 2 * W5 * sinc(2 * W5 * t) .* sin(fc5 * t);
x6_ssb_lpf = 2 * W6 * sinc(2 * W6 * t) .* sin(fc6 * t);

% convolution 
z1 = ece301conv(y1, x1_ssb_lpf); 
z2 = ece301conv(y2, x2_ssb_lpf); 
z3 = ece301conv(y3, x3_ssb_lpf); 
z4 = ece301conv(y4, x4_ssb_lpf); 
z5 = ece301conv(y5, x5_ssb_lpf); 
z6 = ece301conv(y6, x6_ssb_lpf); 

% adding signals together
total = z1 +z2 +z3 +z4 + z5 + z6;

%% Demodulation

r1 = ece301conv(total, x1_ssb_lpf);
r2 = ece301conv(total, x2_ssb_lpf);
r3 = ece301conv(total, x3_ssb_lpf);
r4 = ece301conv(total, x4_ssb_lpf);
r5 = ece301conv(total, x5_ssb_lpf);
r6 = ece301conv(total, x6_ssb_lpf);

s1 = r1 .* exp(-1i * fc1 * t);
s2 = r2 .* exp(-1i * fc2 * t);
s3 = r3 .* exp(-1i * fc3 * t);
s4 = r4 .* exp(-1i * fc4 * t);
s5 = r5 .* exp(-1i * fc5 * t);
s6 = r6 .* exp(-1i * fc6 * t);

t1 = ece301conv(r1, h);
t2 = ece301conv(r2, h);
t3 = ece301conv(r3, h);
t4 = ece301conv(r4, h);
t5 = ece301conv(r5, h);
t6 = ece301conv(r6, h);

u1 = r1 .* 4;
u2 = r2 .* 8;
u3 = r3 .* 4;
u4 = r4 .* 4;
u5 = r5 .* 4;
u6 = r6 .* 4;

 


%% plot stuff yo
% 
% figure(1);
% myfft1 = abs(fft(x2_ssb_lpf));
% myfft1 = myfft1(1:20000);
% myfft = abs(fft(total));
% myfft = myfft(1:20000);
% plot(f, myfft,f, myfft1);
% axis([1000, 4000, 0, 150]); 


figure(2);
subplot(5,1,1);
y1fft = abs(fft(x2_lpf));
y1fft = y1fft(1:20000);
plot(f, y1fft);
title('original lpf signal');

subplot(5,1,2);
y1fft = abs(fft(r2));
y1fft = y1fft(1:20000);
plot(f, y1fft);
title('after pass through of carrier lpf');


subplot(5,1,3);
y2fft = abs(fft(x2_lpf));
y2fft = y2fft(1:20000);
y1fft = abs(fft(s2));
y1fft = y1fft(1:20000);
plot(f, y1fft, f, y2fft);
title('second lpf and shift');
axis([0, 1000, 0, 1000]);


subplot(5,1,4);
plot(t, x2_lpf, t, u2);
title('original signal overlayed demodulated signal');
 
subplot(5,1,5);
plot(t, x2_lpf, t, u2);
axis([-3, -2.95, -0.08 0.08]);
title('zoomed above');

 
%% Write back sound to file 

%soundsc(x2_lpf, f_sample);
%soundsc(real(u2), f_sample);

