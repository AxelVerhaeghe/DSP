fs = 16000;
t = [0:1/fs:2];
sig = sin(2*pi*1500*t);
[simin,nbsecs,fs] = initparams(sig,fs);
dftsize = 512;
sim('recplay');
out = simout.signals.values;
figure();
subplot(2,1,1)
[specSig,psdSig] = spectrogram(sig,dftsize,dftsize/2,dftsize,fs);
spectrogram(sig,dftsize,dftsize/2,dftsize,fs);
subplot(2,1,2)
[specOut,psdOut] = spectrogram(out,dftsize,dftsize/2,dftsize,fs);
spectrogram(out,dftsize,dftsize/2,dftsize,fs);

figure();
subplot(2,1,1)
pwelch(sig,dftsize,dftsize/2,dftsize,fs);
subplot(2,1,2)
pwelch(out,dftsize,dftsize/2,dftsize,fs);
