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

%% Models training NRUNS
InputPath = '..\Runs\';
RunDir    = dir([InputPath '\DataFiles*']);
nRun      = length(RunDir);

nWD = 132;
KNN = zeros(nWD,nRun);
MLP = zeros(nWD,nRun);
RF  = zeros(nWD,nRun);
SVM = zeros(nWD,nRun);

%% For each Run
for R = 1:nRun
    HPFile   = [InputPath RunDir(R).name '\Models\HyperParam.mat'];
    Info     = load(HPFile);
    KNN(:,R) = Info.HP.KNN;
    MLP(:,R) = Info.HP.MLP;
    RF(:,R)  = Info.HP.RF;
    SVM(:,R) = Info.HP.SVM;
end

%% Couting
HP_all = round([ KNN(:) MLP(:) RF(:) SVM(:)]);
HP_lb  = {'KNN' 'MLP' 'RF' 'SVM'};
HP_md  = mode(HP_all);

%% Plot
for i = 1:4
    subplot(1,4,i);
    nval  = unique(HP_all(:,i));
    nbins = length(nval);
    histogram(HP_all(:,i));
    ha = gca;
    ha.XTick = nval;
    title([HP_lb{i} ' - mode: ' num2str(HP_md(i))]);
end
