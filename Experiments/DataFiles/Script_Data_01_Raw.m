%% Script: Data Preprocessing (Raw data)
%
% Autor: Elia Matsumoto
%
% Contato: elia.matsumoto@gmail.com
%
% Data: 2020
%
%% Reseting environment
%
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window
%
% Files Info
Holidays_xlsx  = 'RawData\ANBIMA_based.xlsx';
Holidays_sheet = 'Plan1';
Holidays_range = 'A2:A312';  % 2000 ~ 2023
Holidays_mat   = 'RawData\BrazilianHoliday.mat';
Ipeadata_xlsx  = 'RawData\ipeadata_USD.xlsx';
Ipeadata_sheet = 'Séries';
Ipeadata_range = 'A2:C12966';
Ipeadata_file  = 'RawData\Ipea_BRLUSD';

%% Delete previous files
delete('Models\*.mat');
delete('Outcomes\*.mat');
delete('RawData\Data_Full.mat');
delete('WorkingData\*.mat');

%% Initial Date
% 1st of the month SET MANUALLY (****)
InitialDate    = datenum('05/jun/2005','dd/mm/yyyy'); 

%% Brazilian Holidays
[~,RawDates] = xlsread(Holidays_xlsx,Holidays_sheet,Holidays_range);
BR_Holidays = datenum(RawDates,'dd/mm/yyyy'); % Numeric dates
save(Holidays_mat,'BR_Holidays');             % Save

%% Currency: USD / BRL
[RawValues,RawDates] = xlsread(Ipeadata_xlsx,Ipeadata_sheet,Ipeadata_range);
RawNumDates = datenum(RawDates,'dd/mm/yyyy'); % Numeric dates
idx         = find(InitialDate == RawNumDates);
RawNumDates = RawNumDates(idx:end);
RawValues   = RawValues(idx:end,:);

%% Delete ALL non working days
idx = find(~isnan(RawValues(:,1)));
if isempty(idx)
    All_Dates  = RawNumDates;
    All_Values = RawValues;
else
    All_Dates  = RawNumDates(idx);
    All_Values = RawValues(idx,1);
end 

%% "Zero return" replaced by linear interpolation
aux  = All_Values;
daux = diff(aux); % Return (diff)
idx = find(abs(daux)<eps);
if ~isempty(idx)
    nidx = length(idx);
    for i=1:nidx
        ind = idx(i);
        aux(ind) = 0.5*(aux(ind-1)+aux(ind+1));
    end
end
All_Values = aux;

%% Save data
save(Ipeadata_file,'All_Dates','All_Values');
