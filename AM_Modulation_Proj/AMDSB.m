function [ y ] =AMDSB(ch)
% Written by Nick Molo and Damian Parton
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
Wc =1000/pi;
h = 2*Wc*sinc(2* Wc * t);

%% Frequencies decided upon
fc1 = 900*pi;
fc2 = 2500*pi;
fc3 = 3900*pi;

%% Demodulation

% choosing which channel to restore
if ch == 1 
    w = radio1.*cos(fc1 * t);
elseif ch == 2
    w = radio1.*cos(fc2 * t);
elseif ch == 3
    w = radio1.*cos(fc3 * t);
end

w = ece301conv(w, h);
w = w.*2;

% Playback
soundsc(w, f_sample);
    

