function [simin,nbsecs,fs] = initparams(toplay,fs)
maxSig = max(abs(toplay));
scalingFactor = 1/maxSig;
sig = scalingFactor*toplay;
simin = [zeros(1,2*fs), sig, zeros(1,fs);zeros(1,2*fs), sig, zeros(1,fs)];
simin = transpose(simin);
nbsecs = size(simin,1)/fs;