% Exercise session 4: DMT-OFDM transmission scheme

clear();
n = 6;
frameSize = 700;
snr = 20;
channel = load('IR2.mat');
channelImpulseResponse = channel.h;
channelFrequencyResponse = fft(channelImpulseResponse);
channelOrder = length(channelImpulseResponse);
prefixLength = channelOrder*1.3;
fs = 16000;
gamma = 10;

% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% adaptive QAM modulation
b = zeros(1,length(channelFrequencyResponse)/2 - 1);
Psignal = abs(fft(bitStream)).^2;
for k=1:length(channelFrequencyResponse)/2-1
    b(k) = floor(log2(1 + (abs(channelFrequencyResponse(k))^2/(gamma*Psignal(k)/10^(snr/10)))));
    if b(k) > 6
        b(k) = 6;
    end
    if b(k) < 2
            b(k) = 2;
    end
end

[qamStream,qamPaddingSize] = qam_mod_adapt(bitStream,b);

% OFDM modulation
[ofdmStream,ofdmPaddingSize] = ofdm_mod(qamStream,frameSize,prefixLength);
ofdmStreamWithNoise = awgn(ofdmStream,snr,'measured');

% Channel
afterChannel = fftfilt(channelImpulseResponse,ofdmStreamWithNoise);

% OFDM demodulation
rxQamStream = ofdm_demod(afterChannel,frameSize,prefixLength,ofdmPaddingSize,channelImpulseResponse);

% QAM demodulation
rxBitStream = qam_demod_adapt(rxQamStream,b,qamPaddingSize);
rxBitStream = transpose(rxBitStream);

% Compute BER
berTransmission = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
figure();
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title('Received image'); drawnow;
