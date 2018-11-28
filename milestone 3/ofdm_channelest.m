clear();
N = 512;
n = 3;
len = (N/2-1)*n;
fs = 16000;
prefixLength = 500;

input = transpose(randi([0,1],1,len));
trainblock = qam_mod(input,n);
qamSignal = repmat(trainblock,100,1); %repeating trainblock 100 times
[Tx,paddingSize] = ofdm_mod(qamSignal,N/2-1,prefixLength);

freq = 300;
t = 0:1/fs:0.25;
pulse = 4*sin(2*pi*freq*t);
% pulse = wgn(1,0.25*fs,1);
[simin, nbsecs, fs] = initparams( Tx, fs, pulse);
sim('recplay');
out = simout.signals.values;
Rx = alignIO(out,pulse);

% channel = load('IR2.mat');
% h = channel.h;
% H = channel.magH;
% Rx = conv(Tx,h);

[output,channelEst] = ofdm_demod(Rx,N/2-1,prefixLength,paddingSize,trainblock);
output = output(1:length(trainblock));
outputBitstream = transpose(qam_demod(output,n));
bitErrorRate = ber(input,outputBitstream);

figure();
plot(ifft(channelEst));
title('Time domain IR');
xlabel('Samples');

% magHPos = H(round(length(H)/2):length(H));
% f = linspace(0,fs/2,length(magHPos));
%
% figure();
% plotIRt = subplot(2,1,1); % plot of time domain impulse response
% plot(h);
% title('Time domain IR');
% xlabel('Samples');
% 
% plotIRf = subplot(2,1,2); % plot of frequency response
% plot(f,magHPos);
% title('Frequency domain IR');
% xlabel('Frequency (Hz)');
% 
% figure();
% plotIRtReal = subplot(2,1,1); % plot of time domain impulse response
% plot(h);
% title('Time domain IR');
% xlabel('Samples');
% 
% plotIRtEst = subplot(2,1,2); % plot of time domain impulse response
% plot(ifft(channelEst));
% title('Estimated impulse response');
% xlabel('Samples');
% 
% linkaxes([plotIRtReal, plotIRtEst],'xy');
% 
% figure();
% hold on
% plot(ifft(channelEst));
% plot(h);