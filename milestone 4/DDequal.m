function [X,W] = DDequal(Y,Win,n,mu,alpha)

steps = length(Y);
X = zeros(1,steps);
x = zeros(1,steps);
W = zeros(1,steps);
W(1) = Win;
% X(1) = conj(W(1))*Y(1);

for L = 2:steps
    X(L) = conj(W(L-1))*Y(L);
    xTemp = qam_demod(X(L),n);
    x(L) = qam_mod(xTemp,n);
    W(L) = W(L-1) + mu/(alpha+conj(Y(L))*Y(L)) * Y(L) * conj(x(L) - conj(W(L-1))*Y(L));
%     X(L) = conj(W(L))*Y(L);
end
