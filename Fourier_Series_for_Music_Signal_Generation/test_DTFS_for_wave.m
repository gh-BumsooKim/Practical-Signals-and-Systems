% test_DTFS_for_wave.m 
clear, clf

%% File Read
% Audio File
fname = 'C4_hammonica.wav'; % 'C4_hammonica.wav', 'C3_piano.wav', 'A4_guitar.wav'
fname_t = split(fname, '.');
fname_t = fname_t(1);

% Extract Sampling Frequency
[x, Fs] = audioread(fname);

%% Extract Frequency

% Fundamental Frequency
[f, key_no] = f_from_key(fname(1:2));

x = x(:,end); % Select the last one when two different signals are in wave file

% Sampling Period, and Number of Samples
Ts = 1/Fs;
Ns = length(x);
P = 1/f;  % Period

w0 = 2*pi/P;    % CT Fundamental frequency
W0d = w0*Ts;    % DT fundamental frequency 

N = round(2*pi/W0d);     % DTFS size
t = [0:Ns-1]*Ts;         % Vector for time index 

%% Sound Generation

sound(x,Fs)
NN=[2,4,10,round(N/2)]; % Highest order of harmonics to be reconstructed

%% Signal Plot and Fourier Series
lenN = length(NN); K = lenN+2; % Number of subplots

f = figure (1);
f.Position =  [-1000 -500 1000 1600];

% subplot 1 / Input Signal
subplot(K,1,1);
plot(t,x), grid on;
title(['Input Signal : ' char(fname_t)], 'interpreter', 'None');

xlabel("Time Domain"), ylabel("Magnitude");

% subplot 2 / Frequency Decomposition of Input Signal
x1 = x(round(0.5/Ts)+[1:N]); % One period of x starting from t=0.5 sec
[X,kk] = DTFS(x1,N); % DTFS analysis of x[n] with fundamental freq 2*pi/N  
Xf = X; % Full DTFS coefficients

subplot(K,2,3);
stem(kk,abs(X(kk+1))), grid on; % Plot full DTFS coefficients
title("DTFS Coefficients of Input Signal")
xlabel("Frequency Domain"), ylabel("Magnitude");

% subplot 3 / Reconstruction of Frequency
R = 200; NR = N*R; % Number of samples to be generated (sound)
N5 = N*5; t5 = [0:N5-1]*Ts; % 5 repetitions (plot)
subplot(K,2,4);
plot(t5,repmat(x1(:),5,1)), grid on
title("Entire Frequency of Origin Input Signal")
xlabel("Time Domain"), ylabel("Magnitude");

pause

% subplot 4 / DTFS and IDTFS
for i = 1:lenN
   Ni = NN(i); kk = [0:Ni-1 N-Ni+1:N-1]; 
   subplot(K,2,2*i+3), stem(kk,abs(X(kk+1))), grid on % Plot the magnitude of DTFS spectrum 
   title(['The highest order of harmonic in xh(t) : ' num2str(Ni-1)])
   xlabel("Frequency Domain"), ylabel("Magnitude");
   
   xh = real(IDTFS(X,N,kk,NR)); % IDTFS synthesis (Reconstruction) 
   subplot(K,2,2*i+4), plot(t5,xh(1:N5)), shg, grid on % Show most recent graph window  
   title(['IDTFS Synthesis (Reconstruction) using up to xh(t) : ' num2str(Ni-1)])
   xlabel("Time Domain"), ylabel("Magnitude");
   
   sound(xh*50,Fs)
   %pause
end

%% (Test) Custom Sound File Generation

% Generation of music signal using Xf
notes = {'E3','D3','C3','D3','E3','E3','E3',...
    'D3','D3','D3','E3','E3','E3',...
    'E3','D3','C3','D3','E3','E3','E3',...
    'D3','D3','E3','D3','C3',};

N2 = ceil(N/2); kk = [0:N2-1 -(N2-1):-1]; % kk1 = mod(kk+N,N)+1
n1 = 0:round(0.5/Ts); % Time index for 0.5 second 
xhn = []; 
for n=1:length(notes)
   [f, key_no] = f_from_key(notes{n});
   w0 = 2*pi*f; % CT fundamental frequency
   W0d = w0*Ts; % DT fundamental frequency 
   xh = 0;
   for k=kk
      k1 = mod(k+N,N)+1;
      xh = xh + Xf(k1)*exp(j*k*W0d*n1); % IDTFS synthesis/reconstruction
   end
   % norm(imag(xh)) % Normalization if necessary
   xhn = [xhn real(xh)];
end
fname1 = ['audio_output_' char(fname_t) '.wav'];
audiowrite(fname1,xhn,Fs)    % Save the generated signal
[x_,Fs] = audioread(fname1); % Read the signal
sound(x_*10,Fs) 
        