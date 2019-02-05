%% Convert edf to asc for SVD project
% 
%  currently ignore all asc files named _e or _s
close all
clear all
%% NEXT TIME FOR CONVERSION CHECK HOW MUCH HEADER SHOULD BE SKIPPED!!! IMPORTANT TO ACTUALLY GET THE RIGHT TARGET INDEX!!!
startFolder = [pwd '\']; %where is the edf2asc program?
dataPath = fullfile(pwd,'..','data\patients\proSac_data\');
%dataPath = fullfile(pwd,'..','data\controls\temp\');
folderNames = dir(dataPath);
currentSubject = {};


%% Loop over all subjects

for i = 3:length(folderNames)
    currentSubject{i-2} = folderNames(i).name;
    
    currentFolder = [dataPath currentSubject{i-2}];
    cd(currentFolder);
    
    [res, stat] = system([startFolder 'edf2asc -y ' currentFolder '\*.edf']);
    
    cd(startFolder);
    ascfiles = dir([currentFolder '\*.asc']);
    index = [];
    for j = 1:length(ascfiles)
        ascfile = ascfiles(j).name;
        path = fullfile(currentFolder, ascfile);
        fid = fopen(path);
        allEntries = textscan(fid, '%s','delimiter','\n');
        startLabel = strfind(allEntries{:}, 'FIXATION_DISPLAY');
        header = find(not(cellfun('isempty', startLabel)));
        targetLabel = strfind(allEntries{:}, 'TARGET_DISPLAY');
        onsets = find(not(cellfun('isempty', targetLabel)));
        onsets = onsets - header(1);
        if ~isempty(onsets)
            targetOnset(j,1) = onsets(1);
        else
            targetOnset(j,1) = NaN;
        end
        
        if isempty(strfind(allEntries{1, 1}{end-1, 1}, 'right'))
            saccadeTarget(j,1) = 0;
        else
            saccadeTarget(j,1) = 1;
        end
        
        fclose(fid);
    end
    cd(currentFolder)
    save('targetOnset', 'targetOnset')
    save('saccadeTarget', 'saccadeTarget')
    cd(startFolder)
    [res, stat] = system([startFolder 'edf2asc -y -s -miss 9999 -nflags ' currentFolder '\*.edf']);
end