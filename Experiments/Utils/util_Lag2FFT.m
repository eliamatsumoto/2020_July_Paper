%% Function Lag to FFT
%
function FFT = util_Lag2FFT(Lag)
nObs = size(Lag,1);
nLag = size(Lag,2);
n    = fix(0.5*nLag)+1;
FFT  = zeros(nObs,n);
for i = 1:nObs
    yw  = fft(Lag(i,:));
    Pyy = yw.*conj(yw);
    FFT(i,:) = Pyy(1:n);
end