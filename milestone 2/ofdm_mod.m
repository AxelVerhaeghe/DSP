function [ofdm,paddingSize] = ofdm_mod(qamSignal,frameSize,prefixLength)
%OFDM_MOD applies a OFDM to the given QAM input signal.
%INPUT:
% - qamSignal:      The input signal modulated with QAM
% - frameSize:      The size of the DFT
% - prefixLength:   The length of the cyclic prefix
%OUTPUT:
% - ofdm:           OFDM modulated version of the input stream
% - paddingSize:    The amount of zeros added to the QAM signal to make it
%                   divisible into packets of length frameSize

    qamSignal = transpose(qamSignal);
    signalLength   = length(qamSignal);
    frameLength  = 2*frameSize+2;    
    % padding input with zeros
    remainder = mod(signalLength,frameSize);
    if remainder == 0
        remainder = frameSize;
    end
    paddingSize = frameSize - remainder;
    padding = zeros(1,paddingSize);
    paddedQamSignal = [qamSignal,padding];
    numFrames = length(paddedQamSignal)/frameSize;
    
    parallel = reshape(paddedQamSignal,frameSize,numFrames);
    without_pre = [zeros(1,numFrames);parallel;zeros(1,numFrames);flipud(conj(parallel))];
    without_pre_time = ifft(without_pre); %apply ifft
    ofdm = [without_pre_time(frameLength-prefixLength+1:frameLength,:);without_pre_time]; %add cyclic prefix of length L
    ofdm = ofdm(:).'; %reshapes the array into a column vector and then applies transpose
end