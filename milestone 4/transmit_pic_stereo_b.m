%% PREAMBLE
clear();
N = 512;
frameSize = N/2-1;
n = 3;
len = frameSize*n;
fs = 16000;
prefixLength = 500;
Lt = 5;
Ld = 25;

%% INITIAL CHANNEL ESTIMATION MODULATION
input = transpose(randi([0,1],1,len));
trainblock = qam_mod(input,n);
aMono = ones(1,N+prefixLength);
bMono = zeros(1,N+prefixLength);

[Tx1, Tx2,paddingSize] = ofdm_mod_stereo(trainblock,frameSize,prefixLength,trainblock,100,1,aMono,bMono);

%% INITIAL CHANNEL ESTIMATION TRANSMISSION
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

%% INITIAL CHANNEL ESTIMATION DEMODULATION
[output1,channelEst1] = ofdm_demod_stereo(Rx1,frameSize,prefixLength,paddingSize,trainblock,100,1);
output1 = output1(1:length(trainblock));
outputBitstream1 = transpose(qam_demod(output1,n));
bitErrorRate1 = ber(input,outputBitstream1);

[output2,channelEst2] = ofdm_demod_stereo(Rx2,frameSize,prefixLength,paddingSize,trainblock,100,1);
output2 = output2(1:length(trainblock));
outputBitstream2 = transpose(qam_demod(output2,n));
bitErrorRate2 = ber(input,outputBitstream2);

%% INITIAL CHANNEL ESTIMATION PLOTS
% figure();
% plot(abs(ifft(channelEst1)));hold on;plot(abs(ifft(channelEst2)));
% title('Time domain IR');xlabel('Samples');legend('channeEst1','channelEst2');
% 
% figure();
% plot(20*log10(abs(channelEst1(length(channelEst1)/2+1:end))));hold on;plot(20*log10(abs(channelEst2(length(channelEst2)/2+1:end))));
% title('Channel frequency response');legend('channelEst1','channelEst2');

%% STEREO PREAMBLE
[a,b,Htot] = fixed_transmitter_side_beamformer(channelEst1,channelEst2,frameSize);

%% MODULATION
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,n);

% OFDM modulation
[ofdmStream1,ofdmStream2,paddingSize] = ofdm_mod_stereo(qamStream, frameSize, prefixLength, trainblock, Lt, Ld, a, b);
[ofdmStream1Mono,ofdmStream2Mono,paddingSize] = ofdm_mod_stereo(qamStream, frameSize, prefixLength, trainblock, Lt, Ld, aMono, bMono);

%% TRANSMISSION
% Transmit through channel
[simin, nbsecs, fs] = initparams_stereo(ofdmStream1, ofdmStream2, fs, pulse);
sim('recplay');
out = simout.signals.values;
afterChannel = alignIO(out,pulse);

[simin, nbsecs, fs] = initparams_stereo(ofdmStream1Mono, ofdmStream2Mono, fs, pulse);
sim('recplay');
out = simout.signals.values;
afterChannelMono1 = alignIO(out,pulse);

[simin, nbsecs, fs] = initparams_stereo(ofdmStream2Mono, ofdmStream1Mono, fs, pulse);
sim('recplay');
out = simout.signals.values;
afterChannelMono2 = alignIO(out,pulse);

%% DEMODULATION
% OFDM demodulation
[rxQamStream,channelEst] = ofdm_demod_stereo(afterChannel, frameSize, prefixLength, paddingSize, trainblock, Lt, Ld);
[rxQamStreamMono1,channelEstMono1] = ofdm_demod_stereo(afterChannelMono1, frameSize, prefixLength, paddingSize, trainblock, Lt, Ld);
[rxQamStreamMono2,channelEstMono2] = ofdm_demod_stereo(afterChannelMono2, frameSize, prefixLength, paddingSize, trainblock, Lt, Ld);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,n);
rxBitStreamMono1 = qam_demod(rxQamStreamMono1,n);
rxBitStreamMono2 = qam_demod(rxQamStreamMono2,n);

%% FINAL PROCESSING
% Compute BER
bitErrorRate = ber(bitStream, rxBitStream);
fprintf("Stereo: BER = %f%%\n",100*bitErrorRate);

bitErrorRateMono1 = ber(bitStream, rxBitStreamMono1);
fprintf("Mono 1: BER = %f%%\n",100*bitErrorRateMono1);

bitErrorRateMono2 = ber(bitStream, rxBitStreamMono2);
fprintf("Mono 2: BER = %f%%\n",100*bitErrorRateMono2);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);
imageRxMono1 = bitstreamtoimage(rxBitStreamMono1, imageSize, bitsPerPixel);
imageRxMono2 = bitstreamtoimage(rxBitStreamMono2, imageSize, bitsPerPixel);

% Plot images
subplot(2,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,2,2); colormap(colorMap); image(imageRx); axis image; title('Received image(stereo)'); drawnow;
subplot(2,2,3); colormap(colorMap); image(imageRxMono1); axis image; title('Received image(Mono 1)'); drawnow;
subplot(2,2,4); colormap(colorMap); image(imageRxMono2); axis image; title('Received image(Mono 2)'); drawnow;