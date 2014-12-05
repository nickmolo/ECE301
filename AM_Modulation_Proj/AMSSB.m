function [y] = AMSSB(ch)
% Written by Nick Molo and Damian Parton
% ch = 1, 2, 3, 4, 5, 6
% ch is the channel you want to tune in to

%% Givens
duration = 8;
f_sample = 44100;
t = (((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;

W = 2*pi*1000;
h = sin(W * t) ./ (pi * t);

%% Chosen carrier frequencies
fc1 = 2*pi*1000;
fc2 = 2*pi*2100;
fc3 = 2*pi*3200;
fc4 = 2*pi*4300;
fc5 = 2*pi*5400;
fc6 = 2*pi*6500;

%% Demodulation

[radio2,~] = audioread('radio2.wav');
radio2=radio2';

%% choosing which channel to restore
if ch == 1 
    k = fc1;
elseif ch == 2
    k = fc2;
elseif ch == 3
    k = fc3;
elseif ch == 4
    k = fc4;
elseif ch == 5
    k = fc5;
elseif ch == 6
    k = fc6;
end

bpf = sin(k*t)./(pi*t) - sin((k-2*pi*1000)*t)./(pi*t);
w_bpf = ece301conv(radio2, bpf);
w = w_bpf .* 4.*cos(k * t);

w = ece301conv(w, h);
soundsc(w, f_sample);



end