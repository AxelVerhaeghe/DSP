function y = ofdm_demod(signal,dftSize,L)
frameSize = 2*dftSize + 2 + L;
numFrames = length(signal)/frameSize;
with_prefix_time = reshape(signal,frameSize,numFrames);

without_prefix_time = with_prefix_time(L+1:frameSize,:);
without_prefix = fft(without_prefix_time);
qamParallel = without_prefix(2:dftSize,:);
y = reshape(qamParallel,1,[]);
end