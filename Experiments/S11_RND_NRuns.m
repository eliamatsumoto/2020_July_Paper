%% Script
%
% RND NRUNS TRAINING
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

MODEL_TRAIN = 1;
NRUNS       = 10;
MD_OPTIM    = 1;
MID         = 5;

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
WD_IDX  = zeros(nWD,2);
YTES    = zeros(NTES,1);
RET     = zeros(NTES,1);
c = 1;
for i = 1:nWD
    ntes = length(WD{i}.Y_Tes);
    p1   = c;
    p2   = c + ntes - 1;
    YTES(p1:p2) = WD{i}.Y_Tes;
    RET(p1:p2)  = WD{i}.RET_Tes;
    c = p2+1;
    WD_IDX(i,:) = [p1 p2];
end

%% RND NRUNS
u  = rand(NTES,NRUNS);
YH = sign(u-0.5);

%% Sliding Windows
BASE = WD_IDX(13,1);

%% Window size
nEM      = NSWD;
nW       = NTES - nEM + 1;
SW_Dates = zeros(nEM,2);
METR     = zeros(nEM,NRUNS);

%% For each window
for i = 1:nEM
    p1  = i;
    p2  = p1 + nW - 1;
    y   = YTES(p1:p2);
    ret = RET(p1:p2);
    %% For each of the RUNS
    for j = 1:NRUNS
        yh        = YH(p1:p2,j);
        met       = util_cls_metrics(y,yh,ret);
        METR(i,j) = met(MID);
    end
end
RND_MEAN = mean(METR,2);
RND_MIN  = min(METR,[],2);
RND_MAX  = max(METR,[],2);

plot(1:1500,RND_MEAN,1:1500,RND_MIN,1:1500,RND_MAX)
hold
% plot(METR)
