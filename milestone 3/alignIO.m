function [outAligned]=alignIO(out,pulse)

[acor,lag] = xcorr(pulse,out);

[~,index] = max(abs(acor));
lagDiff = lag(index);

outSync = out(-lagDiff+1:end);

pulseLength = length(pulse);

outAligned = outSync(pulseLength-20:end);
end

