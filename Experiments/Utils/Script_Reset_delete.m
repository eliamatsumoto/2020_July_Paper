%% Reseting environment
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window

%% Initialization
SHIFT  = -10:1:11;
nSHIFT = length(SHIFT);

%% Tag
Tag = 'L';

%% FOR EACH SHIFT
for s = 1:nSHIFT
    
    %% Shift ID
    SH    = SHIFT(s);
    strSH = num2str(SH);
    
    %% Del all *.*
    dirSH = [Tag strSH];
    delete([dirSH '\*.*']);
    
end
