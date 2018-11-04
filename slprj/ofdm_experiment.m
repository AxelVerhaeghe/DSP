clear();
len = 1800;
dftSize = 64;
input = randi([0,1],1,len);
qam4 = qam_mod(input,4); %Modulating the signal without noise (4-QAM)
ofdm = ofdm_mod(qam4,dftSize,40);