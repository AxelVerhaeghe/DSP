function [a,b,Htot] = fixed_transmitter_side_beamformer(H1,H2,frameSize)
%FIXED_TRANSMITTER_SIDE_BEAMFORMER calculates coefficients to weigh the
%power sent to each speaker
%
%INPUT:
% - H1:         Frequency response of speaker 1
% - H2:         Frequency response of speaker 2
% - frameSize:  The amount of frequencies used
%
%OUTPUT:
% - a:          Weighing coefficients of speaker 1
% - b:          Weighing coefficients of speaker 2 
% Htot:         Total frequency response of both channels combined

    a = zeros(1,frameSize);
    b = zeros(1,frameSize);
    Htot = zeros(1,frameSize);
    H1 = H1(2:frameSize+1);
    H2 = H2(2:frameSize+1);
    for k = 1:frameSize
       Htot(k) = sqrt((H1(k)*conj(H1(k))) + (H2(k)*conj(H2(k))));
       a(k) = conj(H1(k))/Htot(k);
       b(k) = conj(H2(k))/Htot(k);
    end
    Htot = [0,Htot,0,flipud(conj(Htot))];
end