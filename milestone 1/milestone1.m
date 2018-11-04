clear();
fs = 16000;
t = 0:1/fs:2;
dc = 0;
sig = wgn(1,2*fs,1);
[simin,nbsecs,fs] = initparams(sig,fs);
dftsize = 1024;
sim('recplay');
out = simout.signals.values;

% WHITE NOISE EXPERIMENT

% Spectogram for White noise experiment
figure();
subplot(2,1,1)
% Sent signal
[specSig,psdSig] = spectrogram(sig,dftsize,dftsize/2,dftsize,fs);
spectrogram(sig,dftsize,dftsize/2,dftsize,fs);
title('Spectogram for white noise experiment (Transmitted signal)');
% Received signal
subplot(2,1,2)
[specOut,psdOut] = spectrogram(out,dftsize,dftsize/2,dftsize,fs);
spectrogram(out,dftsize,dftsize/2,dftsize,fs);
title('Spectogram for white noise experiment (Received signal)');

% PSD for white noise experiment
figure();
% Sent signal
subplot(2,1,1)
pwelch(sig,dftsize,dftsize/2,dftsize,fs);
title('PSD for white noise experiment (Transmitted signal)');
axis([0 Inf -140 -20]);

%Received signal
subplot(2,1,2)
pwelch(out,dftsize,dftsize/2,dftsize,fs);
title('PSD for white noise experiment (Received signal)');
axis([0 Inf -140 -20]);

% IR2

% Selecting part of the output that is above threshold to eliminate noise
threshold = 0.005;
i = 1;
small = true;
while small
    if out(i) > threshold
        small = false;
        y = out(i-50:i+size(sig,2)+200);
    end
    i = i + 1;
end
% creating toeplitz matrix
c = [sig,zeros(1,(size(y,1)-size(sig,2)))];
r = [sig(1),zeros(1,449)];
X = toeplitz(c,r);

% Solving equation
h = X\y;
H = fft(h);
magH = mag2db(abs(H));

figure();
subplot(2,1,1) %% plot of time domain impulse response
plot(h);
title('Time domain IR (IR2)');
xlabel('Samples');
ylabel('Magnitude');
axis([0 Inf -5e-3 5e-3]);

subplot(2,1,2) %% plot of frequency response
plot(magH);
title('Frequency domain IR (IR2)');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB/Hz)');
axis([0 Inf -140 -20]);

% IR1

sig = [1,zeros(1,fs)];
[simin,nbsecs,fs] = initparams(sig,fs);
sim('recplay');
out = simout.signals.values;
% outFiltered = out(35800:36250);%% Filtering out a window with usefull values to mimimize noise influence
frequencyOut = fft(out);%% Frequency equivalent of filtered output
magDBFrequencyOut = mag2db(abs(frequencyOut)); %% Convert to dB

figure();
subplot(2,1,1) %% plot of time domain impulse response
plot(out);
title('Time domain IR (IR1)');
xlabel('Samples');
ylabel('Magnitude');
axis([0 Inf -5e-3 5e-3]);

subplot(2,1,2) %% plot of frequency response
plot(magDBFrequencyOut);
title('Frequency domain IR (IR1)');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB/Hz)');
axis([0 Inf -140 -20]);

