%% Reseting environment
rng('shuffle'); % Random seed
close all       % Close all figure
clear           % Clear workspace
clc             % Clear command window

%% Initialization
Old_Str = 'Trend';
New_Str = 'Sign';

%% Files name
files_name = dir('*.m');
nfiles = length(files_name);

%% Rename
for i=1:nfiles
    Old_name = files_name(i).name;
    New_name = strrep(Old_name,Old_Str,New_Str);
    if ~strcmp(Old_name,New_name)
        dos(['rename ' Old_name ' ' New_name]);
        disp(New_name);
    end
end
