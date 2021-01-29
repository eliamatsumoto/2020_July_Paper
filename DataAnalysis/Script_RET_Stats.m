%% Script
%
% ON PROPORTION PER TAG
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
nMONTH = 12;
nTAG   = 22;

%% Reading all DATA
DataFile = '..\Experiments\DataFiles\RawData\Data_Full.mat';
load(DataFile);

%% PER MONTH
MONTH_Full = month(DATE_Full);
MStats     = zeros(nMONTH,7);
for i = 1:nMONTH
    idx = find(MONTH_Full==i);
    ret = RET_Full(idx);
    MStats(i,1) = length(ret);
    MStats(i,2) = mean(ret);
    MStats(i,3) = std(ret);
    MStats(i,4) = min(ret);
    MStats(i,5) = max(ret);
    MStats(i,6) = median(ret);
    MStats(i,7) = abs(MStats(i,3)/MStats(i,2));
end

%% PER RAG
TStats     = zeros(nTAG,7);
for i = 1:nTAG
    idx = find(TAG_Full(:,i)==1);
    ret = RET_Full(idx);
    TStats(i,1) = length(ret);
    TStats(i,2) = mean(ret);
    TStats(i,3) = std(ret);
    TStats(i,4) = min(ret);
    TStats(i,5) = max(ret);
    TStats(i,6) = median(ret);
    TStats(i,7) = abs(TStats(i,3)/TStats(i,2));
end

%  %% XLSwrite
xlswrite('RET_Stats.xlsx',MStats,'Month');
xlswrite('RET_Stats.xlsx',TStats,'Tag');
