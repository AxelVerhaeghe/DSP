function [dataOut,paddingSize] = qam_mod_adapt(dataIn,b)
%QAM_MOD_ADAPT performs adaptive bit loading QAM modulation on the input
%The order of the M-QAM is given by M = 2^n, where n is the values in b
%
%INPUT:
% - dataIn:         Bitstream that has to be modulated
% - b:              Array of integers that determines the order of the QAM
%
%OUTPUT:
% - dataOut:        The modulated data
% - paddingSize:    The amount of zeros added to the input

frameLength = sum(b);
dataLength = length(dataIn);
remainder = mod(dataLength,frameLength);
if remainder == 0
    remainder = frameLength;
end
paddingSize = frameLength - remainder;
padding = zeros(paddingSize,1);
paddedDataIn = [dataIn;padding];
nbFrames = length(paddedDataIn)/frameLength;

% dataOut = [];
% for i = 1:nbFrames
%     for j = 1:length(b)
%         values = paddedDataIn(1:b(j));
%         paddedDataIn(1:b(j)) = [];
%         qamSymbols = qammod(bi2de(values),2^b(j),'UnitAveragePower',true);
%         dataOut = [dataOut;qamSymbols];
%     end
% end

dataOut = zeros(length(b)*nbFrames,1);
index = 1;
for i = 1:nbFrames
    for j = 1:length(b)
        values = paddedDataIn(1:b(j));
        paddedDataIn(1:b(j)) = [];
        qamSymbols = qammod(bi2de(values),2^b(j),'UnitAveragePower',true);
        dataOut(index:index+b(j)-1) = qamSymbols;
        index = index + b(j);
    end
end
end