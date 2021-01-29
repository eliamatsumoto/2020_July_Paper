%% id = util_min_loss(loss)
%
%
function ID = util_min_loss(loss,TYPE)

%% Initialization
ALPHA     = 0.1;
nrun      = size(loss,1);
nall      = size(loss,2);
flag      = zeros(nall,1);

%% Test
if nrun > 1
    mloss     = mean(loss);
    [~,IdMin] = min(mloss);
    for i = 1:nall
        flag(i) = ttest2(loss(:,IdMin),loss(:,i),'alpha',ALPHA,'tail','left');
    end
    disp(flag);
 
    %% Outcomes
    MinList = find(~flag);
    switch TYPE
        case 'KNN'
            ID = max(MinList(1),IdMin);
        case 'MLP'
            ID = max(MinList(1),IdMin); % MinList(1);
        case 'RF'
            ID = max(MinList(1),IdMin);
        case 'SVM'
            ID = max(MinList(1),IdMin); % MinList(1);
    end
else
    [~,ID] = min(loss);
end