function [outputQamStream,H] = ofdm_demod(signal,frameSize,prefixLength, paddingSize,trainblock)
%OFDM_DEMOD demodulates the input OFDM signal back to a QAM signal and
%estimates the channel response.
%
%INPUT:
% - signal:             The OFDM-modulated signal
% - frameSize:          The size of the frames containing data
% - prefixLength:       The length of the prefix added during the OFDM
%                       modulation
% - paddingSize:        The amount of zeros added during the OFDM
%                       modulation
% - trainblock:         The bitstream used for channel estimation
%
%OUTPUT:
% - outputQamStream:    The demodulated signal
% - H:                  The channel frequencyresponse

    dftSize = 2*frameSize + 2 + prefixLength;
    numFrames = floor(length(signal)/dftSize);
    shorterSignal = signal(1:numFrames*dftSize);
    withPrefixTime = reshape(shorterSignal,dftSize,[]); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:dftSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
        
    h = zeros(frameSize,1);
    for i=1:frameSize
       h(i) = mean(withoutPrefix(i+1,:))/trainblock(i); 
    end
    H = [0;h;0;flipud(conj(h))];
    withoutPrefixScaled = withoutPrefix./H; %Compensate for channel

    qamParallel = withoutPrefixScaled(2:frameSize+1,:); %Remove complex conjugate
    outputQamStream = reshape(qamParallel,1,[]); %Serialize
    outputQamStream = outputQamStream(1:length(outputQamStream)-paddingSize); %Remove padding
end