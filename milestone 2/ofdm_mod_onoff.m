function [ofdm,paddingSize,usableFrequencies] = ofdm_mod_onoff(qamSignal,qamBlockSize,prefixLength,channelFrequencyResponse)
%OFDM_MOD_ONOFF applies a OFDM to the given QAM input signal by
%only using the frequencies that are the least surpressed in the channel.
%Input arguments:
% - qamSignal                   The input signal modulated with QAM
% - qamBlockSize                The size of the blocks
% - prefixLength                The length of the cyclic prefix
% - channelFrequencyResponse    The frequency response of the channel
%Output:
% - ofdm                The ofdm modulated signal
% - paddingSize         If the signal is not divisible by qamBlocksize, the
% signal will be padded with zeros. This parameter gives the amount of
% zeros added.
% - usableFrequencies   The frequencies used where the channel doesn't
% surpress the signal as much.

    %Calculate the maximum frequencies of freq_respons
    maxFrequency = abs(max(channelFrequencyResponse));
    absFrequency = abs(channelFrequencyResponse(1:length(channelFrequencyResponse)));
    
    nbUsableFrequencies = qamBlockSize + 1; %initialising nbUsableFrequencies to be greater than qamBlockSize
    tol = 0.5;
    while ((nbUsableFrequencies > qamBlockSize) && (tol <= 1))
        usableFrequencies = find(absFrequency>tol*maxFrequency);  
        nbUsableFrequencies = length(usableFrequencies);
        tol = tol + 0.1;
    end
    
    qamSignal = transpose(qamSignal);
    signalLength = length(qamSignal);
    frameLength = 2*qamBlockSize+2;   
    
    % padding input with zeros
    remainder = mod(signalLength,nbUsableFrequencies);
    paddingSize = nbUsableFrequencies - remainder;
    padding = zeros(1,paddingSize);
    paddedQamSignal = [qamSignal,padding];
    paddedSignalLength = length(paddedQamSignal);
    numFrames = paddedSignalLength/nbUsableFrequencies;
    
    parallel = reshape(paddedQamSignal,nbUsableFrequencies,numFrames);
    frames = zeros(qamBlockSize,numFrames);
    for i=1:nbUsableFrequencies
       frames(usableFrequencies(i),:) =  parallel(i,:);
    end
    
    withoutPrefix = [zeros(1,numFrames);frames;zeros(1,numFrames);flipud(conj(frames))];
    withoutPrefixTime = ifft(withoutPrefix); %apply ifft
    ofdm = [withoutPrefixTime(frameLength-prefixLength+1:frameLength,:);withoutPrefixTime]; %add cyclic prefix of length L
    ofdm = ofdm(:).'; %reshapes the array into a column vector and then applies transpose
end