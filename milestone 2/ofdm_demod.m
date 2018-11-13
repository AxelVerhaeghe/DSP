function y = ofdm_demod(signal,qamBlockSize,prefixLength, paddingSize,channel)
%OFDM_DEMOD demodulates the input OFDM signal back to an QAM signal.

    frameSize = 2*qamBlockSize + 2 + prefixLength;
    withPrefixTime = reshape(signal,frameSize,[]); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:frameSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    channelFreq = fft(channel,frameSize-prefixLength); %Convert channel response to frequency domain
    withoutPrefixScaled = withoutPrefix./channelFreq; %Compensate for channel
    
    qamParallel = withoutPrefixScaled(2:qamBlockSize+1,:); %Remove complex conjugate
    y = reshape(qamParallel,1,[]); %Serialize
    y = y(1:length(y)-paddingSize); %Remove padding
end