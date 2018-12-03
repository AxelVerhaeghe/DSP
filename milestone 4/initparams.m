function [simin,nbsecs,fs] = initparams(toplay,fs,pulse)
%INITPARAMS 
%
%INPUT:
% - toplay: The signal that should be played
% - fs:     The sampling frequency
% - pulse:  The pulse used for synchronisation
%
%OUTPUT:
% - simin:  The signal that is played. It consists of 2s silence, the pulse
%           followed by 300 zeros, than the signal and finally 1s of
%           silence. This is copied in both columns for both the channels.
% - nbsecs: The length of the signal that is played (simin)
% - fs:     The sampling frequency

maxSig = max(abs(toplay));
scalingFactor = 1/maxSig;
sig = scalingFactor*toplay;

simin = [zeros(1,2*fs), pulse, zeros(1,500) sig, zeros(1,fs);zeros(1,2*fs), pulse, zeros(1,500), sig, zeros(1,fs)];
simin = transpose(simin);
nbsecs = size(simin,1)/fs;