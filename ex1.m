%% Generating constants

duration = 8;
f_sample = 44100;
t=(((0-4)*f_sample+0.5):((duration-4)*f_sample-0.5))/f_sample;

% Loading in audio files

[x1, f_sample, N] = wavread('x1');
x1=x1';

subplot(2,2,1);
plot(t, x1);


%sound(x1,f_sample);

h = sin(pi * 1000 * t) ./ (pi * t);
%subplot(2,2,2);
%plot(t,h);


%objective 4
x1_lpf = ece301conv(x1, h);
subplot(2,2,2);
plot(t, x1,t,x1_lpf);

legend('x1', 'x1_lpf');

axis([-2.28, -2.255, -0.08 0.08]);

%objective 5

y = x1_lpf.*cos(4000 * t);
z1double = fft(y);
f1double = [0:length(z1double)-1]*f_sample/length(z1double)/2;

sound(y,f_sample);

subplot(2,2,3);
plot(f1double, z1double);

%objective 6
w = y.*cos(4000 *t);
w = ece301conv(w, h);
w = w.*2;



subplot(2,2,4);
plot(t,x1_lpf, t, w);

legend('x1_lpf', 'w');

axis([-2.28, -2.255, -0.08 0.08]);
%axis([-2.2715, -2.2685, 0.025, 0.052]);
