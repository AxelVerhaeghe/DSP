function [outputQamStream,channelEst] = ofdm_demod(signal,frameSize,prefixLength,paddingSize,trainblock,Lt,Ld)
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
% - Lt:                 Amount of training packets per block
% - Ld:                 Amount of datapackets per block
%
%OUTPUT:
% - outputQamStream:    The demodulated signal
% - channelEst:                  The channel frequencyresponse

    dftSize = 2*frameSize + 2 + prefixLength;
    remainder = mod(length(signal),dftSize);
    tempSignal = signal(1:length(signal)-remainder);
    divisible = false;
    while divisible == false
       numFrames = length(tempSignal)/dftSize;
       remainder = mod(numFrames,(Lt+Ld));
       if remainder == 0
           divisible = true;
       else
           tempSignal = tempSignal(1:length(tempSignal)-dftSize);
       end
    end
    
    numBlocks = numFrames/(Lt+Ld);
    
    withPrefixTime = reshape(tempSignal,dftSize,numFrames); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:dftSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    h = zeros(frameSize,numBlocks);
    temp = zeros(2*frameSize+2,numBlocks*Ld);
    channelEst = zeros(2*frameSize+2,numBlocks);
    for i=1:numBlocks
        for j=1:frameSize
           h(j,i) = mean(withoutPrefix(j+1,(i-1)*(Lt+Ld)+1:(i-1)*(Lt+Ld)+Lt))/trainblock(j); 
        end
        channelEst(:,i) = [0;h(:,i);0;flipud(conj(h(:,i)))];
        temp(:,(i-1)*Ld+1:i*Ld) = withoutPrefix(:,(i-1)*(Lt+Ld)+Lt+1:i*(Lt+Ld))./channelEst(:,i);
    end

    qamParallel = temp(2:frameSize+1,:); %Remove complex conjugate
    outputQamStream = reshape(qamParallel,1,[]); %Serialize
    outputQamStream = outputQamStream(1:length(outputQamStream)-paddingSize); %Remove padding
end