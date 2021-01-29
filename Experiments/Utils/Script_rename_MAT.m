%% Reseting environment
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window

%% Initialization
SHIFT  = -9:1:11;
nSHIFT = length(SHIFT);
lSHIFT    = { ...
    'L-9' 'L-8' 'L-7' 'L-6' 'L-5' 'L-4' 'L-3' 'L-2' 'L-1' 'LAST' ...
    'FIRST' 'F+1' 'F+2' 'F+3' 'F+4' 'F+5' 'F+6' 'F+7' 'F+8' 'F+9' 'F+10' };
OrgDir = 'L-10';

lSETS  = { ...
    '2018_12' ...
    '2019_01' ...
    '2019_02' ...
    '2019_03' ...
    '2019_04' ...
    '2019_05' ...
    '2019_06' ...
    '2019_07' ...
    '2019_08' ...
    '2019_09' ...
    '2019_10' ...
    };

nSETS  = length(lSETS);

%% Initialization
Old_Str = 'BENCH';
New_Str = 'BEFORE';

%% For all sets
for i = 1:nSETS
    %% Path
    MATPath = ['DataFiles_' lSETS{i} '\Models\'];
    %% Files name
    files_name = dir([MATPath '*.mat']);
    nfiles = length(files_name);
    %% Rename
    cd(MATPath);
    for j=1:nfiles
        Old_name = files_name(j).name;
        New_name = strrep(Old_name,Old_Str,New_Str);
        if ~strcmp(Old_name,New_name)
            dos(['rename ' Old_name ' ' New_name]);
            disp(New_name);
        end
    end
    cd('..\..\');
end