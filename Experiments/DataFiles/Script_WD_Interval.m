%% Script
%
% WD_Interval: Working dataset intervals
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

%% Output file
TABLE8_file   = '..\..\DataAnalysis\TABLE_3_6.xlsx';

%% Reading all WORKING DATASET files
WDPath  = 'WorkingData\WD_';
WDFiles = dir([WDPath '*.mat']);
nWD     = length(WDFiles);
WD_Info = cell(nWD,6);

%% For each Experiment
for i = 1:nWD
    WD = load([WDFiles(i).folder '\' WDFiles(i).name]);
    %% Training interval
    WD_Info{i,1} = datestr(WD.DATE_Tra(1),'mmm.dd.yyyy');
    WD_Info{i,2} = datestr(WD.DATE_Tra(end),'mmm.dd.yyyy');
    WD_Info{i,3} = length(WD.Y_Tra);
    WD_Info{i,4} = datestr(WD.DATE_Tes(1),'mmm.dd.yyyy');
    WD_Info{i,5} = datestr(WD.DATE_Tes(end),'mmm.dd.yyyy');
    WD_Info{i,6} = length(WD.Y_Tes);
end

%% Write (XLSX): Sliding Window
RANGE_WD   = ['B5:G' num2str(4+size(WD_Info,1))];
xlswrite(TABLE8_file,WD_Info,'Table3',RANGE_WD);

%% Write (XLSX): Table 8
npast  = sum(cell2mat(WD_Info(1:12,6)));
ntotal = sum(cell2mat(WD_Info(:,6)));
ntest  = ntotal - npast;
WD_Dates = { ...
    WD_Info{1,4} WD_Info{end,5} ntotal ; ...
    WD_Info{1,4} WD_Info{12,5}  npast  ; ...
    WD_Info{13,4} WD_Info{end,5} ntest };
xlswrite(TABLE8_file,WD_Dates,'Table6','A2:C4');

