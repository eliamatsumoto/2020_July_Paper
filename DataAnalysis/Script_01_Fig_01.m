%% Script: Plot CURRENCY VALUES
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
DataFile = '..\Experiments\DataFiles\RawData\Ipea_BRLUSD.mat';
load(DataFile);

%% Working datasets: FIRST and LAST
WDdir = '..\Experiments\DataFiles\WorkingData\';
Fdir  = dir([WDdir '*.mat']);
FWD   = load([WDdir Fdir(1).name]);
LWD   = load([WDdir Fdir(end).name]);
FDate = FWD.DATE_Tra(1);
LDate = LWD.DATE_Tes(end);
F_ID   = find(All_Dates == FDate);
L_ID   = find(All_Dates == LDate);

%% Create actual DATA_Full
All_Dates  = All_Dates(F_ID:L_ID);
All_Values = All_Values(F_ID:L_ID);
save('DA_Data_Full','All_Dates','All_Values');

%% Dado numerico: Cambio
Cambio = All_Values;
nC   = length(Cambio);
DIni = datestr(FDate,'dd-mmm-yyyy');
DFin = datestr(LDate,'dd-mmm-yyyy');
      
%% Exibição dos dados: Valor do Câmbio
hf= figure; 
subplot(2,1,1)
plot(1:nC,Cambio,'k');
ha = gca;
ha.XLim = [0 nC+1];
ht = title(['BRL/USD Value from ' ...
    DIni ' to ' DFin ...
    ' (' num2str(nC) ' observations)']);
ht.FontSize = 14;
% Label vertical
ht=ylabel('R$');
set(ht,'FontSize',12);
grid on

%% Exibição dos dados: Variacao do Câmbio
subplot(2,1,2)
Taxa = diff(Cambio);
nT   = length(Taxa);
plot(1:nT,Taxa,'k');
ha = gca;
ha.XLim = [0 nC];
ht = title('BRL/USD Variation');
ht.FontSize = 14;
% Label vertical
ht=ylabel('R$');
set(ht,'FontSize',12);
% Prepara Eixo X
ht=xlabel('Observations');
ht.FontSize = 12;
grid on

% Set position
set(hf,'Position',[35 100 1320 600]);

%% Save figure
exportgraphics(gcf,'Fig_01.jpg','Resolution',300);
