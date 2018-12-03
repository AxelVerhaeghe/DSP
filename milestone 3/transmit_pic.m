%% PREAMBLE

N = 1024;
n = 3;
len = (N/2-1)*n;
fs = 16000;
prefixLength = 500;
Lt = 5;
Ld = 25;

trainBlockBits = randi([0,1],1,len);
trainblock = qam_mod(trainBlockBits,n);

%% CHANNEL ESTIMATION
qamSignalChannelEst = repmat(trainblock,Ld,1); %repeating trainblock
[Tx,paddingSizeChannelEst] = ofdm_mod(qamSignalChannelEst,N/2-1,prefixLength,trainblock,Lt,Ld);
pulseFreqChannelEst = 300;
pulseTChannelEst = 0:1/fs:0.25;
pulseChannelEst = 4*sin(2*pi*pulseFreqChannelEst*pulseTChannelEst);
[simin, nbsecs, fs] = initparams(Tx, fs, pulseChannelEst);
sim('recplay');
out = simout.signals.values;
Rx = alignIO(out,pulseChannelEst);
[~,channel] = ofdm_demod(Rx(1:length(qamSignalChannelEst)),N/2-1,prefixLength,paddingSizeChannelEst,trainblock,Lt,Ld);
channel = channel(:,2:length(channel)/2-1);
channel = mean(channel,2);

nbUsableFreqs = floor((N/2-1)*BWusage/100);
[~,usableFreqs] = maxk(channel,nbUsableFreqs,'ComparisonMethod','abs');
usableFreqs = sort(usableFreqs);

%% ACTUAL IMAGE
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,n);

% OFDM modulation
[ofdmStream,paddingSize] = ofdm_mod_onoff(qamStream, N/2-1, prefixLength, usableFreqs, trainblock, Lt, Ld);

% Transmit through channel
pulseFreq = 300;
pulseT = 0:1/fs:0.25;
pulse = 4*sin(2*pi*pulseFreq*pulseT);
[simin, nbsecs, fs] = initparams(ofdmStream, fs, pulse);
sim('recplay');
out = simout.signals.values;
afterChannel = alignIO(out,pulse);

% OFDM demodulation
[rxQamStream,channelEst] = ofdm_demod_onoff(afterChannel, N/2-1, prefixLength, paddingSize, usableFreqs, trainblock, Lt, Ld);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,n);

% Compute BER
bitErrorRate = ber(bitStream, rxBitStream);
fprintf("BER = %f%%\n",100*bitErrorRate);
% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title('Received image'); drawnow;