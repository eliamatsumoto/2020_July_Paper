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

MDPath     = 'DataFiles\Models\';

%% KNN
MDFiles = dir([MDPath 'KNN*.mat']);
nFiles  = length(MDFiles);
KNN     = zeros(nFiles,1);
for i = 1:nFiles
    MDInfo = load([MDFiles(i).folder '\' MDFiles(i).name]);
    KNN(i) = MDInfo.MODEL.KNN.NumNeighbors;
end

%% MLP
MDFiles = dir([MDPath 'MLP*.mat']);
nFiles  = length(MDFiles);
MLP      = zeros(nFiles,1);
for i = 1:nFiles
    MDInfo = load([MDFiles(i).folder '\' MDFiles(i).name]);
    MLP(i) = MDInfo.MODEL.MLP{1}.layers{1}.size;
end

%% RF
MDFiles = dir([MDPath 'RF*.mat']);
nFiles  = length(MDFiles);
RF      = zeros(nFiles,1);
for i = 1:nFiles
    MDInfo = load([MDFiles(i).folder '\' MDFiles(i).name]);
    RF(i)  = MDInfo.MODEL.RF.NumTrained;
end

%% SVM
MDFiles = dir([MDPath 'SVM*.mat']);
nFiles  = length(MDFiles);
SVM     = zeros(nFiles,1);
for i = 1:nFiles
    MDInfo = load([MDFiles(i).folder '\' MDFiles(i).name]);
    SVM(i) = MDInfo.MODEL.SVM.BoxConstraints(1);
end
SVM = 0.01*round(SVM*100);

%% Save Hyper Parameters Info
HP = struct('KNN',KNN,'MLP',MLP','RF',RF,'SVM',SVM);
save([MDPath 'HyperParam.mat'],'HP');

%% Plot
subplot(1,4,1);
histogram(KNN);
title('KNN');
subplot(1,4,2);
histogram(MLP);
title('MLP');
subplot(1,4,3);
histogram(RF);
title('RF');
subplot(1,4,4);
histogram(SVM);
title('SVM');

