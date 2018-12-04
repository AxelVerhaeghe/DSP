function y = qam_demod(signal,n)
    M = 2^n;
    demodSig = qamdemod(signal,M,'UnitAveragePower',true);
    binDemodSig = de2bi(demodSig,n).';
    y = reshape(binDemodSig,[],1);
    
end