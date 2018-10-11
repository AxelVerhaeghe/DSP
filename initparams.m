function [simin,nbsecs,fs] = initparams(toplay,fs)
simin = [zeros(1,2*fs), toplay, zeros(1,fs);zeros(1,2*fs), toplay, zeros(1,fs)];
simin = transpose(simin);
nbsecs = size(simin,1)/fs;