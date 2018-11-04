function y = qam_demod(signal,n)
    M = 2^n;
    signalSize = size(signal);
    nbRows = signalSize(1);
    demodSig = qamdemod(signal,M);
    binDemodSig = de2bi(demodSig);
    y = reshape(binDemodSig,1,nbRows*n);
    
end