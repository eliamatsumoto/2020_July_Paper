% %bmpt_actual,wmt_actual] = ...
%    util_bmt_actual(ID,p1,p2,TAG_TES,YTES,RET,MD_YH)
%
function [bmt_actual,wmt_actual] = ...
    util_bmt_actual(ID,p1,p2,TAG_TES,YTES,RET,MD_YH)

%% Initialization
nMETRICS   = 5;
nMD        = size(MD_YH,1);
nTAG       = size(TAG_TES,2);
bmt_actual = cell(1,nTAG);
wmt_actual = cell(1,nTAG);

%% For all tags
for S = 1:nTAG
    Scores = -Inf*ones(nMD,nMETRICS);
    %% For all models but RND: collect outcomes
    itag  = find(TAG_TES(p1:p2,S));
    ytesp = YTES(itag);
    retp  = RET(itag);
    for M = 2:nMD
        yh  = MD_YH{M};
        yhp = yh(itag);
        Scores(M,:) = util_cls_metrics(ytesp,yhp,retp);
    end
    
    %% All "best" and "worst'
    ValMax = max(Scores(:,ID));
    ValMin = min(Scores(:,ID));
    IdMax  = find(Scores(:,ID)==ValMax); 
    IdMin  = find(Scores(:,ID)==ValMin); 
    bmt_actual{S} = IdMax;
    wmt_actual{S} = IdMin;
end
