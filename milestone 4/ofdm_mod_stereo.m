function [ofdmStream1,ofdmStream2,paddingSize] = ofdm_mod_stereo(qamSignal,frameSize,prefixLength, trainblock, Lt, Ld,a,b)
%OFDM_MOD applies a OFDM to the given QAM input signal.
%INPUT:
% - qamSignal:      The input signal modulated with QAM
% - frameSize:      The size of the DFT
% - prefixLength:   The length of the cyclic prefix
% - trainblock:     Known bitstream used for channel estimation
% - Lt:             Amount of training packets per block
% - Ld:             Amount of datapackets per block
% - a:              Scalar weighing coefficients for speaker 1
% - b:              Salar weighing coefficients for speaker 2
%OUTPUT:
% - ofdmStream1:    OFDM modulated version of the input stream, weighed for
%                   speaker 1
% - ofdmStream2:    OFDM modulated version of the input stream, weighed for
%                   speaker 2
% - paddingSize:    The amount of zeros added to the QAM signal to make it
%                   divisible into packets of length frameSize
% - 

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
        
    temp1 = zeros(size(temp));
    temp2 = zeros(size(temp));
    for k = 1:frameSize
       temp1(k,:) = a(k)*temp(k,:);
       temp2(k,:) = b(k)*temp(k,:);
    end
    withoutPrefix1 = [zeros(1,numFrames + Lt*numDataBlocks);temp1;zeros(1,numFrames + Lt*numDataBlocks);flipud(conj(temp1))];
    withoutPrefix2 = [zeros(1,numFrames + Lt*numDataBlocks);temp2;zeros(1,numFrames + Lt*numDataBlocks);flipud(conj(temp2))];

    withoutPrefixTime1 = ifft(withoutPrefix1);
    withoutPrefixTime2 = ifft(withoutPrefix2);
    ofdmStream1 = [withoutPrefixTime1(dftSize-prefixLength+1:dftSize,:);withoutPrefixTime1]; %add cyclic prefix of length L
    ofdmStream2 = [withoutPrefixTime2(dftSize-prefixLength+1:dftSize,:);withoutPrefixTime2]; %add cyclic prefix of length L
    ofdmStream1 = ofdmStream1(:).'; %reshapes the array into a column vector and then applies transpose
    ofdmStream2 = ofdmStream2(:).'; %reshapes the array into a column vector and then applies transpose
end