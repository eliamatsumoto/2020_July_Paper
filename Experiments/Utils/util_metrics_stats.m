%% Stats: mean, std, vol, min, max
%
function Stats = util_metrics_stats(values)
S_mean = mean(values);
S_std  = std(values);
S_vol  = abs(S_std/S_mean);
S_min  = min(values);
S_max  = max(values);
Stats = [S_mean S_std S_vol S_min S_max];