N = 512;
n = 3;
len = (N/2-1)*n;

input = transpose(randi([0,1],1,len));
trainblock = qam_mod(input,n);
qamSignal = repmat(trainblock,100,1); %repeating trainblock 100 times
Tx = ofdm_mod(qamSignal,N/2-1,0);

channel = load('IR2.mat');
h = channel.h;
Rx = conv(Tx,h);