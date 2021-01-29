%% Script: Metric per tag
%
% Author: Elia Matsumoto
%
% Contact: elia.matsumoto@fgv.br
%
% Data: 2020
%
%% Reseting environment
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window
%
%% Input XLS
XlsFile  = '..\Experiments\DataFiles\Xlsx\Outcomes_TAG.xlsx';
XlsRange = 'A3:A24';

%% Data
MODELS = {
    'RND'      ...    % Random Sort
    'KNN'      ...    % K-Nearest Neighbors
    'LOGREG'   ...    % Logistic Regression
    'MLP'      ...    % MLP Neural Network
    'RF'       ...    % Random Forest
    'SVM'      ...    % Support Vector Machines
    'Voting'   ...    % Voting
    'BMT_ACC'  ...    % BMT
    };
TT_MODELS = {
    'RND'      ...    % Random Sort
    'KNN'      ...    % K-Nearest Neighbors
    'LOGREG'   ...    % Logistic Regression
    'MLP'      ...    % MLP Neural Network
    'RF'       ...    % Random Forest
    'SVM'      ...    % Support Vector Machines
    'Voting'   ...    % Voting
    'BMT'  ...    % BMT
    };
nMODELS = length(MODELS);
TAGS = -10:1:11;
nTag = length(TAGS);
lTAG = { ...
    'L-10' 'L-9' 'L-8' 'L-7' 'L-6' 'L-5' 'L-4' 'L-3' 'L-2' 'L-1' 'LAST' ...
    'FIRST' 'F+1' 'F+2' 'F+3' 'F+4' 'F+5' 'F+6' 'F+7' 'F+8' 'F+9' 'F+10' };
VALUES  = zeros(nTag,nMODELS);

%% Reading values
for i = 1:nMODELS
    VALUES(:,i) = xlsread(XlsFile,MODELS{i},XlsRange);
end

VALUES = VALUES - 0.5;

%% Fig 7
for i = 1:8
    subplot(4,2,i);
    hp = bar(1:nTag,VALUES(:,i),0.3,'k');
    hold
    plot([0 nTag+1],[0.5 0.5],'--k');
    ylabel('Accuracy');
    grid on
    ht = title(TT_MODELS{i});
    ht.FontSize = 14;
    ha = gca;
    ylim = [-0.15 0.25];
    ha.XLim        = [0 nTag+1];
    ha.YLim        = ylim;
    ha.YTickLabels = { '0.4' '0.5' '0.6' '0.7'};
    if i > 6
        ha.XTick              = 1:nTag;
        ha.XTickLabel         = lTAG;
        ha.XTickLabelRotation = 90;
    else
        ha.XTick              = 1:nTag;
        ha.XTickLabel         = '';
    end
    ha.FontSize = 10;
end

%% Create textbox
hf = gcf;
annotation(hf,'textbox',...
    [0.48 0.95 0.06 0.04],...
    'String','Accuracy',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');

%% Save figure
hf.Position = [250 10 1100 1200];
exportgraphics(hf,'Fig_07.jpg','Resolution',300);
