% Exercise session 4: DMT-OFDM transmission scheme

clear();
n = 6;
frameSize = 500;
snr = 20;
channel = load('IR2.mat');
channelImpulseResponse = channel.h;
channelFrequencyResponse = fft(channelImpulseResponse);
channelOrder = length(channelImpulseResponse);
prefixLength = channelOrder*1.3;
fs = 16000;

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,n);

% OFDM modulation
[ofdmStream,paddingSize] = ofdm_mod(qamStream,frameSize,prefixLength);
[ofdmStreamOnOff,paddingSizeOnOff,usableFrequencies] = ofdm_mod_onoff(qamStream,frameSize,prefixLength,channelFrequencyResponse);
ofdmStreamWithNoise = awgn(ofdmStream,snr,'measured');
ofdmStreamWithNoiseOnOff = awgn(ofdmStreamOnOff,snr,'measured');

% Channel
% Random channel ht1
ht1 = ones(channelOrder,1);
for i=1:channelOrder
   ht1(i) = rand(1); 
end

afterChannelRandom1 = fftfilt(ht1,ofdmStreamWithNoise);
afterChannelAcousticOnOff = fftfilt(channelImpulseResponse,ofdmStreamWithNoiseOnOff);
afterChannelAcoustic = fftfilt(channelImpulseResponse,ofdmStreamWithNoise);

% OFDM demodulation
rxQamStreamRandom1 = ofdm_demod(afterChannelRandom1,frameSize,prefixLength,paddingSize,ht1);
rxQamStreamAcousticOnOff = ofdm_demod_onoff(afterChannelAcousticOnOff,frameSize,prefixLength,paddingSizeOnOff,channelImpulseResponse,usableFrequencies);
rxQamStreamAcoustic = ofdm_demod(afterChannelAcoustic,frameSize,prefixLength,paddingSize,channelImpulseResponse);

% QAM demodulation
rxBitStreamRandom1 = qam_demod(rxQamStreamRandom1,n);
rxBitStreamRandom1 = transpose(rxBitStreamRandom1);

rxBitStreamAcousticOnOff = qam_demod(rxQamStreamAcousticOnOff,n);
rxBitStreamAcousticOnOff = transpose(rxBitStreamAcousticOnOff);

rxBitStreamAcoustic = qam_demod(rxQamStreamAcoustic,n);
rxBitStreamAcoustic = transpose(rxBitStreamAcoustic);

% Compute BER
berTransmissionRandom1 = ber(bitStream,rxBitStreamRandom1);
berTransmissionAcousticOnOff = ber(bitStream,rxBitStreamAcousticOnOff);
berTransmissionAcoustic = ber(bitStream,rxBitStreamAcoustic);

% Construct image from bitstream
imageRxRandom1 = bitstreamtoimage(rxBitStreamRandom1, imageSize, bitsPerPixel);
imageRxAcousticOnOff = bitstreamtoimage(rxBitStreamAcousticOnOff, imageSize, bitsPerPixel);
imageRxAcoustic = bitstreamtoimage(rxBitStreamAcoustic, imageSize, bitsPerPixel);

% Plot images
figure();
subplot(2,2,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,2,2); colormap(colorMap); image(imageRxRandom1); axis image; title('Received image (Random Channel 1)'); drawnow;
subplot(2,2,3); colormap(colorMap); image(imageRxAcousticOnOff); axis image; title('Received image (Acoustic Channel (on/off keying))'); drawnow;
subplot(2,2,4); colormap(colorMap); image(imageRxAcoustic); axis image; title('Received image (Acoustic Channel)'); drawnow;
