function [outputQamStream,Wk] = ofdm_demod(signal,frameSize,prefixLength,paddingSize,trainblock,Lt,n)
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
    numFrames = length(roundedSignal)/(dftSize + prefixLength);
    withPrefixTime = reshape(roundedSignal,dftSize + prefixLength,numFrames); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:end,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    % Initial channel estimation
    h = zeros(frameSize,1);
    temp = zeros(dftSize,numFrames);
    for j=1:frameSize
       h(j) = mean(withoutPrefix(j+1,1:Lt))/trainblock(j); 
    end
    channelEst = [0;h;0;flipud(conj(h))];
    
    mu = 0.4;
    alpha = 0.5;
    Wk = zeros(dftSize,numFrames+1);
    Wk(:,1) = 1./conj(channelEst);
    
    for i =1:frameSize
        for L = 1:numFrames-Lt
           temp(i,L) = withoutPrefix(i,Lt+L)*conj(Wk(i,L));
           Xk = qam_demod(withoutPrefix(i,L+1),n);
           Xk = qam_mod(Xk,n);
           Wk(i,L+1) = Wk(i,L) + mu/(alpha + conj(withoutPrefix(i,L+1))*withoutPrefix(i,L+1)) * withoutPrefix(i,L+1) * conj(Xk - conj(Wk(i,L))*withoutPrefix(i,L+1));
        end
    end
    qamParallel = temp(2:frameSize+1,:); %Remove complex conjugate
    outputQamStream = reshape(qamParallel,1,[]); %Serialize
    outputQamStream = outputQamStream(1:length(outputQamStream)-paddingSize); %Remove padding
end