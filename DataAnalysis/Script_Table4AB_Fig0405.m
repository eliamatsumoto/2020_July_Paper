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
%% Output file
XLSFile = 'TABLE4AB.xlsx';
FMonth  = 'Month';
RMonth  = 'B2:H13';
FTag    = 'Tag';
RTag    = 'B2:H23';
FTable4 = 'Table4';
RTable4 = 'B2:C7';

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
PMonth = zeros(12,7);
for i = 1:12
    idx  = find(MONTH_Full==i);
    aux  = RET_Full(idx);
    PMonth(i,1) = length(aux);
    PMonth(i,2) = mean(aux);
    PMonth(i,3) = std(aux);
    PMonth(i,4) = min(aux);
    PMonth(i,5) = max(aux);
    PMonth(i,6) = median(aux);
end
PMonth(:,7) = abs(PMonth(:,3)./PMonth(:,2));
xlswrite(XLSFile,PMonth,FMonth,RMonth);

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
PTag = zeros(nTAG,7);
for i = 1:nTAG
    idx  = find(TAG_ID==i);
    aux  = RET_Full(idx);
    PTag(i,1) = length(aux);
    PTag(i,2) = mean(aux);
    PTag(i,3) = std(aux);
    PTag(i,4) = min(aux);
    PTag(i,5) = max(aux);
    PTag(i,6) = median(aux);
end
PTag(:,7) = abs(PTag(:,3)./PTag(:,2));
xlswrite(XLSFile,PTag,FTag,RTag);

%% Table 4: Volatility 
MVol = PMonth(:,7);
TVol = PTag(:,7);
aux = [ 
    mean(MVol)   mean(TVol) ; ...
    std(MVol)    std(TVol) ; ...
    min(MVol)    min(TVol) ; ...
    max(MVol)    max(TVol) ; ...
    median(MVol) median(TVol) ; ...
    abs(std(MVol)/mean(MVol)) abs(std(TVol)/mean(TVol))];
xlswrite(XLSFile,aux,FTable4,RTable4);

%% FIG 3 : Plot per month
hf = figure;
grid on
subplot(3,1,1);
plot(MONTH,PMonth(:,7),'ko--');
grid on
ht = title('BRL/USD: Return volatility average per MONTH');
ht.FontSize = 12;
ha = gca;
ha.XLim = [1 nMONTH];
ha.XTick = MONTH;
ha.XTickLabel = {};
ht = ylabel('Return volatility');
ht.FontSize = 12;
subplot(3,1,2);
plot(MONTH,PMonth(:,2),'ko--');
grid on
ht = title('BRL/USD: Return average per MONTH');
ht.FontSize = 12;
ha = gca;
ha.XLim = [1 nMONTH];
ha.XTick = MONTH;
ha.XTickLabel = {};
ht = ylabel('Return average');
ht.FontSize = 12;
subplot(3,1,3);
plot(MONTH,PMonth(:,3),'ko--');
grid on
ht = title('BRL/USD: Return standard deviation per MONTH');
ht.FontSize = 12;
ht = ylabel('Return std.dev.');
ht.FontSize = 12;
ha = gca;
ha.XLim = [1 nMONTH];
ha.XTick = MONTH;
ha.XTickLabel = lMONTH;
ha.XTickLabelRotation = 90;

% Set position
set(hf,'Position',[35 100 1320 600]);
% Save figure
exportgraphics(gcf,'Fig_04.jpg','Resolution',300);

%% FIG 4 : Plot per TAG
hf = figure;
grid on
subplot(3,1,1);
plot(1:nTAG,PTag(:,7),'ko--');
grid on
ht = title('BRL/USD: Return volatility average per TAG');
ht.FontSize = 12;
ha = gca;
ha.XLim = [1 nTAG];
ha.XTick = 1:nTAG;
ha.XTickLabel = {};
ht = ylabel('Return volatility');
ht.FontSize = 12;
subplot(3,1,2);
plot(1:nTAG,PTag(:,2),'ko--');
grid on
ht = title('BRL/USD: Return average per TAG');
ht.FontSize = 12;
ha = gca;
ha.XLim = [1 nTAG];
ha.XTick = 1:nTAG;
ha.XTickLabel = {};
ht = ylabel('Return average');
ht.FontSize = 12;
subplot(3,1,3);
plot(1:nTAG,PTag(:,3),'ko--');
grid on
ht = title('BRL/USD: Return standard deviation per TAG');
ht.FontSize = 12;
ht = ylabel('Return std.dev.');
ht.FontSize = 12;
ha = gca;
ha.XLim = [1 nTAG];
ha.XTick = 1:nTAG;
ha.XTickLabel = lTAG;
ha.XTickLabelRotation = 90;

% Set position
set(hf,'Position',[35 100 1320 600]);

%% Save figure
exportgraphics(gcf,'Fig_05.jpg','Resolution',300);

