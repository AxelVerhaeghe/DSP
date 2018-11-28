function errorRate = ber(transmitted,received)
    transmitted = reshape(transmitted,[],1);
    received = reshape(received,[],1);
    signalSize = length(transmitted);
    receivedSignal = received(1:signalSize);
    [~,errorRate] = biterr(transmitted,receivedSignal);
end