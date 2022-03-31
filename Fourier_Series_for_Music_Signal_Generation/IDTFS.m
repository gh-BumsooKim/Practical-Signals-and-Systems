function x = IDTFS(X,N,kk,NR)

% IDTFS x[n] of N-point DTFS X for n=0:NR-1
nn = 0:NR-1;
x = 0;
for k = kk
   x = x + X(k+1)*exp(j*k*(2*pi/N)*nn); % IDTFS synthesis/Reconstruction
end
power = sum(abs(X(kk+1)).^2); % Parseval's relation (5.88)
x = x/sqrt(power); % Power normalization    
