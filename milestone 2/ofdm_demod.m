function y = ofdm_demod(signal,frameSize,prefixLength, paddingSize,channel)
%OFDM_DEMOD demodulates the input OFDM signal back to an QAM signal.

    dftSize = 2*frameSize + 2 + prefixLength;
    withPrefixTime = reshape(signal,dftSize,[]); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:dftSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    channelFreq = fft(channel,dftSize-prefixLength); %Convert channel response to frequency domain
    withoutPrefixScaled = withoutPrefix./channelFreq; %Compensate for channel
    
    qamParallel = withoutPrefixScaled(2:frameSize+1,:); %Remove complex conjugate
    y = reshape(qamParallel,1,[]); %Serialize
    y = y(1:length(y)-paddingSize); %Remove padding
end