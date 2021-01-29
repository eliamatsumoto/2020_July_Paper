%% Script
%
% RET PER TAG
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

TAG  = -10:1:11;
nTag = length(TAG);
lTAG = { ...
    'L-10' 'L-9' 'L-8' 'L-7' 'L-6' 'L-5' 'L-4' 'L-3' 'L-2' 'L-1' 'LAST' ...
    'FIRST' 'F+1' 'F+2' 'F+3' 'F+4' 'F+5' 'F+6' 'F+7' 'F+8' 'F+9' 'F+10' };


%% Reading all DATA
DataFile = '..\Experiments\DataFiles\RawData\Data_Full.mat';
load(DataFile);

%% For each TAG
nOBS = 189;
PTag = zeros(nOBS,nTag);
for i = 1:nTag
    idx  = find(TAG_Full(:,i));
    aux  = RET_Full(idx);
    PTag(:,i) = aux(1:nOBS);
end

%% Mean
TAG_mean = mean(PTag);
figure;
hp = plot(1:nTag,TAG_mean,'k:o');
set(hp,'MarkerSize',10);
ha = gca;
ylim = [min(TAG_mean)*2 max(TAG_mean)*2];
set(ha,'XLim',[1 nTag],'YLim',ylim);
set(ha,'XTick',1:nTag,'XTickLabel',lTAG,'XTickLabelRotation',90);
ht = title('BRL/USD Variation average per tag');
set(ht,'FontSize',14);
% Set position and axis
hf = gcf;
set(hf,'Position',[70 285 1170 380]);
ha = gca;
set(ha,'Position',[0.05 0.20 0.90 0.70]);

%% Box plot
anova1(PTag,lTAG);
hold

%% Ttest2
WPTag = [PTag PTag(:,1)];
H0      = zeros(nTag,1);
ALPHA   = 0.03;
for i=1:nTag
    H0(i) = ttest2(WPTag(:,i),WPTag(:,i+1),'alpha',ALPHA);
end
disp(H0);
idx  = find(H0);
nidx = length(idx);
yidx = -0.27*ones(nidx,1);
plot(idx,yidx,'k*');

figure
boxplot(PTag,lTAG,'LabelOrientation' ,'inline','PlotStyle','compact','Colors','k');
title('PTAX return mean per TAG')
hold
%h=plot(1:nTag,TAG_mean,'kd');
h=plot(idx,yidx,'k*');
set(h,'MarkerFaceColor',[1 1 1],'MarkerSize',10);

%% Set position and axis
hf = gcf;
set(hf,'Position',[70 285 1170 380]);
ha = gca;
set(ha,'Position',[0.05 0.20 0.90 0.70]);