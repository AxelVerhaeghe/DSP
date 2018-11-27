function y = ofdm_demod(signal,frameSize,prefixLength, paddingSize,Rx,trainblock)
%OFDM_DEMOD demodulates the input OFDM signal back to an QAM signal.

    dftSize = 2*frameSize + 2 + prefixLength;
    withPrefixTime = reshape(signal,dftSize,[]); %series to parallel
    withoutPrefixTime = withPrefixTime(prefixLength+1:dftSize,:); %Removing prefix
    withoutPrefix = fft(withoutPrefixTime); %convert to frequency domain
    
    train = repmat(trainblock,100,1);
    column = [train,zeros(1,(length(Rx)-length(train)))];
    row = [train(1),zeros(1,449)];
    X = toeplitz(column,row);

    % Solving equation
    h = X\Rx;
    H = fft(h);

    withoutPrefixScaled = withoutPrefix./H; %Compensate for channel
    
    qamParallel = withoutPrefixScaled(2:frameSize+1,:); %Remove complex conjugate
    y = reshape(qamParallel,1,[]); %Serialize
    y = y(1:length(y)-paddingSize); %Remove padding
end