%% PREAMBLE
n = 3;
dftSize = 512;
frameSize = dftSize/2-1;
prefixLength = 100;
length = dftSize + prefixLength - 1;
Lt = 5;
Ld = 25;
trainblockBitsLength = frameSize*n;
trainBlockBits = randi([0,1],1,trainblockBitsLength);
trainblock = qam_mod(trainBlockBits,n);
snr = 30;

%% GENERATING IMPULSE RESPONSE
imp = [1, zeros(1,length)];
b1 = 1;
a1 = [1, -0.9];
h1 = filter(b1,a1,imp);

b2 = 1;
a2 = [1, -0.7];
h2 = filter(b2,a2,imp);
figure(1);plot(h1);hold on;plot(h2);title('Impulse response');legend('h1','h2');

H1 = fft(h1);
H2 = fft(h2);
[a,b,Htot] = fixed_transmitter_side_beamformer(H1,H2);
figure(2);plot(20*log10(abs(H1)));hold on;plot(20*log10(abs(H2)));plot(20*log10(abs(Htot)));title('Frequency response');legend('H1[dB]','H2[dB]','Htot[dB]');

%% MODULATION
bitStream = randi([0 1],1,dftSize*n);
qamStream = qam_mod(bitStream,n);
aMono1 = ones(1,dftSize+prefixLength);
bMono1 = zeros(1,dftSize+prefixLength);
aMono2 = bMono1;
bMono2 = aMono1;
[ ofdmStream1, ofdmStream2, paddingSize ] = ofdm_mod_stereo( qamStream,frameSize,prefixLength,trainblock,Lt,Ld,a,b );
[ ofdmStream1Mono1, ofdmStream2Mono1, paddingSize ] = ofdm_mod_stereo( qamStream,frameSize,prefixLength,trainblock,Lt,Ld,aMono1,bMono1 );
[ ofdmStream1Mono2, ofdmStream2Mono2, paddingSize ] = ofdm_mod_stereo( qamStream,frameSize,prefixLength,trainblock,Lt,Ld,aMono2,bMono2 );

%% TRANSMISSION
rxSignal = filter(h1,1,ofdmStream1) + filter(h2,1,ofdmStream2);
rxSignal = awgn(rxSignal,snr);
rxSignalMono1 = filter(h1,1,ofdmStream1Mono1) + filter(h2,1,ofdmStream2Mono1);
rxSignalMono1 = awgn(rxSignalMono1,snr);
rxSignalMono2 = filter(h1,1,ofdmStream1Mono2) + filter(h2,1,ofdmStream2Mono2);
rxSignalMono2 = awgn(rxSignalMono2,snr);

%% DEMODULATION
rxQam = ofdm_demod_stereo(rxSignal,frameSize,prefixLength,paddingSize,trainblock,Lt,Ld);
rxBitstream = qam_demod(rxQam,n);
rxQamMono1 = ofdm_demod_stereo(rxSignalMono1,frameSize,prefixLength,paddingSize,trainblock,Lt,Ld);
rxBitstreamMono1 = qam_demod(rxQamMono1,n);
rxQamMono2 = ofdm_demod_stereo(rxSignalMono2,frameSize,prefixLength,paddingSize,trainblock,Lt,Ld);
rxBitstreamMono2 = qam_demod(rxQamMono2,n);

%% BIT ERROR RATE
bitErrorRate = ber(rxBitstream,bitStream);
fprintf("BER = %f%%\n",100*bitErrorRate);
bitErrorRateMono1 = ber(rxBitstreamMono1,bitStream);
fprintf("BER = %f%%\n",100*bitErrorRate);
bitErrorRateMono2 = ber(rxBitstreamMono2,bitStream);
fprintf("BER = %f%%\n",100*bitErrorRate);