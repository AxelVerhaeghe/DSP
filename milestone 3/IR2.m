clear();
fs = 16000;
u = wgn(1,2*fs,1);
[simin,nbsecs,fs] = initparams(u,fs);
sim('recplay');
out = simout.signals.values;
% Selecting part of the output that is above threshold to eliminate noise
threshold = 0.005;
i = 1;
small = true;
while small
    if out(i) > threshold
        small = false;
        if i+length(u)+200 > length(out)
            y = out(length(out)-250-length(u):length(out));
        else
            y = out(i-50:i+length(u)+200);
        end
    end
    i = i + 1;
end
% creating toeplitz matrix
c = [u,zeros(1,(length(y)-length(u)))];
r = [u(1),zeros(1,449)];
X = toeplitz(c,r);

% Solving equation
h = X\y;
H = fft(h);
magH = mag2db(abs(H));
save('IR2.mat','h','magH');
magHPos = magH(round(length(magH)/2):length(magH));
f = linspace(0,fs/2,length(magHPos));

figure();
subplot(2,1,1) % plot of time domain impulse response
plot(h);
title('Time domain IR');
xlabel('Samples');

subplot(2,1,2) % plot of frequency response
plot(f,magHPos);
title('Frequency domain IR');
xlabel('Frequency (Hz)');
