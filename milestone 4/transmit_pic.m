%% PREAMBLE
dftSize = 512;
frameSize = dftSize/2-1;
n = 4;
len = frameSize*n;
fs = 16000;
prefixLength = 200;
Lt = 25;

trainBlockBits = randi([0,1],1,len);
trainblock = qam_mod(trainBlockBits,n);

%% CHANNEL ESTIMATION
channelEstQamSignal = trainblock;
[Tx,paddingSizeChannelEst] = ofdm_mod(channelEstQamSignal,frameSize,prefixLength,trainblock,100);
pulseFreqChannelEst = 300;
pulseTChannelEst = 0:1/fs:0.25;
pulseChannelEst = 4*sin(2*pi*pulseFreqChannelEst*pulseTChannelEst);
[simin, nbsecs, fs] = initparams(Tx, fs, pulseChannelEst);
sim('recplay');
out = simout.signals.values;
Rx = alignIO(out,pulseChannelEst);
[~,channel] = ofdm_demod(Rx(1:length(Tx)),frameSize,prefixLength,paddingSizeChannelEst,trainblock,100,n);

nbUsableFreqs = floor(frameSize*BWusage/100);
[~,usableFreqs] = maxk(channel,nbUsableFreqs,'ComparisonMethod','abs');
usableFreqs = sort(usableFreqs);

%% MODULATION
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,n);

% OFDM modulation
[ofdmStream,paddingSize] = ofdm_mod_onoff(qamStream,frameSize,prefixLength,usableFreqs,trainblock,Lt);

%% TRANSMISSION
% Transmit through channel
pulseFreq = 300;
pulseT = 0:1/fs:0.25;
pulse = 4*sin(2*pi*pulseFreq*pulseT);
[simin, nbsecs, fs] = initparams(ofdmStream, fs, pulse);
sim('recplay');
out = simout.signals.values;
afterChannel = alignIO(out,pulse);

%% DEMODULATION
% OFDM demodulation
[rxQamStream,channelEst] = ofdm_demod_onoff(afterChannel,frameSize,prefixLength,paddingSize,usableFreqs,trainblock,Lt,n);
channelEst = 1./conj(channelEst);
channelEst = [zeros(1,size(channelEst,2));channelEst;zeros(1,size(channelEst,2));flipud(conj(channelEst))];
% QAM demodulation
rxBitStream = qam_demod(rxQamStream,n);

%% FINAL PROCESSING
% Compute BER
bitErrorRate = ber(bitStream, rxBitStream);
fprintf("BER = %f%%\n",100*bitErrorRate);
% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
figure();
subplot(1,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(1,2,2); colormap(colorMap); image(imageRx); axis image; title('Received image'); drawnow;