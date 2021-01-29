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

%% PER MONTH
MONTH_Full = month(DATE_Full);
nOBS   = 297;
PMonth = zeros(nOBS,nMONTH);
for i = 1:nMONTH
    idx  = find(MONTH_Full==i);
    aux  = RET_Full(idx);
    PMonth(:,i) = aux(1:nOBS);
end
% Mean
Month_mean = mean(PMonth);
% T-test
WPMonth = [PMonth PMonth(:,1)];
H0      = zeros(nMONTH,1);
ALPHA   = 0.02;
for i=1:nMONTH
    H0(i) = ttest2(WPMonth(:,i),WPMonth(:,i+1),'alpha',ALPHA);
end
% Plot
subplot(2,1,1);
boxplot(PMonth,lMONTH,'LabelOrientation' ,'inline', ...
       'Color','k');
ht = title('BRL/USD Variation average per MONTH');
set(ht,'FontSize',14);
hold
idx  = find(H0);
nidx = length(idx);
if nidx
    yidx = -0.25*ones(nidx,1);
    hp=plot(idx,yidx,'k*');
    set(hp,'MarkerSize',10);
end
ha = gca;
set(ha,'Position',[0.07 0.60 0.90 0.35]);


%% PER TAG
nOBS = 189;
PTag = zeros(nOBS,nTAG);
for i = 1:nTAG
    idx  = find(TAG_Full(:,i));
    aux  = RET_Full(idx);
    PTag(:,i) = aux(1:nOBS);
end
% Mean
Tag_mean = mean(PTag);
% T-test
WPTag = [PTag PTag(:,1)];
H0      = zeros(nTAG,1);
ALPHA   = 0.05;
for i=1:nTAG
    H0(i) = ttest2(WPTag(:,i),WPTag(:,i+1),'alpha',ALPHA);
end
% Plot
subplot(2,1,2);
boxplot(PTag,lTAG,'LabelOrientation' ,'inline', ...
    'Color','k');
ht = title('BRL/USD Variation average per TAG');
set(ht,'FontSize',14);
hold
idx  = find(H0);
nidx = length(idx);
if nidx
    yidx = -0.25*ones(nidx,1);
    hp=plot(idx,yidx,'k*');
    set(hp,'MarkerSize',10);
end
ha = gca;
set(ha,'Position',[0.07 0.10 0.90 0.35]);

%% Set FIGURE size
hf = gcf;
set(hf,'Position',[50 50 1170 590]);

%% Table
Per_Month = [ mean(PMonth); ...
              std(PMonth) ; ...
              min(PMonth) ; ...
              max(PMonth) ; ...
              median(PMonth) ; ...
              abs(std(PMonth)./mean(PMonth))]';
Per_Tag   = [ mean(PTag); ...
              std(PTag) ; ...
              min(PTag) ; ...
              max(PTag) ; ...
              median(PTag) ; ...
              abs(std(PTag)./mean(PTag))]';
                    
%  %% XLSwrite
xlswrite('RET_Stats.xlsx',Per_Month,'Month');
xlswrite('RET_Stats.xlsx',Per_Tag,'Tag');

 %% Plot Mean
figure
subplot(1,2,1);
h=plot(1:nMONTH,Month_mean,'ko');
grid
set(h,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'LineWidth',1.5);
ht = title('BRL/USD Variation average per Month');
set(ht,'FontSize',14);
ha = gca;
ylim = [-0.005 0.005];
set(ha,'Xlim',[1 nMONTH],'YLim',ylim);
set(ha,'XTick',1:nMONTH,'XTickLabel',lMONTH,'XTickLabelRotation',90);
set(ha,'Position',[0.05 0.10 0.425 0.80]);
subplot(1,2,2);
h=plot(1:nTAG,Tag_mean,'ko');
grid
set(h,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'LineWidth',1.5);
ht = title('BRL/USD Variation average per TAG');
set(ht,'FontSize',14);
ha = gca;
set(ha,'Xlim',[1 nTAG],'YLim',ylim);
set(ha,'XTick',1:nTAG,'XTickLabel',lTAG,'XTickLabelRotation',90);
set(ha,'Position',[0.525 0.10 0.425 0.80]);
% Set FIGURE size
hf = gcf;
set(hf,'Position',[50 50 1170 590]);
