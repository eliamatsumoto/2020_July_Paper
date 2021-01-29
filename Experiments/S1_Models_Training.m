%% Script
%
% MODELS TRAINING
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

MODELS_TRAIN = 1;

MD_OPTIM     = [1 1 1 0 1 1];

%% Working Data Set file names
InputPath = 'DataFiles\WorkingData\WD_';
WDS       = dir([InputPath '*.mat']);
nWD       = length(WDS);

%% FOR EACH EXPERIMENT
for i = 1:nWD 
    
    %% Reading Working Data (WD)
    Experiment_ID = WDS(i).name(end-9:end);
    WD   = load([WDS(i).folder '\' WDS(i).name]);
    XTRA = WD.X_Tra;
    YTRA = WD.Y_Tra;
    XTES = WD.X_Tes;
    YTES = WD.Y_Tes;
    
    %% FOR EACH MODEL TYPE
    for M = MODELS_TRAIN
        
        %% Initialization
        MODEL_Type  = MODELS_NAME{M};
        TrainingFnc = ['Training_Cls_' MODEL_Type];
        OutputPath  = ['DataFiles\Models\' MODEL_Type '_'];
        disp(['[#' num2str(i) '] : ' MODEL_Type '#' Experiment_ID]);
        
        %% Model training
        MODEL  = feval(TrainingFnc,XTRA,YTRA,MD_OPTIM(M));
        YH_TRA = MODEL.predictFcn(XTRA);
        YH_TES = MODEL.predictFcn(XTES);
        
        % TRACE
        cm = confusionmat(YTES,YH_TES);
        disp(cm);
        disp(['ACC: ' num2str(trace(cm)/sum(cm(:)))]);
        
        %% Save Models and predictions
        OutputFile     = [OutputPath Experiment_ID ];
        save(OutputFile,'MODEL','YH_TRA','YH_TES');
    end
    
end
