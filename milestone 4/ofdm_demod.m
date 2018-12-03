function [outputQamStream,W] = ofdm_demod(signal,frameSize,prefixLength,paddingSize,trainblock,Lt,n)
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
% - Lt:                 Amount of training frames per block
%
%OUTPUT:
% - outputQamStream:    The demodulated signal
% - channelEst:         The channel frequencyresponse

    dftSize = 2*frameSize + 2;
    remainder = mod(length(signal),(dftSize+prefixLength));
    roundedSignal = signal(1:end-remainder);
    withPrefixTime = reshape(roundedSignal,dftSize + prefixLength,[]); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:end,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    % Initial channel estimation
    h = zeros(frameSize,1);
    for j=1:frameSize
       h(j) = mean(withoutPrefix(j+1,1:Lt))/trainblock(j); 
    end
    qamParallel = withoutPrefix(2:frameSize+1,Lt+1:end); %Remove complex conjugate and training frames
    [~,numDataFrames] = size(qamParallel);
    temp = zeros(frameSize,numDataFrames);

    mu = 0.9;
    alpha = 1;
    W = zeros(frameSize,numDataFrames);
    Win = 1./conj(h);
    for i=1:frameSize
        [temp(i,:),W(i,:)] = DDequal(qamParallel(i,:),Win(i),n,mu,alpha);
    end
    outputQamStream = reshape(temp,1,[]); %Serialize
    outputQamStream = outputQamStream(1:length(outputQamStream)-paddingSize); %Remove padding
end