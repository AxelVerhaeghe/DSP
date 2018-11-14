function y = ofdm_demod_onoff(signal,frameSize,prefixLength, paddingSize,channel,usableFrequencies)
%OFDM_DEMOD demodulates the input OFDM signal back to an QAM signal.
    nbUsableFrequencies = length(usableFrequencies);
    dftSize = 2*frameSize + 2 + prefixLength;
    nbFrames = length(signal)/dftSize;
    
    withPrefixTime = reshape(signal,dftSize,nbFrames); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:dftSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    channelFreq = fft(channel,dftSize-prefixLength); %Convert channel response to frequency domain
    withoutPrefixScaled = withoutPrefix./channelFreq; %Compensate for channel
    
    qamParallel = zeros(nbUsableFrequencies,nbFrames);
    for i = 1:nbUsableFrequencies
       qamParallel(i,:) = withoutPrefixScaled(usableFrequencies(i),:); 
    end
    
    y = reshape(qamParallel,1,[]); %Serialize
    y = y(1:length(y)-paddingSize); %Remove padding
end