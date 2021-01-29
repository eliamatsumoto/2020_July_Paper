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

MODELS_BMT = {'BMT_ACC' 'BMT_PRE' 'BMT_SPC'};

%% Output Experiments
ExpFile  = 'DataFiles\Xlsx\Outcomes_EXPERIMENT.xlsx';
ExpRange = 'B3:B7';
nM         = length(MODELS_BMT);
% FOR EACH MODEL TYPE
for M = 1:nM
    % Models ID
    MODEL_Type = MODELS_BMT{M};
    MDFile     = ['DataFiles\Outcomes\Experiment_' MODEL_Type];
    MD         = load(MDFile);
    MET        = MD.MET_YH';
    %% Write info
    disp(MODEL_Type);
    xlswrite(ExpFile,MET,MODEL_Type,ExpRange);
end

%% Output TAG
OutPath = 'DataFiles\Outcomes\Tag_';
TagFile  = 'DataFiles\Xlsx\Outcomes_TAG.xlsx';
TagRange = 'A3:E24';
% FOR EACH MODEL TYPE
for M = 1:nM
    % Models ID
    MODEL_Type = MODELS_BMT{M};
    MDFile     = ['DataFiles\Outcomes\Experiment_' MODEL_Type];
    MD         = load(MDFile);
    % Initialization
    TAG_MT = zeros(nTAG,nMETRICS);
    % For each TAG
    for S = 1:nTAG
        disp([MODEL_Type ' Tag(' sTAG{S} ')']);
        tag_flag = MD.TAG_TES(:,S);
        tag_idx  = find(tag_flag);
        % Discard "the past"
        B = MD.WD_IDX(BASE,1);
        id = find(tag_idx < BASE);
        tag_idx(id) = [];
        % Y, YH
        ytes = MD.Y_TES(tag_idx);
        yh   = MD.YH(tag_idx);
        ret  = MD.RET_TES(tag_idx);
        idx  = find(yh);
        % Metrics
        met_yh      = util_cls_metrics(ytes(idx),yh(idx),ret(idx));
        TAG_MT(S,:) = met_yh;
    end
    % Save MAT
    OutputFile = [OutPath MODEL_Type '.mat'];
    disp(OutputFile);
    save(OutputFile, 'TAG_MT');
    % Write XLS
    xlswrite(TagFile,TAG_MT,MODEL_Type,TagRange);
end
