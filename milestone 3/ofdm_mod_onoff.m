function [ofdm,paddingSize] = ofdm_mod_onoff(qamSignal,frameSize,prefixLength,usableFreqs,trainblock,Lt,Ld)
%OFDM_MOD_ONOFF applies a OFDM to the given QAM input signal by
%only using the frequencies that are the least surpressed in the channel.
%
%INPUT:
% - qamSignal:                  The input signal modulated with QAM
% - frameSize:                  The size of the blocks of data
% - prefixLength:               The length of the cyclic prefix
% - usableFreqs:                List of all the frequencies where SNR is
%                               high enough
% - trainblock:                 Known bitstream used for channel estimation
% - Lt:                         Amount of training packets per block
% - Ld:                         Amount of datapackets per block
%
%OUTPUT:
% - ofdm:                       The ofdm modulated signal
% - paddingSize:                If the signal is not divisible by qamBlocksize, the
%                               signal will be padded with zeros. This parameter
%                               gives the amount of zeros added.

    qamSignal = reshape(qamSignal,1,[]);
    nbUsableFreqs = length(usableFreqs);
    signalLength   = length(qamSignal);
    dftSize  = 2*frameSize+2;  
    
    % padding input with zeros
    remainder = mod(signalLength,nbUsableFreqs*Ld);
    if remainder == 0
        remainder = nbUsableFreqs*Ld;
    end
    paddingSize = nbUsableFreqs*Ld - remainder;
    padding = zeros(1,paddingSize);
    paddedQamSignal = [qamSignal,padding];
    
    numFrames = length(paddedQamSignal)/nbUsableFreqs;
    
    parallel = reshape(paddedQamSignal,nbUsableFreqs,numFrames);
    numBlocks = numFrames/Ld;

    trainblock = reshape(trainblock,[],1);
    
    temp = zeros(frameSize,numBlocks*(Lt+Ld));
    for i = 1:numBlocks
        for j = 1:Lt
            temp(:,(i-1)*(Lt+Ld)+j) = trainblock;
        end
        for k = 1:nbUsableFreqs
            temp(usableFreqs(k),(i-1)*(Lt+Ld)+Lt+1:i*(Lt+Ld)) = parallel(k,(i-1)*Ld + 1:i*Ld);
        end
    end
        
    without_pre = [zeros(1,numFrames + Lt*numBlocks);temp;zeros(1,numFrames + Lt*numBlocks);flipud(conj(temp))];
    without_pre_time = ifft(without_pre); %apply ifft
    ofdm = [without_pre_time(dftSize-prefixLength+1:dftSize,:);without_pre_time]; %add cyclic prefix of length L
    ofdm = ofdm(:).'; %reshapes the array into a column vector and then applies transpose
end