function [ofdm,paddingSize] = ofdm_mod(qamSignal,frameSize,prefixLength, trainblock, Lt, Ld)
%OFDM_MOD applies a OFDM to the given QAM input signal.
%INPUT:
% - qamSignal:      The input signal modulated with QAM
% - frameSize:      The size of the DFT
% - prefixLength:   The length of the cyclic prefix
% - trainblock:     Known bitstream used for channel estimation
% - Lt:             Amount of training packets per block
% - Ld:             Amount of datapackets per block
%OUTPUT:
% - ofdm:           OFDM modulated version of the input stream
% - paddingSize:    The amount of zeros added to the QAM signal to make it
%                   divisible into packets of length frameSize

    qamSignal = reshape(qamSignal,1,[]);
    signalLength   = length(qamSignal);
    dftSize  = 2*frameSize+2;    
    % padding input with zeros
    remainder = mod(signalLength,frameSize*Ld);
    if remainder == 0
        remainder = frameSize*Ld;
    end
    paddingSize = frameSize*Ld - remainder;
    padding = zeros(1,paddingSize);
    paddedQamSignal = [qamSignal,padding];
    numFrames = length(paddedQamSignal)/frameSize;
    
    parallel = reshape(paddedQamSignal,frameSize,numFrames);
    
    trainblock = reshape(trainblock,[],1);
    
    numDataBlocks = numFrames/Ld;
    temp = zeros(frameSize,numDataBlocks*(Lt+Ld));
    for i = 1:numDataBlocks
        for j = 1:Lt
            temp(:,(i-1)*(Lt+Ld)+j) = trainblock;
        end
        temp(:,(i-1)*(Lt+Ld)+Lt+1:i*(Lt+Ld)) = parallel(:,(i-1)*Ld + 1:i*Ld);
    end
        
    without_pre = [zeros(1,numFrames + Lt*numDataBlocks);temp;zeros(1,numFrames + Lt*numDataBlocks);flipud(conj(temp))];
    without_pre_time = ifft(without_pre); %apply ifft
    ofdm = [without_pre_time(dftSize-prefixLength+1:dftSize,:);without_pre_time]; %add cyclic prefix of length L
    ofdm = ofdm(:).'; %reshapes the array into a column vector and then applies transpose
end