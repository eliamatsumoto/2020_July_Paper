%% Script
%
% MODELS COMBINING
%
% Autor: Elia Matsumoto
%
% Data: 2020

%% Reseting environment
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window

%% Initialization
%
Script_Main_Settings

Primary = { 'ACC' 'PRE' 'SEN' 'SPC' 'EARN' };

%% XLSFile

XLSFile   = 'DataFiles\Xlsx\Tables_Sliding_Windows.xlsx';

FTable7   = 'Table7';
RTable7   = 'B2:C7';

FTable8  = 'Table8';
RTable8a = 'B2:B13';
RTable8b = 'C2:G13';
RTable8c = 'C1:G1';

FTable8a  = 'Table8a';
RTable8aa = 'B2:B13';
RTable8ab = 'C2:G13';
RTable8ac = 'C1:G1';

FTable10  = 'Table10';
RTable10a = 'A2:A13';
RTable10b = 'B2:B13';
RTable10c = 'C2:E13';
RTable10d = 'F2:F13';

%% Labels
MLabels = { ...
    'RND (*)' ; ...
    'KNN' ; ...
    'LOGREG' ; ...
    'MLP' ; ...
    'RF' ; ...
    'SVM' ; ...
    'VOTING' ; ...
    ['BMT_' Primary{1}] ; ...
    ['BMT_' Primary{2}] ; ...
    ['BMT_' Primary{3}] ; ...
    ['BMT_' Primary{4}] ; ...
    ['BMT_' Primary{5}] ; ...
    };

%% Outcomes Files
InPath ='DataFiles\Outcomes\';
FileNames = { ...
    'Experiment_RND.mat' ; ...
    'Experiment_KNN.mat' ; ...
    'Experiment_LOGREG.mat' ; ...
    'Experiment_MLP.mat' ; ...
    'Experiment_RF.mat' ; ...
    'Experiment_SVM.mat' ; ...
    'Experiment_Voting.mat' ; ...    
    ['Experiment_BMT_' Primary{1} '.mat'] ; ...
    ['Experiment_BMT_' Primary{2} '.mat'] ; ...
    ['Experiment_BMT_' Primary{3} '.mat'] ; ...
    ['Experiment_BMT_' Primary{4} '.mat'] ; ...
    ['Experiment_BMT_' Primary{5} '.mat'] ; ...
    };
ALPHA  = 0.05;

%% YH = Models predictions
InFile = [InPath FileNames{1}];
MD     = load(InFile);
nOBS   = length(MD.Y_TES);
nMM    = length(MLabels);
YH     = zeros(nOBS,nMM);
for i = 1:nMM
    InFile = [InPath FileNames{i}];
    MD     = load(InFile);
    YH(:,i) = sign(mean(MD.YH,2));
end

%% Info
BASE = MD.WD_IDX(13,1);
YTES = MD.Y_TES(BASE:end);
RET  = MD.RET_TES(BASE:end);
YH   = YH(BASE:end,:);
DATES = MD.DAT_TES(BASE:end);

%% Window size
nTES     = length(YTES);
nEM      = NSWD;
nW       = nTES - nEM + 1;
SW_Dates = zeros(nEM,2);
METR     = cell(nEM,nMM);

%% For each window
for i = 1:nEM
    p1 = i;
    p2 = p1 + nW - 1;
    SW_Dates(i,1) = DATES(p1);
    SW_Dates(i,2) = DATES(p2);
    y             = YTES(p1:p2);
    ret           = RET(p1:p2);
    %% For each of the model
    for j = 1:nMM
        yh        = YH(p1:p2,j);
        met       = util_cls_metrics(y,yh,ret);
        METR{i,j} = met;
    end
end

%% Table 7
disp('TABLE 7');
ID   = [1 2 3 (nEM-2) (nEM-1) nEM];
nID  = length(ID);
TAB7 = cell(nID,2);
for i = 1:nID
    j = ID(i);
    TAB7(i,:) = { ...
        datestr(SW_Dates(j,1),'mmm.dd.yyyy') ...
        datestr(SW_Dates(j,2),'mmm.dd.yyyy') };
end
xlswrite(XLSFile,TAB7,FTable7,RTable7);

%% TABLE 8 and TABLE 8a
disp('TABLE 8 and TABLE 8a');
TAB8 = zeros(nMM,nMETRICS+1);
TAB9 = zeros(nMM,nMETRICS);
for i = 1:nMM
    met = zeros(nEM,nMETRICS);
    %% for each of the Windows
    for j = 1:nEM
        met(j,:)   = METR{j,i};
    end
    TAB8(i,1:nMETRICS) = mean(met);
    TAB8(i,end) = abs(std(met(:,end))/mean(met(:,end)));
    
    %% for each of the metrics
    if i == 1
        bench_all = met;
    else
        for j = 1:nMETRICS
            TAB9(i,j) = util_htest(met(:,j),bench_all(:,j),ALPHA);
        end
    end
end
[~,ORD] = sort(TAB8(:,nMETRICS),'descend');
TAB8S = TAB8(ORD,:);
TAB8aS = util_H0_2_H0str(TAB9(ORD,:),TAB8S(:,MET_TAB));
MLabS = MLabels(ORD);
xlswrite(XLSFile,MLabS,FTable8,RTable8a);
xlswrite(XLSFile,TAB8S(:,MET_TAB),FTable8,RTable8b);
xlswrite(XLSFile,METRICS_NAME(MET_TAB),FTable8,RTable8c);
xlswrite(XLSFile,MLabS,FTable8a,RTable8aa);
xlswrite(XLSFile,TAB8aS,FTable8a,RTable8ab);
xlswrite(XLSFile,METRICS_NAME(MET_TAB),FTable8a,RTable8ac);

%% TABLE 10
disp('TABLE 10');
H0_Txt   = {'equal to the next' 'greater than the next'};
TAB10a   = ones(nMM,1);
TAB10b   = MLabS;
TAB10c   = zeros(nMM,3);
TAB10d   = cell(nMM,1);

% First model
earn_current = zeros(nEM,1);
for i = 1:nEM
    earn_current(i) = METR{i,ORD(1)}(end);
end
TAB10c(1,:) = [ mean(earn_current) ...
                std(earn_current)  ...
                abs(std(earn_current)/mean(earn_current)) ];
% Next models
for i = 2:nMM
    % Next model
    earn_next = zeros(nEM,1);
    %% for each of the Windows
    for j = 1:nEM
        earn_next(j) = METR{j,ORD(i)}(end);
    end
    TAB10c(i,:) = [ mean(earn_next) ...
                    std(earn_next)  ...
                    abs(std(earn_next)/mean(earn_next)) ];
    h0 = util_htest(earn_current,earn_next,ALPHA);
    if h0
        TAB10a(i:end) = TAB10a(i-1)+1;
        TAB10d{i-1}   = H0_Txt{2};
    else
        TAB10d{i-1} = H0_Txt{1};
    end
    earn_current = earn_next;
end
xlswrite(XLSFile,TAB10a,FTable10,RTable10a);
xlswrite(XLSFile,TAB10b,FTable10,RTable10b);
xlswrite(XLSFile,TAB10c,FTable10,RTable10c);
xlswrite(XLSFile,TAB10d,FTable10,RTable10d);

%% Save Sliding Windows Info

% ACC
dticks  = [1 630 829 1042 NSWD];
nd      = length(dticks);
dlabels = cell(nd,2);
for i = 1:nd
    dlabels{i,1} = [ datestr(SW_Dates(dticks(i),2),'dd/mmm/yy') ...
                     ['(' num2str(dticks(i)) ')'] ];
    dlabels{i,2} = datestr(SW_Dates(dticks(i),1),'dd/mmm/yy');
end
AxInfo = {dticks dlabels};

% EARN
dticks  = [1 630 829 1042 1421 NSWD];
nd      = length(dticks);
dlabels = cell(nd,2);
for i = 1:nd
    dlabels{i,1} = [ datestr(SW_Dates(dticks(i),2),'dd/mmm/yy') ...
        ['(' num2str(dticks(i)) ')'] ];
    dlabels{i,2} = datestr(SW_Dates(dticks(i),1),'dd/mmm/yy');
end
AxInfo{5,1} = dticks;
AxInfo{5,2} = dlabels;

save([InPath 'Sliding_Windows.mat'],'METR','NSWD','AxInfo');
