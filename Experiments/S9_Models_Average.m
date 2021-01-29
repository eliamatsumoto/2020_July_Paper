%% Script
%
% MODELS NRUNS AVERAGES
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
Script_Main_Settings

%% Working Data Set file names
InputPath = 'DataFiles\WorkingData\WD_';
WDS       = dir([InputPath '*.mat']);
nWD       = length(WDS);

%% Models training NRUNS
InputPath = '..\Runs\';
RunDir    = dir([InputPath '\DataFiles*']);
nRun      = length(RunDir);

%% FOR EACH EXPERIMENT
for i = 1:nWD 
    
    %% Initialization
    Experiment_ID = WDS(i).name(end-9:end);
    
    %% FOR EACH MODEL TYPE
    for M = MODELS_TRAIN
        
        %% Initialization
        MODEL_Type  = MODELS_NAME{M};
        OutputPath  = ['DataFiles\Models\' MODEL_Type '_'];
        disp(['[#' num2str(i) '] : ' MODEL_Type '#' Experiment_ID]);
        
        %% First run
        MDPath = [InputPath RunDir(1).name '\Models\' MODEL_Type]; 
        MDFile = [MDPath '_' Experiment_ID];   
        MDInfo = load(MDFile);
        YH_TRA = MDInfo.YH_TRA;
        YH_TES = MDInfo.YH_TES;
        
        %% Next runs
        for R = 2:nRun
            MDPath = [InputPath RunDir(R).name '\Models\' MODEL_Type];  
            MDFile = [MDPath '_' Experiment_ID];     
            MDInfo = load(MDFile);
            YH_TRA = YH_TRA + MDInfo.YH_TRA;
            YH_TES = YH_TES + MDInfo.YH_TES;
        end
        YH_TRA = sign(YH_TRA);
        YH_TES = sign(YH_TES);
        
        %% Save Models and predictions
        OutputFile     = [OutputPath Experiment_ID ];
        save(OutputFile,'YH_TRA','YH_TES');
    end
end
