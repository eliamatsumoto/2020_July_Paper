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
%% Output file
XLSFile = 'TABLECD.xlsx';
FMonth  = 'Month';
RMonth  = 'B2:H13';
FTag    = 'Tag';
RTag    = 'B2:H23';

%% Initialization

TAG  = -10:1:11;
nTAG = length(TAG);
lTAG = { ...
    'L-10' 'L-9' 'L-8' 'L-7' 'L-6' 'L-5' 'L-4' 'L-3' 'L-2' 'L-1' 'LAST' ...
    'FIRST' 'F+1' 'F+2' 'F+3' 'F+4' 'F+5' 'F+6' 'F+7' 'F+8' 'F+9' 'F+10' };

MONTH  = 1:12;
nMONTH = length(MONTH);
lMONTH = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' };

%% Reading all DATA
DataFile = '..\Experiments\DataFiles\RawData\Data_Full.mat';
load(DataFile);

%% For each MONTH
YI = year(DATE_Full(1));
YF = year(DATE_Full(end));
YEAR  = YI:YF;
nYEAR = length(YEAR);
NMonth = zeros(nYEAR,nMONTH);
PMonth = zeros(nYEAR,nMONTH);
YEAR_Full  = year(DATE_Full);
MONTH_Full = month(DATE_Full);
% Proportion
for i = 1:nYEAR
    for j = 1:nMONTH
        idx = find(YEAR_Full == YEAR(i) & MONTH_Full==j);
        if ~isempty(idx)
            S           = sign(RET_Full(idx));
            idP         = find(S>0);
            NMonth(i,j)   = length(S);
            PMonth(i,j) = length(idP)/NMonth(i,j);
        end
    end    
end
% Filling "zeros" with NaN
idz = find(abs(PMonth)<eps);
PMonth(idz) = NaN;  
NMonth(idz) = NaN;

% Filling "One" with average
id1 = find(PMonth==1);
idx = find(PMonth~=1);
PMonth(id1) = nanmean(PMonth(idx));  

% ANOVA1
[p,tbl,~] = anova1(PMonth,[],'off');
disp(p);
disp(tbl);

% Box Plot
boxplot(PMonth,'Plotstyle','compact','colors','k');
ha = gca;
ha.YLabel.String = 'Proportion';
ha.XLim   = [0 nMONTH+1];
ha.YLim   = [0.05 0.95];
ha.XTick  = 1:nMONTH;
ha.XTickLabel = lMONTH;
ha.XTickLabelRotation = 45;
ha.FontSize = 12;
ht = title('BRL/USD: Proportion of POSITIVE signs per MONTH');
ht.FontSize = 14;

% Set FIGURE
hf = gcf;
set(hf,'Position',[50 50 1170 590]);
% Save figure
exportgraphics(hf,'Fig_05.jpg','Resolution',300);

%% For each TAG
NTag = zeros(nYEAR,nTAG);
PTag = zeros(nYEAR,nTAG);
% Proportion
for i = 1:nYEAR
    for j = 1:nTAG
        idx = find(YEAR_Full == YEAR(i) & TAG_Full(:,j));
        if ~isempty(idx)
            S         = sign(RET_Full(idx));
            idP       = find(S>0);
            NTag(i,j) = length(S);
            PTag(i,j) = length(idP)/NTag(i,j);
        end
    end    
end
% Filling "zeros" with NaN
idz = find(abs(PTag)<eps);
PTag(idz) = NaN;  
NTag(idz) = NaN;

% Filling "One" with average
id1 = find(PTag==1);
idx = find(PTag~=1);
PTag(id1) = nanmean(PTag(idx));  

% ANOVA1
[p,tbl,~] = anova1(PTag,[],'off');
disp(p);
disp(tbl);

% Box Plot
boxplot(PTag,'Plotstyle','compact','colors','k');
ha = gca;
ha.YLabel.String = 'Proportion';
ha.XLim   = [0 nTAG+1];
ha.YLim   = [0.05 0.95];
ha.XTick  = 1:nTAG;
ha.XTickLabel = lTAG;
ha.XTickLabelRotation = 45;
ha.FontSize = 12;
ht = title('BRL/USD: Proportion of POSITIVE signs per TAG');
ht.FontSize = 14;

% Set FIGURE
hf = gcf;
set(hf,'Position',[50 50 1170 590]);
% Save figure
exportgraphics(hf,'Fig_06.jpg','Resolution',300);

%% Table
Per_Month = [ fix(mean(sum(NMonth,'omitnan'))); ...
              nanmean(PMonth(:)); ...
              nanstd(PMonth(:)) ; ...
              nanmin(PMonth(:)) ; ...
              nanmax(PMonth(:)) ; ...
              nanmedian(PMonth(:)) ; ...
              nanstd(PMonth(:))/nanmean(PMonth(:))];
Per_Tag   = [ fix(mean(sum(NTag,'omitnan'))); ...
              nanmean(PTag(:)); ...
              nanstd(PTag(:)) ; ...
              nanmin(PTag(:)) ; ...
              nanmax(PTag(:)) ; ...
              nanmedian(PTag(:)) ; ...
              nanstd(PTag(:))/nanmean(PTag(:))];
Tab_Stat = table(Per_Month,Per_Tag);
disp(Tab_Stat);
xlswrite(XLSFile,[Per_Month Per_Tag]);
