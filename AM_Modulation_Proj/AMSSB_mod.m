function [y] = AMSSB_mod()
% Written by Nick Molo and Damian Parton
% Givens
duration = 8;
f_sample = 44100;
t = (((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;
f = f_sample * (1:20000)/100000;

% Load the samples
[x1, f_sample, N]=wavread('x1');
x1=x1';
[x2, f_sample, N]=wavread('x2');
x2=x2';
[x3, f_sample, N]=wavread('x3');
x3=x3';
[x4, f_sample, N]=wavread('x4');
x4=x4';
[x5, f_sample, N]=wavread('x5');
x5=x5';
[x6, f_sample, N]=wavread('x6');
x6=x6';

% MODULATION
Wm = 142;
w_a = 2 * Wm; % Want 0-1khz
w_b = 2.25 * w_a; % Want 1.25-2.25kHz
w_c = 3.5 * w_a; % Want 2.5-3.5kHz
w_d = 4.75 * w_a; % Want 3.75-4.75kHz
w_e = 6 * w_a; % Want 5-6kHz
w_f = 7.25 * w_a; % Want 6.25-7.25kHz

% Initial LP filter
h_lpf = 2*Wm*sinc(2*Wm*t) .* cos(2*pi*Wm*t);

% SSB LP filters
h_lpf_x1 = 2*w_a*sinc(w_a*t) .* cos(w_a*pi*t);
h_lpf_x2 = 2*w_a*sinc(w_b*t) .* cos(w_b*pi*t);
h_lpf_x3 = 2*w_a*sinc(w_c*t) .* cos(w_c*pi*t);
h_lpf_x4 = 2*w_a*sinc(w_d*t) .* cos(w_d*pi*t);
h_lpf_x5 = 2*w_a*sinc(w_e*t) .* cos(w_e*pi*t);
h_lpf_x6 = 2*w_a*sinc(w_f*t) .* cos(w_f*pi*t);

% Individual modulated signals
x1_mod = ece301conv(x1,h_lpf);
x2_mod = ece301conv(x2,h_lpf) .* cos(2*pi*w_b*t);
x3_mod = ece301conv(x3,h_lpf) .* cos(2*pi*w_c*t);
x4_mod = ece301conv(x4,h_lpf) .* cos(2*pi*w_d*t);
x5_mod = ece301conv(x5,h_lpf) .* cos(2*pi*w_e*t);
x6_mod = ece301conv(x6,h_lpf) .* cos(2*pi*w_f*t);

wavwrite(x1_mod,f_sample,'x1mod.wav');
wavwrite(x2_mod,f_sample,'x2mod.wav');
wavwrite(x3_mod,f_sample,'x3mod.wav');
wavwrite(x4_mod,f_sample,'x4mod.wav');
wavwrite(x5_mod,f_sample,'x5mod.wav');
wavwrite(x6_mod,f_sample,'x6mod.wav');

% SSB modulated signals
x1_mod_final = ece301conv(x1_mod,h_lpf_x1);
x2_mod_final = ece301conv(x2_mod,h_lpf_x2);
x3_mod_final = ece301conv(x3_mod,h_lpf_x3);
x4_mod_final = ece301conv(x4_mod,h_lpf_x4);
x5_mod_final = ece301conv(x5_mod,h_lpf_x5);
x6_mod_final = ece301conv(x6_mod,h_lpf_x6);

% Final combination of modulated signals
mod_final = x1_mod_final + x2_mod_final + x3_mod_final + x4_mod_final + x5_mod_final + x6_mod_final;

% Plot of frequency domain of final output
%modfft = abs(fft(mod_final));
%modfft = modfft(1:20000);
%plot(f,modfft);
%title('Final Output in Freq. Domain');

wavwrite(mod_final,f_sample,'radio2.wav');

end
