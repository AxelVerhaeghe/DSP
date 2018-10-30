function y = qam_mod(dataIn,n)
    M = 2^n;
    dataInMatrix = reshape(dataIn,[],n);
    dataSymbolsIn = bi2de(dataInMatrix);
    y = qammod(dataSymbolsIn,M);
end