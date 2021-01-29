%% Script
%
% RET PER SHIFT
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
nMonth = length(MONTH);
lMONTH = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' };

%% Reading all DATA
DataFile = '..\Experiments\DataFiles\RawData\Data_Full.mat';
load(DataFile);
MONTH_Full = month(DATE_Full);

%% For each MONTH
nOBS = 297;
PMonth = zeros(nOBS,nMonth);
for i = 1:nMonth
    idx  = find(MONTH_Full==i);
    aux  = RET_Full(idx);
    PMonth(:,i) = aux(1:nOBS);
end

%% Mean
MONTH_mean = mean(PMonth);
figure;
hp = plot(1:nMonth,MONTH_mean,'k:o');
set(hp,'MarkerSize',10);
ha = gca;
ylim = [min(MONTH_mean)*2 max(MONTH_mean)*2];
set(ha,'XLim',[1 nMonth],'YLim',ylim);
set(ha,'XTick',1:nMonth,'XTickLabel',lMONTH,'XTickLabelRotation',90);
ht = title('BRL/USD Variation average per tag');
set(ht,'FontSize',14);
% Set position and axis
hf = gcf;
set(hf,'Position',[70 285 1170 380]);
ha = gca;
set(ha,'Position',[0.05 0.20 0.90 0.70]);

%% Box plot
anova1(PMonth,lMONTH);
hold

%% Ttest2
WPMonth = [PMonth PMonth(:,1)];
H0      = zeros(nMonth,1);
ALPHA   = 0.03;
for i=1:nMonth
    H0(i) = ttest2(WPMonth(:,i),WPMonth(:,i+1),'alpha',ALPHA);
end
disp(H0);
idx  = find(H0);
nidx = length(idx);
yidx = -0.27*ones(nidx,1);
plot(idx,yidx,'k*');

figure
boxplot(PMonth,lMONTH,'LabelOrientation' ,'inline','PlotStyle','compact','Colors','k');
title('PTAX return mean per MONTH')
hold
%h=plot(1:nMonth,MONTH_mean,'kd');
h=plot(idx,yidx,'k*');
set(h,'MarkerFaceColor',[1 1 1],'MarkerSize',10);

%% Set position and axis
hf = gcf;
set(hf,'Position',[70 285 1170 380]);
ha = gca;
set(ha,'Position',[0.05 0.20 0.90 0.70]);