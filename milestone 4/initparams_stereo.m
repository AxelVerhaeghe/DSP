function [simin,nbsecs,fs] = initparams_stereo(toplay1,toplay2,fs,pulse)
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

if any(toplay1) == 1
    maxSig1 = max(abs(toplay1));
    scalingFactor1 = 1/maxSig1;
    sig1 = scalingFactor1*toplay1;
else
    sig1 = toplay1;
end
if any(toplay2) == 1
    maxSig2 = max(abs(toplay2));
    scalingFactor2 = 1/maxSig2;
    sig2 = scalingFactor2*toplay2;
else
    sig2 = toplay2;
end
simin = [zeros(1,2*fs), pulse, zeros(1,500) sig1, zeros(1,fs);zeros(1,2*fs), pulse, zeros(1,500), sig2, zeros(1,fs)];
simin = transpose(simin);
nbsecs = size(simin,1)/fs;