clear();
len = 1800;
input = randi([0,1],1,len);
snrVector = linspace(1,25,10);
plotScatterplots = false;

%% 4-QAM
qam2 = qam_mod(input,2); %Modulating the signal without noise (4-QAM)
qam2Noise = zeros(length(snrVector),length(qam2));
for i=1:length(snrVector)
   qam2Noise(i,:) = awgn(qam2,snrVector(i),'measured'); %Adding noise to the qam signal for each SNR
end
if plotScatterplots %Allows to run the script without plotting all the scatterplots
    scatterplot(qam2,1,0,'k+'); %Scatterplot of the signal without noise
    for i=1:length(snrVector)
        scatterplot(qam2Noise(i,:),1,0,'k+'); %Scatterploit of the signal with noise with each SNR
    end
end
output2 = zeros(length(snrVector),length(input));
for i=1:length(snrVector)
    output2(i,:) = qam_demod(qam2Noise(i,:),2);%Demodulating the noisy transmitted signal
end
ber2 = zeros(1,length(snrVector));
for i=1:length(snrVector)
   ber2(i) = ber(input,output2(i,:)); %Calculating the BER for each SNR
end

%% 8-QAM
qam3 = qam_mod(input,3); %Modulating the signal without noise (8-QAM)
qam3Noise = zeros(length(snrVector),length(qam3));
for i=1:length(snrVector)
   qam3Noise(i,:) = awgn(qam3,snrVector(i),'measured'); %Adding noise to the qam signal for each SNR
end
if plotScatterplots %Allows to run the script without plotting all the scatterplots
    scatterplot(qam3,1,0,'b+'); %Scatterplot of the signal without noise
    for i=1:length(snrVector)
        scatterplot(qam3Noise(i,:),1,0,'b+'); %Scatterploit of the signal with noise with each SNR
    end
end
output3 = zeros(length(snrVector),length(input));
for i=1:length(snrVector)
    output3(i,:) = qam_demod(qam3Noise(i,:),3);%Demodulating the noisy transmitted signal
end
ber3 = zeros(1,length(snrVector));
for i=1:length(snrVector)
   ber3(i) = ber(input,output3(i,:)); %Calculating the BER for each SNR
end

%% 16-QAM
qam4 = qam_mod(input,4); %Modulating the signal without noise (16-QAM)
qam4Noise = zeros(length(snrVector),length(qam4));
for i=1:length(snrVector)
   qam4Noise(i,:) = awgn(qam4,snrVector(i),'measured'); %Adding noise to the qam signal for each SNR
end
if plotScatterplots %Allows to run the script without plotting all the scatterplots
    scatterplot(qam4,1,0,'g+'); %Scatterplot of the signal without noise
    for i=1:length(snrVector)
        scatterplot(qam4Noise(i,:),1,0,'g+'); %Scatterploit of the signal with noise with each SNR
    end
end
output4 = zeros(length(snrVector),length(input));
for i=1:length(snrVector)
    output4(i,:) = qam_demod(qam4Noise(i,:),4);%Demodulating the noisy transmitted signal
end
ber4 = zeros(1,length(snrVector));
for i=1:length(snrVector)
   ber4(i) = ber(input,output4(i,:)); %Calculating the BER for each SNR
end

%% 32-QAM
qam5 = qam_mod(input,5); %Modulating the signal without noise (32-QAM)
qam5Noise = zeros(length(snrVector),length(qam5));
for i=1:length(snrVector)
   qam5Noise(i,:) = awgn(qam5,snrVector(i),'measured'); %Adding noise to the qam signal for each SNR
end
if plotScatterplots %Allows to run the script without plotting all the scatterplots
    scatterplot(qam5,1,0,'m+'); %Scatterplot of the signal without noise
    for i=1:length(snrVector)
        scatterplot(qam5Noise(i,:),1,0,'m+'); %Scatterploit of the signal with noise with each SNR
    end
end
output5 = zeros(length(snrVector),length(input));
for i=1:length(snrVector)
    output5(i,:) = qam_demod(qam5Noise(i,:),5);%Demodulating the noisy transmitted signal
end
ber5 = zeros(1,length(snrVector));
for i=1:length(snrVector)
   ber5(i) = ber(input,output5(i,:)); %Calculating the BER for each SNR
end

%% 64-QAM
qam6 = qam_mod(input,6); %Modulating the signal without noise (64-QAM)
qam6Noise = zeros(length(snrVector),length(qam6));
for i=1:length(snrVector)
   qam6Noise(i,:) = awgn(qam6,snrVector(i),'measured'); %Adding noise to the qam signal for each SNR
end
if plotScatterplots %Allows to run the script without plotting all the scatterplots
    scatterplot(qam6,1,0,'r+'); %Scatterplot of the signal without noise
    for i=1:length(snrVector)
        scatterplot(qam6Noise(i,:),1,0,'r+'); %Scatterploit of the signal with noise with each SNR
    end
end
output6 = zeros(length(snrVector),length(input));
for i=1:length(snrVector)
    output6(i,:) = qam_demod(qam6Noise(i,:),6);%Demodulating the noisy transmitted signal
end
ber6 = zeros(1,length(snrVector));
for i=1:length(snrVector)
   ber6(i) = ber(input,output6(i,:)); %Calculating the BER for each SNR
end
