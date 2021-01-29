%% Script: Preparing Data
%
% TAG    : LAST WORKING DAY OF THE MONTH (Shift: -10:1:10)
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

%% Initialization
%
SHIFT     = -10:1:11;
nSHIFT    = length(SHIFT);
ObsWindow = 10;

%% Files Info
Holidays_mat  = 'RawData\BrazilianHoliday.mat';
Ipeadata_file = 'RawData\Ipea_BRLUSD';
TABLE2_file   = '..\..\DataAnalysis\TABLE2.xlsx';

%% Reading data
load(Holidays_mat); % Brazilian Holidays

%% Load IPEA data
load(Ipeadata_file); % Currency: USD / BRL

%% Foreign exchange rate: Full dataset
fx_all_ret    = diff(All_Values);         % Returns
fx_all_logret = diff(log(All_Values));    % log Returns
fx_all_signal = sign(fx_all_ret);         % Signal (-1,1)
fx_all_date   = All_Dates(2:end);         % Adjusting dates
fx_all_n      = length(fx_all_date) - ObsWindow;

%% Mark OUTLIERS (5*sigma)
Threshold = 5*std(fx_all_ret);
idx_out    = find(abs(fx_all_ret)>=Threshold);
ret_org    = fx_all_ret;
ret_purged = fx_all_ret;
if ~isempty(idx_out)
    fx_all_logret(idx_out) = NaN;
    fx_all_signal(idx_out) = NaN;
    ret_purged(idx_out)    = [];
    nidx = length(idx_out);
    dout = cell(nidx,1);
    for i = 1:nidx
        k = idx_out(i);
        dout{i} = datestr(fx_all_date(k),'dd-mm-yyyy');
    end
    
    %% Write 
    outlier_info = [mean(fx_all_ret(idx_out)); std(fx_all_ret(idx_out))];
    xlswrite(TABLE2_file,outlier_info,'Dates','B1:B2');
    lrange = num2str(nidx+4);
    xlswrite(TABLE2_file,dout,'Dates',['A5:A' lrange]);
    xlswrite(TABLE2_file,fx_all_ret(idx_out),'Dates',['B5:B' lrange]);   
    nfull     = length(fx_all_ret);
    info = [ ...
        nfull           (nfull - nidx)   ; ...
        mean(ret_org)   mean(ret_purged) ; ...
        std(ret_org)    std(ret_purged) ; ...
        min(ret_org)    min(ret_purged) ; ...
        max(ret_org)    max(ret_purged) ; ...
        median(ret_org) median(ret_purged) ];
    xlswrite(TABLE2_file,info,'F2:G7');
end

%% TAG ALL SHIFTS
TAG_Full   = zeros(fx_all_n,nSHIFT);
for S = 1:nSHIFT
    %% ShifT
    SH    = SHIFT(S);
    %% TAG: LAST WORKING DAY OF THE MONTH (SHIFT)
    aux_date   = util_LAST_wdm(fx_all_date,BR_Holidays,SH); % TAGGED dates
%     if SH == 0
%         disp(aux_date);
%     end
    fx_all_tag = ismember(fx_all_date,aux_date);            % TAG (ON/OFF)
    for i = 1:fx_all_n
        TAG_Full(i,S) = fx_all_tag(i + ObsWindow);
    end
end
FIRST_Full = TAG_Full(:,12);     % First business day of the month
LAST_Full  = TAG_Full(:,11);     % Last business days of the month

%% CONSTRUCT THE VARIABLES
DATE_Full   = zeros(fx_all_n,1);
RET_Full    = zeros(fx_all_n,1);
LOGRET_Full = zeros(fx_all_n,1);
SG_Full     = zeros(fx_all_n,1);
X_Full      = zeros(fx_all_n, ObsWindow);
Y_Full      = zeros(fx_all_n,1);

%% Output DR (Directions): DIRECTION inversion = 1
for i = 1:fx_all_n
    x_init         = i;
    y_pos          = i + ObsWindow;
    x_final        = y_pos - 1;
    DATE_Full(i)   = fx_all_date(y_pos);
    RET_Full(i)    = fx_all_ret(y_pos);
    LOGRET_Full(i) = fx_all_logret(y_pos);
    X_Full(i,:)    = fx_all_logret(x_init:x_final);
    Y_Full(i)      = fx_all_signal(y_pos);
end

%% Saving Full Data
OutputFile = 'RawData\Data_Full.mat';
save(OutputFile,'DATE_Full','FIRST_Full','LAST_Full','TAG_Full', ...
    'LOGRET_Full','RET_Full','X_Full','Y_Full');
