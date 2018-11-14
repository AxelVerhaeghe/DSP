clear();
fs = 16000;
sig = [1,zeros(1,fs)];
[simin,nbsecs,fs] = initparams(sig,fs);
sim('recplay');
out = simout.signals.values;
outFiltered = out(35800:36250);%% Filtering out a window with usefull values to mimimize noise influence
frequencyOut = fft(outFiltered);%% Frequency equivalent of filtered output
magDBFrequencyOut = mag2db(abs(frequencyOut)); %% Convert to dB

magDBFrequencyOutPos = magDBFrequencyOut(round(length(magDBFrequencyOut)/2):length(magDBFrequencyOut));
f = linspace(0,fs/2,length(magDBFrequencyOutPos));

figure();
subplot(2,1,1) %% plot of time domain impulse response
plot(outFiltered);
title('Time domain IR');
xlabel('Samples');
subplot(2,1,2) %% plot of frequency response
plot(f,magDBFrequencyOutPos);
title('Frequency domain IR');
xlabel('Frequency (Hz)');
