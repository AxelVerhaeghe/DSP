function errorRate = ber(transmitted,received)
    signalSize = length(transmitted);
    receivedSignal = received(1:signalSize);
    [number,errorRate] = biterr(transmitted,receivedSignal);
end