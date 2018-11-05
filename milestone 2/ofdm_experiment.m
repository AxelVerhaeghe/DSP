clear();
len = 18000;
dftSize = 50;
input = randi([0,1],1,len);
qam6 = qam_mod(input,6); %Modulating the signal without noise (64-QAM)
ofdm = ofdm_mod(qam6,dftSize,0);
output = transpose(ofdm_demod(ofdm,dftSize,0));
check = ber(qam6,output);