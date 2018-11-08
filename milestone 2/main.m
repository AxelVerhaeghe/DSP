% Exercise session 4: DMT-OFDM transmission scheme

clear();
n = 3;
prefixLength = 200;
qamBlockSize = 500;
snr = inf;
inputChannel = load('IR2.mat');
channel = inputChannel.h;
channelOrder = length(channel);
fs = 16000;

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,n);

% OFDM modulation
[ofdmStream,paddingSize] = ofdm_mod(qamStream,qamBlockSize,prefixLength);
ofdmStreamWithNoise = awgn(ofdmStream,snr,'measured');

% Channel
% Random channel ht
ht = ones(1,channelOrder);
for i=1:channelOrder
   ht(i) = rand(1); 
end
afterChannelRandom = fftfilt(ht,ofdmStreamWithNoise);

[simin,nbsecs,fs] = initparams(ofdmStreamWithNoise,fs);
sim('recplay');
out = simout.signals.values;
% Selecting part of the output that is above threshold to eliminate noise
threshold = 0.005;
i = 1;
small = true;
while small
    if out(i) > threshold
        small = false;
        afterChannelAcoustic = out(i:i+length(ofdmStreamWithNoise)-1);
    end
    i = i + 1;
end

% OFDM demodulation
rxQamStreamRandom = ofdm_demod(afterChannelRandom,qamBlockSize,prefixLength,paddingSize,ht);
rxQamStreamAcoustic = ofdm_demod(afterChannelAcoustic,qamBlockSize,prefixLength,paddingSize,channel);

% QAM demodulation
rxBitStreamRandom = qam_demod(rxQamStreamRandom,n);
rxBitStreamRandom = transpose(rxBitStreamRandom);

rxBitstreamAcoustic = qam_demod(rxQamStreamAcoustic,n);
rxBitstreamAcoustic = transpose(rxBitstreamAcoustic);

% Compute BER
berTransmissionRandom = ber(bitStream,rxBitStreamRandom);
berTransmissionAcoustic = ber(bitStream,rxBitstreamAcoustic);

% Construct image from bitstream
imageRxRandom = bitstreamtoimage(rxBitStreamRandom, imageSize, bitsPerPixel);
imageRxAcoustic = bitstreamtoimage(rxBitStreamAcoustic, imageSize, bitsPerPixel);

% Plot images
subplot(2,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRxRandom); axis image; title(['Received image (Random Channel)']); drawnow;
subplot(2,1,3); colormap(colorMap); image(imageRxAcoustic); axis image; title(['Received image (Acoustic Channel)']); drawnow;
