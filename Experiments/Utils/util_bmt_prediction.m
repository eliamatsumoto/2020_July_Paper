%% YH = util_bmpt_prediction(BMPT,N1,N2,TAG_TES,MD_YH)
%
function YH = util_bmt_prediction(BMPT,N1,N2,TAG_TES,MD_YH)

%% Initialization
NN  = N2 - N1 + 1;
YH  = zeros(NN,1);

%% For all observations
for i = 1:NN
    p   = N1+(i-1);
    tag = find(TAG_TES(p,:));
    if isempty(tag)
        tag = 1;  % No tag ~ middle of the month
    end
    idx = BMPT(tag);
    md  = MD_YH{idx};
    if ~isempty(md)
        YH(i) = sign(sum(md(p,:)));
    end
end

