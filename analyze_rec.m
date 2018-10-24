fs = 16000;
t = 0:1/fs:2;
dc = 0.25;
sig = sin(2*pi*1500*t) + dc;
% sig = sin(2*pi*100*t) + sin(2*pi*200*t) + sin(2*pi*500*t) + sin(2*pi*1000*t) + sin(2*pi*1500*t) + sin(2*pi*2000*t) + sin(2*pi*4000*t) + sin(2*pi*6000*t);
% sig = wgn(1,2*fs,1);
[simin,nbsecs,fs] = initparams(sig,fs);
dftsize = 1024;
sim('recplay');
out = simout.signals.values;

% Spectogram
figure();
subplot(2,1,1)
% Sent signal
[specSig,psdSig] = spectrogram(sig,dftsize,dftsize/2,dftsize,fs);
spectrogram(sig,dftsize,dftsize/2,dftsize,fs);
% Received signal
subplot(2,1,2)
[specOut,psdOut] = spectrogram(out,dftsize,dftsize/2,dftsize,fs);
spectrogram(out,dftsize,dftsize/2,dftsize,fs);

% PSD
figure();
% Sent signal
subplot(2,1,1)
pwelch(sig,dftsize,dftsize/2,dftsize,fs);
%Received signal
subplot(2,1,2)
pwelch(out,dftsize,dftsize/2,dftsize,fs);
