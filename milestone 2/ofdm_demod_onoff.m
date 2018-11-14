function y = ofdm_demod_onoff(signal,qamBlockSize,prefixLength, paddingSize,channel,usableFrequencies)
%OFDM_DEMOD demodulates the input OFDM signal back to an QAM signal.
    nbUsableFrequencies = length(usableFrequencies);
    frameSize = 2*qamBlockSize + 2 + prefixLength;
    nbFrames = length(signal)/frameSize;
    
    withPrefixTime = reshape(signal,frameSize,[]); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:frameSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    channelFreq = fft(channel,frameSize-prefixLength); %Convert channel response to frequency domain
    withoutPrefixScaled = withoutPrefix./channelFreq; %Compensate for channel
    
    qamParallel = zeros(nbUsableFrequencies,nbFrames);
    for i = 1:nbUsableFrequencies
       qamParallel(i,:) = withoutPrefixScaled(usableFrequencies(i),:); 
    end
    
    y = reshape(qamParallel,1,[]); %Serialize
    y = y(1:length(y)-paddingSize); %Remove padding
end