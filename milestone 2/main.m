% Exercise session 4: DMT-OFDM transmission scheme

clear();
n = 3;
qamBlockSize = 500;
snr = 10;
channel = load('IR2.mat');
channelImpulseResponse = channel.h;
channelOrder = length(channelImpulseResponse);
prefixLength = channelOrder*1.3;
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
ht = ones(channelOrder,1);
for i=1:channelOrder
   ht(i) = rand(1); 
end

afterChannelRandom = fftfilt(ht,ofdmStreamWithNoise);
afterChannelAcoustic = fftfilt(channelImpulseResponse,ofdmStreamWithNoise);

% OFDM demodulation
rxQamStreamRandom = ofdm_demod(afterChannelRandom,qamBlockSize,prefixLength,paddingSize,ht);
rxQamStreamAcoustic = ofdm_demod(afterChannelAcoustic,qamBlockSize,prefixLength,paddingSize,channelImpulseResponse);

% QAM demodulation
rxBitStreamRandom = qam_demod(rxQamStreamRandom,n);
rxBitStreamRandom = transpose(rxBitStreamRandom);

rxBitStreamAcoustic = qam_demod(rxQamStreamAcoustic,n);
rxBitStreamAcoustic = transpose(rxBitStreamAcoustic);

% Compute BER
berTransmissionRandom = ber(bitStream,rxBitStreamRandom);
berTransmissionAcoustic = ber(bitStream,rxBitStreamAcoustic);

% Construct image from bitstream
imageRxRandom = bitstreamtoimage(rxBitStreamRandom, imageSize, bitsPerPixel);
imageRxAcoustic = bitstreamtoimage(rxBitStreamAcoustic, imageSize, bitsPerPixel);

% Plot images
figure();
subplot(2,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,2,2); colormap(colorMap); image(imageRxRandom); axis image; title(['Received image (Random Channel)']); drawnow;
subplot(2,2,3); colormap(colorMap); image(imageRxAcoustic); axis image; title(['Received image (Acoustic Channel (IR2))']); drawnow;
