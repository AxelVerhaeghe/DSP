clear();

n = 3;
len = 1000*n;

input = randi([0,1],1,len);
Xk = qam_mod(input,n);
Hk = 3 + 2i;
Yk = fftfilt(Hk,Xk);

delta = 0.001*Hk;
mu = 0.4; %stepSize: greater stepsize increases speed of convergence (too big causes oscilations)
alpha = 0.5;
convergenceTime = 100;
Wk = zeros(1,convergenceTime);
Wk(1) = 1/conj(Hk) + delta;

for L = 1:convergenceTime
   Wk(L+1) = Wk(L) + mu/(alpha + conj(Yk(L+1))*Yk(L+1)) * Yk(L+1) * conj(Xk(L+1) - conj(Wk(L))*Yk(L+1));
end

figure();
plot(abs(Wk)-abs(1/conj(Hk))); title('Convergence of adaptive filter');