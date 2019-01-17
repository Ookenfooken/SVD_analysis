%% Convert edf to asc for SVD data
%  currently ignore all asc files named _e or _s
close all
clear all

startFolder = [pwd '\']; %where is the edf2asc program?
dataPath = fullfile(pwd,'..','data\temp\saccade_data\');
%dataPath = 'C:\Users\Joli\Desktop\temp\saccade\';
folderNames = dir(dataPath);
currentSubject = {};


%% Loop over all subjects

for i = 3:length(folderNames)
    currentSubject{i-2} = folderNames(i).name;
    
    currentFolder = [dataPath currentSubject{i-2}];
    %cd(currentFolder);
    
    [res, stat] = system([startFolder 'edf2asc -y ' currentFolder '\*.edf']);
    
    %cd(startFolder);
    ascfiles = dir([currentFolder '\*.asc']);
    index = [];
    for j = 1:length(ascfiles)
        ascfile = ascfiles(j).name;
        path = fullfile(currentFolder, ascfile);
        fid = fopen(path);
        
        textscan(fid, '%*[^\n]', 25);
        entries = textscan(fid, '%s','delimiter','\n');
        label = strfind(entries{:}, 'SYNCTIME');
        onsets = find(not(cellfun('isempty', label)));
        if ~isempty(onsets)
            targetOnset(j,1) = onsets(1);
        else
            targetOnset(j,1) = NaN;
        end
                
        fclose(fid);
    end
    cd(currentFolder)
    save('targetOnset', 'targetOnset')
    cd(startFolder)
    [res, stat] = system([startFolder 'edf2asc -y -s -miss 9999 -nflags ' currentFolder '\*.edf']);
end