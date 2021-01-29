%% bmpt_tag = util_bmpt_models(ID,p1,p2,TAG_TES,YTES,RET,MD_YH)
%
function bmpt_tag = ...
    util_bmt_models(ID,p1,p2,TAG_TES,YTES,RET,MD_YH)

%            ACC PRE SEN SPC EARN 
TIEBREAK = [  5   5   5   5   1 ];
VOTING   = 7;
LOGREG   = 3;
MLP      = 4;

%% Initialization
nMETRICS  = 5;
nMD       = size(MD_YH,1);
nTAG      = size(TAG_TES,2);
bmpt_tag  = ones(1,nTAG);

%% For all tags
for S = 1:nTAG
    Scores = -Inf*ones(nMD,nMETRICS);
    %% For all models but RND: collect outcomes
    itag  = find(TAG_TES(p1:p2,S));
    ytesp = YTES(itag);
    retp  = RET(itag);
    for M = 2:nMD
        yh   = MD_YH{M};
        yhp  = yh(itag);
        Scores(M,:) = util_cls_metrics(ytesp,yhp,retp);
    end
    %% Benchmark criteria
    ValMax  = max(Scores(:,ID));
    id_max = find(Scores(:,ID)==ValMax);
    if length(id_max) == 1
        IdMax = id_max;
    else
        %% Tie-break
        if ismember(VOTING,id_max)
            IdMax = VOTING;
        else
            IdMax = VOTING;
%             [~,idaux] = max(Scores(id_max,TIEBREAK(ID)));
%             IdMax = id_max(idaux(1));
        end
    end
    bmpt_tag(S) = IdMax;
end
