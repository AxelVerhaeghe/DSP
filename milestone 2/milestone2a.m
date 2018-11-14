qam_experiment;
figure();

plot4qam = subplot(5,1,1);
plot(snrVector,ber2)
title('4-QAM');
xlabel('SNR');
ylabel('BER');

plot8qam = subplot(5,1,2);
plot(snrVector,ber3)
title('8-QAM');
xlabel('SNR');
ylabel('BER');

plot16qam = subplot(5,1,3);
plot(snrVector,ber4)
title('16-QAM');
xlabel('SNR');
ylabel('BER');

plot32qam = subplot(5,1,4);
plot(snrVector,ber5)
title('32-QAM');
xlabel('SNR');
ylabel('BER');

plot64qam = subplot(5,1,5);
plot(snrVector,ber6)
title('64-QAM');
xlabel('SNR');
ylabel('BER');

linkaxes([plot4qam, plot8qam, plot16qam, plot32qam, plot64qam],'xy');