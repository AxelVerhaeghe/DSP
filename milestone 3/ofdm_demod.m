function [outputQamStream,H] = ofdm_demod(signal,frameSize,prefixLength, paddingSize,trainblock)
%OFDM_DEMOD demodulates the input OFDM signal back to an QAM signal.

    dftSize = 2*frameSize + 2 + prefixLength;
    numFrames = floor(length(signal)/dftSize);
    shorterSignal = signal(1:numFrames*dftSize);
    withPrefixTime = reshape(shorterSignal,dftSize,[]); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:dftSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    train = ofdm_mod(repmat(trainblock,100,1),frameSize,prefixLength);
    h = zeros(dftSize/2-1,1);
    for i=2:dftSize/2-1
       h(i-1) = withoutPrefix(i)/train(i-1); 
    end
    H = [0;h;0;flipud(conj(h))];
    withoutPrefixScaled = withoutPrefix./H; %Compensate for channel
    
    qamParallel = withoutPrefixScaled(2:frameSize+1,:); %Remove complex conjugate
    outputQamStream = reshape(qamParallel,1,[]); %Serialize
    outputQamStream = outputQamStream(1:length(outputQamStream)-paddingSize); %Remove padding
end