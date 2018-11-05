function ofdm = ofdm_mod(qamSignal,dftSize,L)
    signalLength   = length(qamSignal);
    frameLength  = 2*dftSize;
    numFrames = ceil(signalLength/dftSize);
    
    parallel = reshape(qamSignal,dftSize,numFrames);
    without_pre = [zeros(1,numFrames);parallel;zeros(1,numFrames);flipud(conj(parallel))];
    without_pre_time = ifft(without_pre);
    ofdm = [without_pre_time(frameLength-L+1:frameLength,:);without_pre_time];
    ofdm = ofdm(:).';
end