pulseFreq = 300;
pulseT = 0:1/fs:0.25;
pulse = 4*sin(2*pi*pulseFreq*pulseT);
signal = wgn(1,800,0);
signal1 = [zeros(1,500),pulse,zeros(1,500),signal,zeros(1,200)];
signal2 = [zeros(1,20),pulse,zeros(1,500),signal,zeros(1,680)];

alignedSignal1 = alignIO(signal1,pulse);
alignedSignal2 = alignIO(signal2,pulse);

figure();
plot1 = subplot(4,1,1);plot(signal1);title('signal1');
plot2 = subplot(4,1,2);plot(signal2);title('signal2');
plot3 = subplot(4,1,3);plot(alignedSignal1);title('aligned signal 1');
plot4 = subplot(4,1,4);plot(alignedSignal2);title('aligned signal 2');
linkaxes([plot1,plot2,plot3,plot4],'xy');