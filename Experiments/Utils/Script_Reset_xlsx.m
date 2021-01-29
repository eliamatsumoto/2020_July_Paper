%% Reseting environment
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window

%% Initialization
SHIFT  = -9:1:11;
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
    
    %% Copy *.xlsx
    dirSource = [Tag '-10\*.xlsx'];
    copyfile(dirSource,dirSH);
    
    %% Rename *.xlsx
    cd(dirSH);
    files_name = dir('*.xlsx');
    nfiles = length(files_name);
    Old_Str = [Tag '-10'];
    New_Str = dirSH;
    %% Rename
    for i=1:nfiles
        Old_name = files_name(i).name;
        New_name = strrep(Old_name,Old_Str,New_Str);
        if ~strcmp(Old_name,New_name)
            dos(['rename ' Old_name ' ' New_name]);
            disp(New_name);
        end
    end
    cd('..\');
end
