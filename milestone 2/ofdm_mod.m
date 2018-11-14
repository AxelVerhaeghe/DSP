function [ofdm,paddingSize] = ofdm_mod(qamSignal,frameSize,prefixLength)
%OFDM_MOD applies a OFDM to the given QAM input signal.
%Input arguments:
% - qamSignal    The input signal modulated with QAM
% - dftSize      The size of the DFT
% - L            The length of the cyclic prefix

    qamSignal = transpose(qamSignal);
    signalLength   = length(qamSignal);
    frameLength  = 2*frameSize+2;
    paddingSize = 0;
    
    % padding input with zeros
    remainder = mod(signalLength,frameSize);
    while(remainder ~= 0)
       qamSignal = cat(2,qamSignal,0);
       signalLength = signalLength + 1;
       remainder = mod(signalLength,frameSize);
       paddingSize = paddingSize + 1;
    end
    numFrames = signalLength/frameSize;
%     paddedQamSignal = zeros(1,numFrames*dftSize);
%     paddedQamSignal(1:length(qamSignal)) = qamSignal;
    
    parallel = reshape(qamSignal,frameSize,numFrames);
    without_pre = [zeros(1,numFrames);parallel;zeros(1,numFrames);flipud(conj(parallel))];
    without_pre_time = ifft(without_pre); %apply ifft
    ofdm = [without_pre_time(frameLength-prefixLength+1:frameLength,:);without_pre_time]; %add cyclic prefix of length L
    ofdm = ofdm(:).'; %reshapes the array into a column vector and then applies transpose
end