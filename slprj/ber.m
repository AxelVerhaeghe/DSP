function y = ber(transmitted,received)
    signalSize = size(transmitted);
    signalLength = signalSize(2);
    errors = 0;
    for i=1:1:signalLength
        if (transmitted(i) ~= received(i))
            errors = errors + 1;
        end
    end
    y = errors/signalLength;
end