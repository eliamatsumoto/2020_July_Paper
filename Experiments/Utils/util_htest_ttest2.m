%% H_FLAG = util_ranksum(Sample1,Sample2,ALPHA)
%
%  H_FLAG =  1 (mean(Sample2) > mean(Sample1)
%  H_FLAG =  0 (mean(Sample2) ~ mean(Sample1)
%  H_FLAG = -1 (mean(Sample2) < mean(Sample1)
%
function H_FLAG = util_htest(Sample1,Sample2,ALPHA)
nSample = length(Sample1);
if nSample < 5
    mean_Sample1 = mean(Sample1);
    mean_Sample2 = mean(Sample2);
    mean_diff    = abs(mean_Sample1-mean_Sample2);
    if mean_diff < eps
        H_FLAG = 0;
    elseif mean_Sample2 > mean_Sample1
        H_FLAG = 1;
    else
        H_FLAG = -1;
    end
else
    %% ttest2
    H_FLAG = ttest2(Sample1,Sample2,'alpha',ALPHA,'tail','left');
    if ~H_FLAG
        flag = ttest2(Sample1,Sample2,'alpha',ALPHA,'tail','right');
        if flag
            H_FLAG = -1;
        end
    end
    H_FLAG = double(H_FLAG);
end
