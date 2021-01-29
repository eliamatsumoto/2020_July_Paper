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

% Dado numerico: Cambio
Cambio = All_Values;
Datas1 = {'Feb 1^{st},2001'; ...
          'Jan 31^{st},2020' };
Datas2 = {'Feb 2^{nd},2001'; ...
          'Jan 31^{st},2020' };
      
%% Exibição dos dados: Valor do Câmbio
hf= figure; 
subplot(2,1,1)
nX = length(Cambio);
plot(1:nX,Cambio,'k');
ht = title('BRL/USD Value');
set(ht,'FontSize',14);
% Label vertical
ht=ylabel('R$');
set(ht,'FontSize',12);
% Prepara Eixo X
nX      = length(Cambio);
XTLabel = Datas1;
XT      = [1 nX];
XL      = [(XT(1)-1) (XT(2)+1)];
ha = gca;
set(ha,'XLim',XL,'XTick',XT,'XTickLabel',XTLabel, ...
       'XTickLabelRotation',45, ...
       'FontSize', 12,...
       'Position',[0.07 0.60 0.90 0.30]);
% Label horizontal
ht=xlabel(['Total of observations: ' num2str(nX) ' working days']);
set(ht,'FontSize',12,'Position',[2400 0.5]);

%% Exibição dos dados: Variacao do Câmbio
subplot(2,1,2)
taxa = diff(Cambio);
nX   = length(taxa);
plot(1:nX,taxa,'k');
ht = title('BRL/USD Variation');
set(ht,'FontSize',14);
% Label vertical
ht=ylabel('R$');
set(ht,'FontSize',12);
% Prepara Eixo X
nX      = length(taxa);
XTLabel = Datas2;
XT      = [1 nX];
XL      = [(XT(1)-1) (XT(2)+1)];
ha = gca;
set(ha,'XLim',XL,'XTick',XT,'XTickLabel',XTLabel, ...
       'XTickLabelRotation',45, ...
       'FontSize', 12,...
       'Position',[0.07 0.15 0.90 0.30]);
% Label horizontal
ht=xlabel(['Total of observations: ' num2str(nX) ' working days']);
set(ht,'FontSize',12,'Position',[2400 -0.5]);

% Set position
set(hf,'Position',[35 100 1320 600]);