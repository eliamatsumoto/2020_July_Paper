%% Script
%
% MODELS Outcomes per model (Full Dataset)
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

%% Output path
OutputPath = 'DataFiles\Outcomes\Experiment_';

%% Reading all WORKING DATASET files
WDPath  = 'DataFiles\WorkingData\WD_';
WDFiles = dir([WDPath '*.mat']);
nWD     = length(WDFiles);
WD      = cell(nWD,1);
NTES    = 0;
for i = 1:nWD
    WD{i} = load([WDFiles(i).folder '\' WDFiles(i).name]);
    NTES  = NTES + length(WD{i}.Y_Tes);
end

%% UNIQUE TEST DATASET
Y_TES   = zeros(NTES,1);
RET_TES = zeros(NTES,1);
TAG_TES = zeros(NTES,nTAG);
DAT_TES = zeros(NTES,1);
WD_IDX  = zeros(nWD,2);
YH_VOT  = zeros(NTES,length(MODELS_EXP));
c = 1;
for i = 1:nWD
    ntes = length(WD{i}.Y_Tes);
    p1   = c;
    p2   = c + ntes - 1;
    Y_TES(p1:p2)     = WD{i}.Y_Tes;
    RET_TES(p1:p2)   = WD{i}.RET_Tes;
    TAG_TES(p1:p2,:) = WD{i}.TAG_Tes;
    DAT_TES(p1:p2)   = WD{i}.DATE_Tes;
    c = p2+1;
    WD_IDX(i,:) = [p1 p2];
end

%% FOR EACH MODEL TYPE
for M = MODELS_EXP
    
    %% MODEL files
    MODEL_Type = MODELS_NAME{M};
    MDPath     = ['DataFiles\Models\' MODEL_Type '_'];
    MDFiles    = dir([MDPath '*.mat']);
    
    %% Outcomes for each of the experiments
    YH = zeros(NTES,1);
    c  = 1;    
    for i = 1:nWD
        %% Working dataset and Model Info
        Experiment_ID = WDFiles(i).name(end-9:end);
        MDInfo        = load([MDFiles(i).folder '\' MDFiles(i).name]);
        %% Working Data
        WDInfo  = WD{i};        
        ntes    = length(WDInfo.Y_Tes);
        p1      = c;
        p2      = c + ntes - 1;
        c = p2+1;        
        %% MODEL Outcome
        YH(p1:p2) = MDInfo.YH_TES;
    end
    
    %% Outcomes for each of the experiments
    B = WD_IDX(BASE,1); % Discard the past
    MET_YH = util_cls_metrics(Y_TES(B:end),YH(B:end),RET_TES(B:end));

    %% Save Models and predictions
    OutputFile = [OutputPath MODEL_Type];
    disp(OutputFile);
    save(OutputFile, 'Y_TES', 'RET_TES', 'TAG_TES', 'DAT_TES', 'WD_IDX', ...
        'YH', 'MET_YH','WD_IDX');
    YH_VOT(:,M) = sign(sum(YH,2));
end

%% Voting
YH      = sign(sum(YH_VOT(:,2:end),2));
MET_YH = util_cls_metrics(Y_TES(B:end),YH(B:end),RET_TES(B:end));
OutputFile = [OutputPath 'Voting'];
disp(OutputFile);
save(OutputFile, 'Y_TES', 'RET_TES', 'TAG_TES', 'DAT_TES', 'WD_IDX', ...
        'YH', 'MET_YH','WD_IDX');

