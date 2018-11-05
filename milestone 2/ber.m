function y = ber(transmitted,received)
    tol = 1e-10;
    signalSize = size(transmitted);
    signalLength = signalSize(2);
    errors = 0;
    for i=1:1:signalLength
        if (transmitted(i) - received(i) > tol)
            errors = errors + 1;
        end
    end
    y = errors/signalLength;
end