%% H_FLAG = util_htest(Sample,BenchSample,ALPHA)
%
%  H_FLAG =  -1 (mean(Sample) < mean(BenchSample)
%  H_FLAG =  0  (mean(Sample) ~ mean(BenchSample)
%  H_FLAG =  1  (mean(Sample) > mean(BenchSample)
%
function H_FLAG = util_htest(Sample,BenchSample,ALPHA)
if all(isfinite(Sample))
    nS = length(Sample);
    nB = length(BenchSample);
    if nS == 1 && nB == 1
        if abs(Sample-BenchSample) < eps
            H_FLAG = 0;
        elseif Sample < BenchSample
            H_FLAG = -1;
        else
            H_FLAG = 1;
        end
    else
        if nS == 1 % Scalar (ttest)
            H_FLAG = ttest(BenchSample,Sample,'alpha',ALPHA,'tail','left');
            if isnan(H_FLAG)
                % Samples are identical
                H_FLAG = 0;
            else
                if ~H_FLAG
                    flag = ttest(BenchSample,Sample,'alpha',ALPHA,'tail','right');
                    if flag
                        H_FLAG = -1;
                    end
                end
            end
         else % Vector
            nS = min(length(Sample),length(BenchSample));
            H_FLAG = ttest2(Sample(1:nS),BenchSample(1:nS),'alpha',ALPHA,'tail','righ');
            if isnan(H_FLAG)
                % Samples are identical
                H_FLAG = 0;
            else
                if ~H_FLAG
                    flag = ttest2(Sample(1:nS),BenchSample(1:nS),'alpha',ALPHA,'tail','left');
                    if flag
                        H_FLAG = -1;
                    end
                end
            end
        end
        H_FLAG = double(H_FLAG);
    end
else
    H_FLAG = -1;
end

