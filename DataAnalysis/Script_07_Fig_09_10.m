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

MODEL_IDS = [8 7 6]; % [8 7 1];   % BMT, VOTING, RND
nIDS      = length(MODEL_IDS);

METRIC   = [1 5];

BASELINE = [0.5 0.5 0.5 0.5 0];

%% Input file
InputFile  = '..\Experiments\DataFiles\Outcomes\Sliding_Windows';

%% Data
MODELS = {
    'RND'      ...    % Random Sort
    'KNN'      ...    % K-Nearest Neighbors
    'LOGREG'   ...    % Logistic Regression
    'MLP'      ...    % MLP Neural Network
    'RF'       ...    % Random Forest
    'SVM'      ...    % Support Vector Machines
    'VOTING'   ...
    'BMT_ACC'  ...
    'BMT_PRE'  ...
    'BMT_SEN'  ...
    'BMT_SPC'  ...
    'BMT_EARN' ...
    };

METRIC_LABELS = {'ACC' 'PRE' 'SEN' 'SPC' 'EARN'};

FileFig = {'Fig_09.jpg' '' '' '' 'Fig_10.jpg'};

%% Reading values
load(InputFile);
METV = zeros(NSWD,nIDS);

%% GRAPHS
for G = METRIC
    %% Metric values
    for i = 1:nIDS
        for j = 1:NSWD
            METV(j,i) = METR{j,MODEL_IDS(i)}(G);
        end
    end
    %% Plot
    hf = figure;
    hp = plot(METV);
    hold
    for i = 1:nIDS
        hp(i).Color = [0 0 0];
    end
    hp(1).LineStyle  = '-';
    hp(1).LineWidth  = 1;
    hp(2).LineStyle  = '--';
    hp(2).LineWidth  = 1;
    hp(3).LineStyle = ':';
    hp(3).LineWidth  = 1;
    ht = legend('BMT','VOTING','RND');
    ht.FontSize = 12;
    ht.Location = 'northwest';
    ha = gca;
    if G == 1
        ha.YLim = [0.47 0.57];
    end
    xb = ha.XLim;
    yb = BASELINE(G)*ones(1,2);
    hpb = plot(xb,yb,'k--');
    hpb(1).LineWidth = 1.5;
    ht.String(end) = [];
    
    %% GRIDS
    ha = gca;
    ha.XTick       = AxInfo{G,1};
    ha.XTickLabels = AxInfo{G,2};
    ha.XTickLabelRotation = 30;
    ha.GridAlpha = 0.5;
    grid on
    
    %% Labeling
    xlabel('Daily values','FontSize',12);
    ylabel([METRIC_LABELS{G} ' metric'],'FontSize',12);
    title([num2str(NSWD) ' Sliding Windows Outcome'], 'FontSize', 14);
    if G == 5
            rect = [0.904 0.194 0.045 0.745];
            annotation(hf,'rectangle',rect, ...
                'Color',[0.5 0.5 0.5],...
                'FaceColor',[0.8 0.8 0.8],...
                'FaceAlpha',0.3);            
    end
    
    %% Figure and Axes Positions
    hf.Position = [120 120 1200 520];
    ha.Position = [0.07 0.19 0.88 0.75];
    
    %% Save figure
    exportgraphics(gcf,FileFig{G},'Resolution',300);
end

%% Comparing "gray" 
% IndG = AxInfo{5,1}(4);
% metv = METV(IndG:end,:);
% [p,tbl,stats] = anova1(metv);
% c = multcompare(stats)
