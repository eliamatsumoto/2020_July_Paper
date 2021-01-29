%% Script
%
% RETURN PER MONTH / TAG
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
%% Output file
XLSFile = 'TABLEAB.xlsx';
FMonth  = 'Month';
RMonth  = 'B2:H13';
FTag    = 'Tag';
RTag    = 'B2:H23';
FTable3 = 'Table3';
RTable3 = 'B2:C8';

%% Initialization

MONTH  = 1:12;
nMONTH = length(MONTH);
lMONTH = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' };

TAG  = -10:1:11;
nTAG = length(TAG);
lTAG    = { ...
    'L-10' 'L-9' 'L-8' 'L-7' 'L-6' 'L-5' 'L-4' 'L-3' 'L-2' 'L-1' 'LAST' ...
    'FIRST' 'F+1' 'F+2' 'F+3' 'F+4' 'F+5' 'F+6' 'F+7' 'F+8' 'F+9' 'F+10' };


%% Reading all DATA
DataFile = '..\Experiments\DataFiles\RawData\Data_Full.mat';
load(DataFile);

%% Purging outliers
idx             = find(isnan(Y_Full));
DATE_Full(idx)  = [];
RET_Full(idx)   = [];
TAG_Full(idx,:) = [];

%% PER MONTH
MONTH_Full = month(DATE_Full);
nOBS       = round(length(RET_Full)/nMONTH);
RetMonth   = zeros(nOBS,12);
TabMonth   = zeros(12,7);
for i = 1:12
    idx                = find(MONTH_Full==i);
    aux                = RET_Full(idx);
    naux               = length(aux);
    RetMonth(1:naux,i) = aux;
    TabMonth(i,1) = length(aux);
    TabMonth(i,2) = mean(aux);
    TabMonth(i,3) = std(aux);
    TabMonth(i,4) = min(aux);
    TabMonth(i,5) = max(aux);
    TabMonth(i,6) = median(aux);
end
TabMonth(:,7) = abs(TabMonth(:,3)./TabMonth(:,2));
xlswrite(XLSFile,TabMonth,FMonth,RMonth);

% Filling "zeros" with NaN
idz = find(abs(RetMonth)<eps);
RetMonth(idz) = NaN;  

%% PER TAG
nOBS   = length(TAG_Full);
TAG_ID = zeros(nOBS,1);
for i = 1:nOBS
    aux = find(TAG_Full(i,:),1,'last');
    if aux
        TAG_ID(i) = aux;
    else
        TAG_ID(i) = 1;
    end
end
TabTag = zeros(nTAG,7);
nOBS   = round(length(RET_Full)/nTAG);
RetTag = zeros(nOBS,nTAG);
for i = 1:nTAG
    idx              = find(TAG_ID==i);
    aux              = RET_Full(idx);
    naux             = length(aux);
    RetTag(1:naux,i) = aux;
    TabTag(i,1) = length(aux);
    TabTag(i,2) = mean(aux);
    TabTag(i,3) = std(aux);
    TabTag(i,4) = min(aux);
    TabTag(i,5) = max(aux);
    TabTag(i,6) = median(aux);
end
TabTag(:,7) = abs(TabTag(:,3)./TabTag(:,2));
xlswrite(XLSFile,TabTag,FTag,RTag);

% Filling "zeros" with NaN
idz = find(abs(RetTag)<eps);
RetTag(idz) = NaN;  

%% ANOVA1 Per Month

[p,tbl,~] = anova1(RetMonth(1:190,:),[],'off');
disp(p);
disp(tbl);

% Box Plot
boxplot(RetMonth,'Plotstyle','compact','colors','k');
ha = gca;
ha.YLabel.String = 'BRL/USD Variation';
ha.XLim   = [0 nMONTH+1];
ha.XTick  = 1:nMONTH;
ha.XTickLabel = lMONTH;
ha.XTickLabelRotation = 45;
ha.FontSize = 12;
ht = title('BRL/USD Variation per MONTH');
ht.FontSize = 14;

% Set FIGURE
hf = gcf;
set(hf,'Position',[50 50 1170 590]);
% Save figure
exportgraphics(hf,'Fig_03.jpg','Resolution',300);

%% ANOVA1 Per TAG

[p,tbl,~] = anova1(RetTag(1:end-2,:),[],'off');
disp(p);
disp(tbl);

% Box Plot
boxplot(RetTag,'Plotstyle','compact','colors','k');
ha = gca;
ha.YLabel.String = 'BRL/USD Variation';
ha.XLim   = [0 nTAG+1];
ha.XTick  = 1:nTAG;
ha.XTickLabel = lTAG;
ha.XTickLabelRotation = 45;
ha.FontSize = 12;
ht = title('BRL/USD Variation per TAG');
ht.FontSize = 14;

% Set FIGURE
hf = gcf;
set(hf,'Position',[50 50 1170 590]);
% Save figure
exportgraphics(hf,'Fig_04.jpg','Resolution',300);
