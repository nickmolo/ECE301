%% Written by Nick Molo and Damian Parton
% This generates the SSB audio file named radio2.wav

%% Givens
duration = 8;
f_sample = 44100;
t = (((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;

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

W = 2*pi*1000;
h = sin(W * t) ./ (pi * t);

%% Putting signals through low pass filter

x1_lpf = ece301conv(x1, h);
x2_lpf = ece301conv(x2, h);
x3_lpf = ece301conv(x3, h);
x4_lpf = ece301conv(x4, h);
x5_lpf = ece301conv(x5, h);
x6_lpf = ece301conv(x6, h);


%% Chosen carrier frequencies

fc1 = 2*pi*1000;
fc2 = 2*pi*2100;
fc3 = 2*pi*3200;
fc4 = 2*pi*4300;
fc5 = 2*pi*5400;
fc6 = 2*pi*6500;

%% Single Side band lpf filter

% Removing lower side 
x1_ssb_lpf = sin(fc1 * t) ./ (pi * t);
x2_ssb_lpf = sin(fc2 * t) ./ (pi * t);
x3_ssb_lpf = sin(fc3 * t) ./ (pi * t);
x4_ssb_lpf = sin(fc4 * t) ./ (pi * t);
x5_ssb_lpf = sin(fc5 * t) ./ (pi * t);
x6_ssb_lpf = sin(fc6 * t) ./ (pi * t);

% Modulating filtered signal over carrier frequency
y1 = x1_lpf .* cos(fc1 * t);
y2 = x2_lpf .* cos(fc2 * t);
y3 = x3_lpf .* cos(fc3 * t);
y4 = x4_lpf .* cos(fc4 * t);
y5 = x5_lpf .* cos(fc5 * t);
y6 = x6_lpf .* cos(fc6 * t);

% convolution 
z1 = ece301conv(y1, x1_ssb_lpf); 
z2 = ece301conv(y2, x2_ssb_lpf); 
z3 = ece301conv(y3, x3_ssb_lpf); 
z4 = ece301conv(y4, x4_ssb_lpf); 
z5 = ece301conv(y5, x5_ssb_lpf); 
z6 = ece301conv(y6, x6_ssb_lpf); 

%% Generating Radio 2

total = z1 +z2 +z3 +z4 + z5 + z6;
audiowrite('radio2.wav', total, f_sample );

% 
% [radio2,f_sample,N] = wavread('radio2');
% radio2=radio2';
% 
% 
% ch = 5;
% % choosing which channel to restore
% if ch == 1 
%     k = fc1;
% elseif ch == 2
%     k = fc2;
% elseif ch == 3
%     k = fc3;
% elseif ch == 4
%     k = fc4;
% elseif ch == 5
%     k = fc5;
% elseif ch == 6
%     k = fc6;
% end
% 
% bpf = sin(k*t)./(pi*t) - sin((k-2*pi*1000)*t)./(pi*t);
% w_bpf = ece301conv(radio2, bpf);
% w = w_bpf .* 4.*cos(k * t);
% 
% w = ece301conv(w, h);
% soundsc(w, f_sample);

