function [X,kk]=DTFS(x,N)

% Computes the DTFS of a given sequence x[n] 
% for DT frequencies Ws = 2*pi/N*[0:N-1]
% j = sqrt(-1);
x = x(:); % To make x a row vector
kk = 0:N-1; % Frequency indices
X = 0;
for n = 0:N-1
   X = X + x(n+1)*exp(-j*2*pi/N*kk*n)/N;
end

