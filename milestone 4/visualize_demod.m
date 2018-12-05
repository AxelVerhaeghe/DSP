transmit_pic;
pause;
figure();
subplot(2,2,2); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;

x = channelEst(2:length(channelEst)/2,:); 
[~,numBlocks] = size(channelEst);
lenBlocks = floor(length(rxBitStream)/numBlocks);
timeMax = max(ifft(channelEst),[],'all');
timeMin = min(ifft(channelEst),[],'all');
freqMax = max(20*log10(abs(x)),[],'all');
freqMin = min(20*log10(abs(x)),[],'all');

for i = 1:numBlocks
    tempBitStream = rxBitStream(1:i*lenBlocks);
    tempImageRx = bitstreamtoimage(tempBitStream, imageSize, bitsPerPixel);
    subplot(2,2,1); plot(ifft(channelEst(:,i))); title('Impulse response'); ylim([timeMin,timeMax]);
    
    subplot(2,2,3); plot(20*log10(abs(x(:,i)))); title('Frequency response'); ylim([freqMin,freqMax]);
    subplot(2,2,4); colormap(colorMap); image(tempImageRx); axis image; title('Received image'); drawnow;
    pause(dftSize/fs);
end
subplot(2,2,2); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
