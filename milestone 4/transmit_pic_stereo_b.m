%% PREAMBLE
clear();
N = 512;
frameSize = N/2-1;
n = 3;
len = frameSize*n;
fs = 16000;
prefixLength = 500;

%% MODULATION
input = transpose(randi([0,1],1,len));
trainblock = qam_mod(input,n);
aMono = ones(1,N+prefixLength);
bMono = zeros(1,N+prefixLength);

[Tx1, Tx2,paddingSize] = ofdm_mod_stereo(trainblock,frameSize,prefixLength,trainblock,100,1,aMono,bMono);

%% TRANSMISSION
freq = 300;
t = 0:1/fs:0.25;
pulse = 4*sin(2*pi*freq*t);
[simin, nbsecs, fs] = initparams_stereo( Tx1, Tx2, fs, pulse);
sim('recplay');
out1 = simout.signals.values;
Rx1 = alignIO(out1,pulse);

[simin, nbsecs, fs] = initparams_stereo( Tx2, Tx1, fs, pulse);
sim('recplay');
out2 = simout.signals.values;
Rx2 = alignIO(out2,pulse);

%% DEMODULATION
[output1,channelEst1] = ofdm_demod_stereo(Rx1,frameSize,prefixLength,paddingSize,trainblock,100,1);
output1 = output1(1:length(trainblock));
outputBitstream1 = transpose(qam_demod(output1,n));
bitErrorRate1 = ber(input,outputBitstream1);

[output2,channelEst2] = ofdm_demod_stereo(Rx2,frameSize,prefixLength,paddingSize,trainblock,100,1);
output2 = output2(1:length(trainblock));
outputBitstream2 = transpose(qam_demod(output2,n));
bitErrorRate2 = ber(input,outputBitstream2);

%% PLOTS
figure();
plot(abs(ifft(channelEst1)));hold on;plot(abs(ifft(channelEst2)));
title('Time domain IR');xlabel('Samples');legend('channeEst1','channelEst2');

figure();
plot(20*log10(abs(channelEst1)));hold on;plot(20*log10(abs(channelEst2)));
title('Channel frequency response');legend('channelEst1','channelEst2');