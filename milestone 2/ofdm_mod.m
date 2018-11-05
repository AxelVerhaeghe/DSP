function ofdm = ofdm_mod(qamSignal,dftSize,L)
%OFDM_MOD applies a OFDM to the given QAM input signal.
%Input arguments:
% - qamSignal    The input signal modulated with QAM
% - dftSize      The size of the DFT
% - L            The length of the cyclic prefix

    qamSignal = transpose(qamSignal);
    signalLength   = length(qamSignal);
    frameLength  = 2*dftSize+2;
    numFrames = ceil(signalLength/dftSize);
    
    parallel = reshape(qamSignal,dftSize,numFrames);
    without_pre = [zeros(1,numFrames);parallel;zeros(1,numFrames);flipud(conj(parallel))];
    without_pre_time = ifft(without_pre); %apply ifft
    ofdm = [without_pre_time(frameLength-L+1:frameLength,:);without_pre_time]; %add cyclic prefix of length L
    ofdm = ofdm(:).'; %reshapes the array into a column vector and then applies transpose
end