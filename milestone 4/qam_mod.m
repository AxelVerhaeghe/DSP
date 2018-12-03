function dataOut = qam_mod(dataIn,n)
%QAM_MOD computes the M-ary QAM modulation on the input data
%
%INPUT:
% - dataIn:     A bitstream that has to be modulated
% - n:          The function will apply a M-ary QAM, where M = 2^n
%
%OUTPUT:
% - dataOut:    The QAM-modulated signal
    dataIn = reshape(dataIn,[],1);
    M = 2^n;
    dataLength = length(dataIn);
    % Padding input with zeros
    remainder = mod(dataLength,n);
    if remainder == 0
        remainder = n;
    end
    paddingSize = n - remainder;
    padding = zeros(paddingSize,1);
    paddedDataIn = [dataIn;padding];
    
    dataInMatrix = reshape(paddedDataIn,n,[]).'; %Grouping the input in tuples of size n
    dataSymbolsIn = bi2de(dataInMatrix); %Converting the tuples to decimals
    
    % Applying the normalized modulation
    dataOut = qammod(dataSymbolsIn,M,'UnitAveragePower',true);
end