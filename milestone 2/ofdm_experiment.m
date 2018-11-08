clear();
len = 1800;
qamBlockSize = 50;
input = randi([0,1],1,len);
n=5;
prefixLength = 10;
snr= 20;
qam = qam_mod(input,n); %Modulating the signal without noise
[ofdm,paddingSize] = ofdm_mod(qam,qamBlockSize,prefixLength); %Applying OFDM on the input signal
ofdmWithNoise = awgn(ofdm,snr,'measured'); %Adding noise to OFDM

output = ofdm_demod(ofdmWithNoise,qamBlockSize,prefixLength,paddingSize); %Demodulating the OFDM signal to the QAM signal
outputBit = qam_demod(output,n); %Demodulating the output QAM signal
ber = ber(input,outputBit); %Checking the BER
fprintf(1,"BER = %f%%\n",100*ber);

R = (n*qamBlockSize)/(2*qamBlockSize + 2); %Calculating the data rate in function of sampling frequency
fprintf(1,"Data Rate R = %f * fs\n",R);
