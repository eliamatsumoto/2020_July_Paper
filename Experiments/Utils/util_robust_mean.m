%% rmean = util_robust_mean(Loss)
%
%  min min & max max = NaN
%
function rmean = util_robust_mean(Loss)

%% Initialization
nc    = size(Loss,2);
RLoss = Loss;

%% Sweeping values
for i = 1:nc
    [~,idmin] = min(Loss(:,i));
    [~,idmax] = max(Loss(:,i));
    RLoss([idmin idmax],i) = NaN;
end

%% "Robust" mean
rmean = nanmean(RLoss);

