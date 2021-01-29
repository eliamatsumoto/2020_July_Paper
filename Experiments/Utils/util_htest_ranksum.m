%% H_FLAG = util_ranksum(Sample1,Sample2,ALPHA)
%
%  H_FLAG =  1 (mean(Sample2) > mean(Sample1)
%  H_FLAG =  0 (mean(Sample2) ~ mean(Sample1)
%  H_FLAG = -1 (mean(Sample2) < mean(Sample1)
%
function H_FLAG = util_htest(Sample1,Sample2,ALPHA)
nSample = length(Sample1);
if nSample < 15
    meadian_Sample1 = meadian(Sample1);
    meadian_Sample2 = meadian(Sample2);
    meadian_diff    = abs(meadian_Sample1-meadian_Sample2);
    if meadian_diff < eps
        H_FLAG = 0;
    elseif meadian_Sample2 > meadian_Sample1
        H_FLAG = 1;
    else
        H_FLAG = -1;
    end
else
    %% ranksum
    [~,H_FLAG] = ranksum(Sample1,Sample2,'alpha',ALPHA,'tail','left');
    if ~H_FLAG
        [~,flag] = ranksum(Sample1,Sample2,'alpha',ALPHA,'tail','right');
        if flag
            H_FLAG = -1;
        end
    end
    H_FLAG = double(H_FLAG);
end
