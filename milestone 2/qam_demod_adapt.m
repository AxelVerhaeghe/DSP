function dataOut = qam_demod_adapt(dataIn,b,paddingSize)
%QAM_DEMOD_ADAPT demodulates the QAM signal using the order as defined in b
%
%INPUT:
% - dataIn:         QAM modulated vector
% - b:              Vector with coefficients for the QAm (de)modulation
% - paddingSize:    The amount of zeros added by the QAM modulation
%
%OUTPUT:
% - dataOut:        Bitstream, the demodulated QAM vector

frameLength = length(b);
nbFrames = length(dataIn)/frameLength;
dataOut = [];
for i = 1:nbFrames
    frame = dataIn(1:frameLength);
    dataIn(1:frameLength) = [];
    for j = 1:length(b)
        symbols = qamdemod(frame(j),b(j),'UnitAveragePower',true);
        dataOut = [dataOut,symbols];
    end
end
dataOut = dataOut(1:length(dataOut)-paddingSize);

end