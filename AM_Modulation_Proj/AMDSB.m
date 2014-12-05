function [ y ] =AMDSB(ch)
%% Written by Nick Molo and Damian Parton
% ch: is an input deciding which signal you would like to tune into.
% ch = 1, 2, 3 for AM-DSB

%% Generating Constants
duration=8;
f_sample=44100;
t=(((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;

%% Loading in radio file
[radio1, ~] = audioread('radio1.wav');
radio1=radio1';

%% Low Pass filter creation
Wc =1000;
h = sin(2*pi*1000*t)./(pi*t);

%% Frequencies decided upon
fc1 = 2*pi*1000;
fc2 = 2*pi*3200;
fc3 = 2*pi*5400;

%% Demodulation

% choosing which channel to restore
if ch == 1 
    k =fc1;
elseif ch == 2
    k = fc2;
elseif ch == 3
    k = fc3;
end

w = radio1 .* 2 .* cos(k * t);
w = ece301conv(w, h);


% Playback
soundsc(w, f_sample);
    

