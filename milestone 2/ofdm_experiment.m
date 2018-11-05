clear();
len = 18000;
dftSize = 50;
input = randi([0,1],1,len);
qam6 = qam_mod(input,6); %Modulating the signal without noise (64-QAM)
ofdm = ofdm_mod(qam6,dftSize,10); %Applying OFDM on the input signal
output = ofdm_demod(ofdm,dftSize,10); %Demodulating the OFDM signal to the QAM signal
ber = ber(qam6,output); %Checking if the output is the same as  the input
% Since there is no added noise, these should be equal and thus the BER
% should be 0%
fprintf(1,"BER = %f%%\n",100*ber);
