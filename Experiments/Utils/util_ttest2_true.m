%% H_FLAG = util_ranksum(Sample1,Sample2,ALPHA)
%
%  H_FLAG =  1 (mean(Sample2) > mean(Sample1)
%  H_FLAG =  0 (mean(Sample2) ~ mean(Sample1)
%  H_FLAG = -1 (mean(Sample2) < mean(Sample1)
%
function H_FLAG = util_ttest2(Sample1,Sample2,ALPHA)
H_FLAG = ttest2(Sample1,Sample2,'alpha',ALPHA,'tail','left');
if ~H_FLAG
    flag = ttest2(Sample1,Sample2,'alpha',ALPHA,'tail','right');
    if flag
        H_FLAG = -1;
    end
end
H_FLAG = double(H_FLAG);

