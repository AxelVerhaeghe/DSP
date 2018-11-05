function y = qam_mod(dataIn,n)
    M = 2^n;
    dataInMatrix = reshape(dataIn,[],n); %Grouping the input in tuples of size n
    dataSymbolsIn = bi2de(dataInMatrix); %Converting the tuples to decimals
    
    % Applying the modulation without normalizing to calculate the
    % normalisation factor. (comment this part out when this is not
    % required to get better performance)
%     yNotNormalized = qammod(dataSymbolsIn,M);
%     avgPower = mean(abs(yNotNormalized).^2);
%     fprintf(1,"Normalisation factor = %d\n",1/avgPower);
    
    % Applying the normalized modulation
    y = qammod(dataSymbolsIn,M,'UnitAveragePower',true);
end