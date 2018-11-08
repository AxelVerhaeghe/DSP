function y = ofdm_demod(signal,qamBlockSize,prefixLength, paddingSize)
    frameSize = 2*qamBlockSize + 2 + prefixLength;
    with_prefix_time = reshape(signal,frameSize,[]);
    without_prefix_time = with_prefix_time(prefixLength+1:frameSize,:);
    without_prefix = fft(without_prefix_time);
    qamParallel = without_prefix(2:qamBlockSize+1,:);
    y = reshape(qamParallel,1,[]);
    y = y(1:length(y)-paddingSize);
end