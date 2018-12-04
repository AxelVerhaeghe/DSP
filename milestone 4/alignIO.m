function [outAligned]=alignIO(out,pulse)

[amplitudeCorrelation,lag] = xcorr(pulse,out);

[~,index] = max(abs(amplitudeCorrelation));
lagDiff = lag(index);

outSync = out(-lagDiff+1:end);

pulseLength = length(pulse);

outAligned = outSync(pulseLength - 20:end);
end

