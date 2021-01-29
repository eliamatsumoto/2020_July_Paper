%% Script
%
% POSITIVE PROPORTION PER MONTH / PER TAG
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

MONTH  = 1:12;
nMonth = length(MONTH);
lMONTH = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' };

%% Reading all DATA
DataFile = '..\Experiments\DataFiles\RawData\Data_Full.mat';
load(DataFile);

%% For each MONTH
MONTH_Full = month(DATE_Full);
PMonth = zeros(1,nMonth);
NMonth = zeros(1,nMonth);
for i = 1:nMonth
    idx  = find(MONTH_Full==i);
    S    = sign(RET_Full(idx));
    idP  = find(S>0);
    NMonth(i) = length(S);
    PMonth(i) = length(idP)/NMonth(i);
end
Mean_Month = mean(PMonth);
Std_Month  = std(PMonth);
% Plot
figure;
subplot(2,1,1)
hp = plot(1:nMonth,PMonth,'k:o', ...
    [1 nMonth],[Mean_Month Mean_Month],'k', ...
    [1 nMonth],[Mean_Month-Std_Month Mean_Month-Std_Month],'k--', ...
    [1 nMonth],[Mean_Month+Std_Month Mean_Month+Std_Month],'k--' ...
    );
ylabel('Proportion');
grid on
set(hp,'MarkerSize',10);
ht = legend('Prop','Mean','Std');
ht.Location = 'best';
ha = gca;
ylim = [0.4 0.6];
set(ha,'XLim',[1 nMonth],'YLim',ylim);
set(ha,'XTick',1:nMonth,'XTickLabel',lMONTH,'XTickLabelRotation',90, ...
    'FontSize',12);
set(ha,'Position',[0.07 0.60 0.90 0.35]);
ht = title('BRL/USD: Proportion of POSITIVE signs per MONTH');
set(ht,'FontSize',14);

%% For each TAG
PTag = zeros(1,nTag);
NTag = zeros(1,nTag);
for i = 1:nTag
    idx  = find(TAG_Full(:,i));
    S    = sign(RET_Full(idx));
    idP  = find(S>0);
    NTag(i) = length(S);
    PTag(i) = length(idP)/NTag(i);
end
Mean_Tag = mean(PTag);
Std_Tag  = std(PTag);

%% Plot
subplot(2,1,2);
hp = plot(1:nTag,PTag,'k:o', ...
    [1 nTag],[Mean_Tag Mean_Tag],'k', ...
    [1 nTag],[Mean_Tag-Std_Tag Mean_Tag-Std_Tag],'k--', ...
    [1 nTag],[Mean_Tag+Std_Tag Mean_Tag+Std_Tag],'k--' ...
    );    
ylabel('Proportion');
grid on
set(hp,'MarkerSize',10);
ht = legend('Prop','Mean','Std');
ht.Location = 'best';
ha = gca;
ylim = [0.4 0.6];
set(ha,'XLim',[1 nTag],'YLim',ylim);
set(ha,'XTick',1:nTag,'XTickLabel',lTAG,'XTickLabelRotation',90, ...
    'FontSize',12);
set(ha,'Position',[0.07 0.10 0.90 0.35]);
ht = title('BRL/USD: Proportion of POSITIVE signs per TAG');
set(ht,'FontSize',14);

% Set FIGURE
hf = gcf;
set(hf,'Position',[50 50 1170 590]);
% Save figure
exportgraphics(hf,'Fig_03.jpg','Resolution',300);

%% Table
Per_Month = [ fix(mean(NMonth)); ...
              mean(PMonth); ...
              std(PMonth) ; ...
              min(PMonth) ; ...
              max(PMonth) ; ...
              median(PMonth) ; ...
              std(PMonth)/mean(PMonth)];
Per_Tag   = [ fix(mean(NTag)); ...
              mean(PTag); ...
              std(PTag) ; ...
              min(PTag) ; ...
              max(PTag) ; ...
              median(PTag) ; ...
              std(PTag)/mean(PTag)];
Tab_Stat = table(Per_Month,Per_Tag);
disp(Tab_Stat);
xlswrite('TABLE3.xlsx',[Per_Month Per_Tag]);