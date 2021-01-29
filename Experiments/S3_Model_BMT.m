%% Script
%
% BMT MODEL (Best Model per Tag)
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
%% Reseting environment
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window

%% Initialization
%
Script_Main_Settings

%% File information
InPath   = 'DataFiles\Outcomes\Experiment_';
RANGE_BMT = 'C3:X122';

%% Reading all MODELS+Voting
nALL    = nMODELS + 1;
ALL_MOD = [MODELS_NAME 'Voting'];
MD      = cell(nALL,1);
MD_YH   = cell(nALL,1);
for M = 1:nALL
    MD{M}      = load([InPath ALL_MOD{M} '.mat']);
    MD_YH{M}   = MD{M}.YH;
end

%% BENCHMARK: RND
BENCH = MD{1};

%% Data Info
Y_TES   = BENCH.Y_TES;
RET_TES = BENCH.RET_TES;
TAG_TES = BENCH.TAG_TES;
DAT_TES = BENCH.DAT_TES;
WD_IDX  = BENCH.WD_IDX;
NTES    = length(Y_TES);
nEX     = size(WD_IDX,1);
nGR     = nEX - BASE + 1;

%% FOR EACH OF THE METRICS: ACC PRE SEN F1C SPC EARN
for ID = 1:nMETRICS
    
    %% Initializing variables
    BMT_PREDICT = zeros(nGR,nTAG);
    BMT_RANKING = zeros(nGR,nTAG);
    BMT_ACTUAL  = cell(nGR,1);
    WMT_ACTUAL  = cell(nGR,1);
    YH          = zeros(NTES,1);
    MET_YH      = zeros(nEX,nMETRICS);
    
    %% For all observations "From now on"
    for N = BASE:nEX
        %% Last PAST months before N
        i2 = N-1;
        i1 = i2 - PAST + 1;
        p1 = WD_IDX(i1,1);
        p2 = WD_IDX(i2,2);
        disp(['[ ' num2str(p1) ' , ' num2str(p2) ' ]']);
        BMT_PREDICT(N,:) = ...
            util_bmt_models(ID,p1,p2,TAG_TES,Y_TES,RET_TES,MD_YH);
        
        %% Prediction for NOW
        n1 = WD_IDX(N,1);
        n2 = WD_IDX(N,2);
        yh = util_bmt_prediction(BMT_PREDICT(N,:),n1,n2,TAG_TES,MD_YH);
        YH(n1:n2) = yh;
        
        %% Metrics for NOW
        ytes        = Y_TES(n1:n2);
        ret         = RET_TES(n1:n2);
        MET_YH(N,:) = util_cls_metrics(ytes,yh,ret);
        
        %% Actual BMTP
        [bmt_actual,wmt_actual] = util_bmt_actual(ID,n1,n2,TAG_TES,Y_TES,RET_TES,MD_YH);
        BMT_ACTUAL{N} = bmt_actual;
        WMT_ACTUAL{N} = wmt_actual;
        
        %% BMT_Ranking (Best/Worst)
        for i = 1:nTAG
            if ismember(BMT_PREDICT(N,i),bmt_actual{i})
                BMT_RANKING(N,i) = 1;
            elseif ismember(BMT_PREDICT(N,i),wmt_actual{i})
                BMT_RANKING(N,i) = -1;
            end
        end
    end
    
    %% METRICS
    B = WD_IDX(BASE,1); % Discard the past
    MET_YH  = util_cls_metrics(Y_TES(B:end),YH(B:end),RET_TES(B:end));
    
    %% Save Models and predictions
    OutputFile = ['DataFiles\Outcomes\Experiment_BMT_' METRICS_NAME{ID}];
    disp(OutputFile);
    save(OutputFile, 'Y_TES', 'RET_TES', 'TAG_TES', 'DAT_TES', 'WD_IDX', ...
        'YH', 'MET_YH');
    
    %% Write XLS
    BMTPFile   = ['DataFiles\Xlsx\BMT_' METRICS_NAME{ID} '.xlsx'];
    xlswrite(BMTPFile,BMT_PREDICT(BASE:end,:),'BMT',RANGE_BMT);
    xlswrite(BMTPFile,BMT_RANKING(BASE:end,:),'Ranking',RANGE_BMT);
    
    %% Counting model
    BMT_Counting = zeros(1,nALL);
    WMT_Counting = zeros(1,nALL);
    for M = 2:nALL
        for i = BASE:nGR
            for j = 1:nTAG
                bmt_list = BMT_ACTUAL{i}{j};
                if ismember(M,bmt_list)
                    BMT_Counting(M) = BMT_Counting(M)+1;
                end
                wmt_list = WMT_ACTUAL{i}{j};
                if ismember(M,wmt_list)
                    WMT_Counting(M) = WMT_Counting(M)+1;
                end
            end
        end
    end
    xlswrite(BMTPFile,BMT_Counting(2:end),'Table_9','C9:H9');
end
