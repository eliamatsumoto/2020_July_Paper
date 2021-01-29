%% Script
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
%
MODELS_TRAIN = [1 2 3 4 5 6];
MODELS_EXP   = [1 2 3 4 5 6];

PAST       = 12;     % 12 months
BASE       = PAST+1; % 'From now on'

ALPHA      = 0.05;

%
MODELS_NAME  = { ...
    'RND'    ...    % Random Sort
    'KNN'    ...    % K-Nearest Neighbors
    'LOGREG' ...    % Logistic Regression    
    'MLP'    ...    % MLP Neural Network
    'RF'     ...    % Random Forest        
    'SVM'    ...    % Support Vector Machines
    };
nMODELS = numel(MODELS_NAME);
%
%% TAGGED day shifts information
%
TAGS = -10:1:11;
nTAG = length(TAGS);
sTAG = { ...
    'L-10' 'L-9' 'L-8' 'L-7' 'L-6' 'L-5' 'L-4' 'L-3' 'L-2' 'L-1' 'LAST' ...
    'FIRST' 'F+1' 'F+2' 'F+3' 'F+4' 'F+5' 'F+6' 'F+7' 'F+8' 'F+9' 'F+10' };

METRICS_NAME = {'ACC' 'PRE' 'SEN' 'SPC' 'EARN'};
nMETRICS     = length(METRICS_NAME);
MET_TAB      = [5 1 2 4 3];

NSWD = 1500;
