N = 512;
n = 3;
len = (N/2-1)*n;
fs = 16000;

input = transpose(randi([0,1],1,len));
trainblock = qam_mod(input,n);
qamSignal = repmat(trainblock,100,1); %repeating trainblock 100 times
[Tx,paddingSize] = ofdm_mod(qamSignal,N/2-1,0);
channel = load('IR2.mat');
h = channel.h;
H = channel.magH;
Rx = conv(Tx,h);

[output,channelEst] = ofdm_demod(Rx,N/2-1,0,paddingSize,trainblock);
output = output(1:length(trainblock));
outputBitstream = transpose(qam_demod(output,n));
berTrain = ber(input,outputBitstream);

magHPos = H(round(length(H)/2):length(H));
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

figure();
subplot(2,1,1) % plot of time domain impulse response
plot(h);
title('Time domain IR');
xlabel('Samples');

subplot(2,1,2) % plot of time domain impulse response
plot(ifft(channelEst));
title('Estimated impulse response');
xlabel('Samples');
