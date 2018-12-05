clear();

n = 3;
len = 1000*n;

input = randi([0,1],1,len);
X = qam_mod(input,n);
H = 3 + 2i;
Y = fftfilt(H,X);

delta = 0.1*H;
mu = [0.2, 0.4, 0.9, 1.5]; %stepSize: greater stepsize increases speed of convergence (too big causes oscilations)
alpha = 0.5;
convergenceTime = 100;
W = zeros(length(mu),convergenceTime);
difference = zeros(size(W));
W(:,1) = 1/conj(H) + delta;
for i = 1:length(mu)
    for L = 2:convergenceTime
       W(i,L) = W(i,L-1) + mu(i)/(alpha + conj(Y(L))*Y(L)) * Y(L) * conj(X(L) - conj(W(i,L-1))*Y(L));
    end
    difference(i,:) = abs(W(i,:)) - abs(1/conj(H));
end
figure();
hold on;
for j = 1:length(mu)
    plot(difference(j,:)); title('Convergence of adaptive filter');
end
legend('mu = 0.2', 'mu = 0.4', 'mu = 0.9', 'mu = 1.5');