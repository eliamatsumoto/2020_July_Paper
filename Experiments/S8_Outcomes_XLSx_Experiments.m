%% Script
%
% XLSx: MODELS OUTCOMES PER EXPERIMENT
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
%

%% Output Info
OutputFile = 'DataFiles\Xlsx\Outcomes_EXPERIMENT.xlsx';
RMETRICS  = 'B3:E7';

%% Voting
MODELS_EXP1   = [MODELS_EXP 7];
MODELS_NAME1  = [MODELS_NAME {'Voting'} ];

%% FOR EACH MODEL TYPE
for M = MODELS_EXP1
    
    %% Models ID
    MODEL_Type = MODELS_NAME1{M};
    MDFile     = ['DataFiles\Outcomes\Experiment_' MODEL_Type];
    MD         = load(MDFile);
    if M == 1
        RND = MD;  % Benchmark
    end
    
    %% Total Time Frame Metrics (Mean, Std, Vol, H0)
    TTF = zeros(nMETRICS,4);
    for i = 1:nMETRICS
        TTF(i,1) = MD.MET_YH(i);
    end
    if M > 1
        for i = 1:nMETRICS
            bench_met = RND.MET_YH(:,i);
            TTF(i,4) = util_htest(MD.MET_YH(i),bench_met,ALPHA);
        end
    end
    
    %% Write info
    disp(MODEL_Type);
    xlswrite(OutputFile,TTF,MODEL_Type,RMETRICS);
end
