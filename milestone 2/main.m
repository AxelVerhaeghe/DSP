% Exercise session 4: DMT-OFDM transmission scheme

clear();
n = 3;
prefixLength = 10;
qamBlockSize = 127;
snr = 10;

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,n);

% OFDM modulation
[ofdmStream,paddingSize] = ofdm_mod(qamStream,qamBlockSize,prefixLength);
ofdmStreamWithNoise = awgn(ofdmStream,snr,'measured');

% Channel
rxOfdmStream = ofdmStreamWithNoise;

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream,qamBlockSize,prefixLength,paddingSize);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,n);
rxBitStream = transpose(rxBitStream);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
