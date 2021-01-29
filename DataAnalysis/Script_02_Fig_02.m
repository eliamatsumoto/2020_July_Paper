%% Script: HISTOGRAM
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

%% Reading Ipeadata
DataFile   = '..\Experiments\DataFiles\RawData\Data_Full.mat';
load(DataFile);

%% RET
RetOrg    = RET_Full;
RetPurged = RET_Full;
id        = find(isnan(Y_Full));
RetPurged(id) = [];
skOrg    = skewness(RetOrg);
skPurged = skewness(RetPurged);

%% Exibição dos dados: Histogramas
hf = figure;

subplot(1,2,1)
hh = histogram(RetOrg);
hh.FaceColor = [0.3 0.3 0.3];
ha   = gca;
xlim = ha.XLim;
ylim = ha.YLim;

grid on
ht = title(['Original dataset skewness: ' num2str(skOrg,'%2.4f')]);
ht.FontSize = 14;
ht = xlabel('BRL/USD variation');
ht.FontSize = 14;
set(ht,'FontSize',14);

subplot(1,2,2)
hh =histogram(RetPurged);
hh.FaceColor = [0.3 0.3 0.3];
ha = gca;
% ha.XLim = xlim;
ha.YLim = ylim;
grid on
ht = title(['Purged dataset skewness: ' num2str(skPurged,'%2.4f')]);
ht.FontSize = 14;
ht = xlabel('BRL/USD variation');
ht.FontSize = 14;

% Set position
set(hf,'Position',[35 100 1350 500]);

%% Save figure
exportgraphics(gcf,'Fig_02.jpg','Resolution',300);

%% XLS write
XLSTable2 = 'Table2.xlsx';
FTable2   = 'Dates';
RTable2   = 'F9:G9';
xlswrite(XLSTable2,[skOrg skPurged],FTable2,RTable2);