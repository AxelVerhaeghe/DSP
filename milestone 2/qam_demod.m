function y = qam_demod(signal,n)
    M = 2^n;
    nbRows = length(signal);
    demodSig = qamdemod(signal,M,'UnitAveragePower',true);
    binDemodSig = de2bi(demodSig);
    y = reshape(binDemodSig,1,nbRows*n);
    
end