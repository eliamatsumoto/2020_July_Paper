%% Script: Preparing Data (Training¨& Testing Working datasets)
%
% TAG: LAST WORKING DAY OF THE MONTH (TAG: -10:1:10)
%
%
% Autor: Elia Matsumoto
%
% Contato: elia.matsumoto@gmail.com
%
% Data: 2020
%
%% Reseting environment
%
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window

%% Initialization
%
TAG  = -10:1:11;
nTAG = length(TAG);

%% Outpug
TABLE2_file   = '..\..\DataAnalysis\TABLE2.xlsx';

%% Files Info
Holidays_mat = 'RawData\BrazilianHoliday.mat';

%% Experiment sets
nWD    = 120+12;  % 10 years + 1 year
MTra   = 48;      % 48 months (4 years)
MTes   = 1;       % 1 month
MTotal = MTra + MTes;
OLProp = zeros(nWD,6);

%% Reading Brazilian Holidays
load(Holidays_mat);

%% Input File
InputFile = 'RawData\Data_Full.mat';
load(InputFile);    % Input Data (Full)

%% FIRST Tagged dates
idx_first = find(FIRST_Full);
idx_last  = find(LAST_Full);

%% For each of the experiment set
for i = 1:nWD
    
    %% Init & Final dates
    base      = (i-1);
    Tra_init  = idx_first(base+1);
    Tra_final = idx_last(base+MTra+1);
    Tes_init  = idx_first(base+MTra+1);
    Tes_final = idx_first(base+MTotal+1)-1;
    % Training dataset
    DATE_Tra   = DATE_Full(Tra_init:Tra_final);
    TAG_Tra    = TAG_Full(Tra_init:Tra_final,:);
    RET_Tra    = RET_Full(Tra_init:Tra_final);
    X_Tra      = X_Full(Tra_init:Tra_final,:);
    Y_Tra      = Y_Full(Tra_init:Tra_final);
    % Test dataset
    DATE_Tes   = DATE_Full(Tes_init:Tes_final);
    TAG_Tes    = TAG_Full(Tes_init:Tes_final,:);
    RET_Tes    = RET_Full(Tes_init:Tes_final);
    X_Tes      = X_Full(Tes_init:Tes_final,:);
    Y_Tes      = Y_Full(Tes_init:Tes_final);
    
    %% Purge Outliers
    nTra_Org = length(Y_Tra);
    idx_out_y = find(isnan(Y_Tra));
    idx_out_r = find(isnan(RET_Tra));
    out_x = zeros(nTra_Org,1);
    for j=1:nTra_Org
        out_x(j) = any(isnan(X_Tra(j,:)));
    end
    idx_out_x = find(out_x);
    idx_out   = union(idx_out_x,union(idx_out_y,idx_out_r));
    DATE_Tra(idx_out)  = [];
    TAG_Tra(idx_out,:) = [];
    RET_Tra(idx_out)   = [];
    X_Tra(idx_out,:)   = [];
    Y_Tra(idx_out)     = [];
    nTra               = length(Y_Tra);
    disp(['NTra: ORG ' num2str(nTra_Org) ' / Purged ' num2str(nTra)]);
    nTes_Org  = length(Y_Tes);
    idx_out_y = find(isnan(Y_Tes));
    idx_out_r = find(isnan(RET_Tes));
    out_x = zeros(nTes_Org,1);
    for j=1:nTes_Org
        out_x(j) = any(isnan(X_Tes(j,:)));
    end    
    idx_out_x = find(out_x);    
    idx_out   = union(idx_out_x,union(idx_out_y,idx_out_r));
    DATE_Tes(idx_out)  = [];
    TAG_Tes(idx_out,:) = [];
    RET_Tes(idx_out)   = [];
    X_Tes(idx_out,:)   = [];
    Y_Tes(idx_out)     = [];
    nTes               = length(Y_Tes);
    disp(['NTes: ORG ' num2str(nTes_Org) ' / Purged ' num2str(nTes)]);   
    if ~isempty(idx_out_r)
        disp(['***** ' num2str(length(idx_out_r))]);
    end
    OLProp(i,:) = [nTra_Org nTra (nTra_Org-nTra)/nTra_Org ...
                   nTes_Org nTes (nTes_Org-nTes)/nTes_Org ];

    %% Working datasets directory
    OutputPath    = 'WorkingData\WD_';
    Experiment_ID = num2str(year(DATE_Tes(end))*100+month(DATE_Tes(end)));
    OutputFile    = [OutputPath Experiment_ID];
    save(OutputFile, ...
        'DATE_Tra','TAG_Tra','RET_Tra','X_Tra','Y_Tra', ...
        'DATE_Tes','TAG_Tes','RET_Tes','X_Tes','Y_Tes'  ...
        );
        
    % Training and Test periods
    disp([OutputFile ' Training Dataset (# Obs ' num2str(length(Y_Tra)) ') : from ' datestr(DATE_Tra(1)) ' to ' datestr(DATE_Tra(end))]);
    disp([OutputFile ' Test Dataset     (# Obs ' num2str(length(Y_Tes)) ') : from ' datestr(DATE_Tes(1)) ' to ' datestr(DATE_Tes(end))]);
end

%% Writting Outliers proportion

RANGE_IDX = ['B3:G' num2str(2+nWD)];
xlswrite(TABLE2_file,OLProp,'Proportion',RANGE_IDX);
