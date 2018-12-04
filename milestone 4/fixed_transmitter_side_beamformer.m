function [a,b,Htot] = fixed_transmitter_side_beamformer(H1,H2)
%FIXED_TRANSMITTER_SIDE_BEAMFORMER calculates coefficients to weigh the
%power sent to each speaker
%
%INPUT:
% - H1: Frequency response of speaker 1
% - H2: Frequency response of speaker 2
%
%OUTPUT:
% - a:  Weighing coefficients of speaker 1
% - b:  Weighing coefficients of speaker 2 
% Htot: Total frequency response of both channels combined

    channelLength = length(H1);
    a = zeros(1,channelLength);
    b = zeros(1,channelLength);
    Htot = zeros(1,channelLength);
    for k = 1:channelLength
       Htot(k) = sqrt((H1(k)*conj(H1(k))) + (H2(k)*conj(H2(k))));
       a(k) = conj(H1(k))/Htot(k);
       b(k) = conj(H2(k))/Htot(k);
    end

end