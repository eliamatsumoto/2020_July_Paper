%% Script
%
% XLSx: MODELS OUTCOMES PER TAG
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
%
%% Initialization
%
Script_Main_Settings
Script_METRIC_ID
%
%% Files path
InPath  = 'DataFiles\Outcomes\Experiment_';
OutPath = 'DataFiles\Outcomes\Tag_';

%% XLS file
XLSFile  = 'DataFiles\Xlsx\Outcomes_TAG.xlsx';
RANGE_MT = 'A3:E24';
RANGE_H0 = 'F3:F24';

%% Voting 
MODELS_EXP1   = [MODELS_EXP 7];
MODELS_NAME1  = [MODELS_NAME {'Voting'} ];

%% FOR EACH MODEL TYPE
for M = MODELS_EXP1
    
    %% Reading MODEL files 
    MODEL_Type = MODELS_NAME1{M};
    MDFile     = [InPath MODEL_Type '.mat'];
    MD         = load(MDFile);
    
    %% Initialization
    TAG_MT = zeros(nTAG,nMETRICS);
    TAG_H0 = zeros(nTAG,1);
    
    %% For each TAG
    for S = 1:nTAG
        
        %% TAG
        disp([MODEL_Type ' Tag(' sTAG{S} ')']);
        tag_flag = MD.TAG_TES(:,S);
        tag_idx  = find(tag_flag);
        
        %% Discard "the past"
        B = MD.WD_IDX(BASE,1);
        id = find(tag_idx < BASE);
        tag_idx(id) = [];
        
        %% Y, YH_
        ytes = MD.Y_TES(tag_idx);
        yh   = MD.YH(tag_idx);
        ret  = MD.RET_TES(tag_idx);
        %% Metrics
         met_yh      = util_cls_metrics(ytes,yh,ret);
         TAG_MT(S,:) = met_yh;

        %% Comparing outcomes
        if M == 1
            RND = MD;
        else
            bench_yh = RND.MET_YH(:,ID);
            H0    = util_htest(met_yh(ID),bench_yh,ALPHA);
            TAG_H0(S) = H0;
        end
    end
    
    %% Save MAT
    OutputFile = [OutPath MODEL_Type '.mat'];
    disp(OutputFile);
    save(OutputFile, 'TAG_MT', 'TAG_H0');
    
    %% Write XLS
    xlswrite(XLSFile,TAG_MT,MODEL_Type,RANGE_MT);
    if M > 1
        xlswrite(XLSFile,TAG_H0,MODEL_Type,RANGE_H0);
    end
end
