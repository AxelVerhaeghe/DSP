%% PREAMBLE
clear();
N = 512;
frameSize = N/2-1;
n = 3;
len = (N/2-1)*n;
fs = 16000;
prefixLength = 500;
Lt = 5;
Ld = 25;

trainBlockBits = randi([0,1],1,len);
trainblock = qam_mod(trainBlockBits,n);

%% Modulation
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,n);

% OFDM modulation
[ofdmStream,paddingSize] = ofdm_mod(qamStream, frameSize, prefixLength, trainblock, Lt);

%% TRANSMISSION
% Transmit through channel
pulseFreq = 300;
pulseT = 0:1/fs:0.25;
pulse = 4*sin(2*pi*pulseFreq*pulseT);
[simin, nbsecs, fs] = initparams(ofdmStream, fs, pulse);
sim('recplay');
out = simout.signals.values;
afterChannel = alignIO(out,pulse);

%% Demodulation
% OFDM demodulation
[rxQamStream,channelEst] = ofdm_demod(afterChannel, frameSize, prefixLength, paddingSize, trainblock, Lt, n);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,n);

%% Final processing
% Compute BER
bitErrorRate = ber(bitStream, rxBitStream);
fprintf("BER = %f%%\n",100*bitErrorRate);
% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title('Received image'); drawnow;