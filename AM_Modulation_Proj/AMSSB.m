function [y] = AMSSB(ch)
% Written by Nick Molo and Damian Parton
% ch = 1, 2, 3, 4, 5, 6
% ch is the channel you want to tune in to

% MODULATION was done in function AMSSB_mod.m
% Givens from modulation
Wm = 142;
w_a = 2 * Wm; % Wanted 0-1khz
w_b = 2.25 * w_a; % Wanted 1.25-2.25kHz
w_c = 3.5 * w_a; % Wanted 2.5-3.5kHz
w_d = 4.75 * w_a; % Wanted 3.75-4.75kHz
w_e = 6 * w_a; % Wanted 5-6kHz
w_f = 7.25 * w_a; % Wanted 6.25-7.25kHz

% Other givens
duration = 8;
f_sample = 44100;
t = (((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;
[radio2,f_sample,N]=wavread('radio2');
x = radio2';
f = f_sample * (1:20000)/100000;


% DEMODULATION
if ch == 1
    w_cutoff = w_a;
    w_shift = 0;
    a = 4;
    attenuation = 100;
elseif ch == 2
    w_cutoff = w_b;
    w_shift = 3.5;
    a = 1.5;
    attenuation = 1;
elseif ch == 3
    w_cutoff = w_c;
    w_shift = 4.5;
    attenuation = 100;
    a = 1;
elseif ch == 4
    w_cutoff = w_d;
    w_shift = 4.9;
    attenuation = 100;
    a = .7;
elseif ch == 5
    w_cutoff = w_e;
    w_shift = 5.2;
    attenuation = 100;
    a = .55;
elseif ch == 6
    w_cutoff = w_f;
    w_shift = 5.4;
    attenuation = 100;
    a = .5;
else
    disp('Inappropriate channel value given');
end

% BP filter that slides to pick up desired channel
h_bpf =  2*w_cutoff*sinc(2*w_cutoff*t) .* sin(a*w_cutoff * t) .* exp(1i * -1000 *t);
output = ece301conv(h_bpf,x);



subplot(4,1,1);
my2fft = abs(fft(x));
my2fft = my2fft(1:20000);
plot(f, my2fft);
axis([0, 8000, 0, 200]);

subplot(4,1,2);
myfft = abs(fft(output));
myfft = myfft(1:20000);
plot(f, myfft);
axis([0, 8000, 0, 10]);

% soundsc(output, f_sample);

% Shift channel to center

out_shift = output .* exp(-1i*(w_shift)*w_cutoff*t);

%.* cos((w_cutoff+1500*ch)*t) 

subplot(4,1,3);
myfft = abs(fft(out_shift));
myfft = myfft(1:20000);
plot(f, myfft);
axis([0, 8000, 0, 200]);


% Single out left frequency and remove right frequency
%h_lpf_2 = 2*Wm*sinc((Wm)*t) .* cos(pi*(Wm)*t) .* exp(-1i*2*pi*Wm*t);
h_bpf2 =  2*w_cutoff*sinc(2*w_cutoff*t) .* sin(a*w_cutoff * t);

subplot(4,1,3);
myfft = abs(fft(h_bpf2.* exp(-1i*(-20)*w_cutoff*t)));
myfft = myfft(1:20000);
plot(f, myfft);


out_opposite = ece301conv(h_hpf,out_shift);

out_right = out_shift - out_opposite;


subplot(4,1,4);
myfft = abs(fft(out_opposite.* exp(-1i*(-20)*w_cutoff*t)));
myfft = myfft(1:20000);
plot(f, myfft);
axis([0, 8000, 0, 200]);

% Flip to get the right half
%out_right = conj(out_left);

% Add halves to get final demodulated output
% Multiply by 4 to correct magnitude loss via filtering
%out_final = 4 *(out_right + out_left);

% Save the final demodulated output
%soundsc(out_final* attenuation, f_sample);
%wavwrite(out_final * attenuation,f_sample,'output.wav');

end
