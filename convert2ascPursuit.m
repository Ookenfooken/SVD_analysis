%% Convert edf to asc for SVD project
% 
close all
clear all
%% NEXT TIME FOR CONVERSION CHECK HOW MUCH HEADER SHOULD BE SKIPPED!!! IMPORTANT TO ACTUALLY GET THE RIGHT TARGET INDEX!!!
startFolder = [pwd '\']; %where is the edf2asc program?
dataPath = fullfile(pwd,'..','data\controls\temp\');
%dataPath = 'E:\antiSaccades\';
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
    
    for j = 1:length(ascfiles)
        ascfile = ascfiles(j).name;
        path = fullfile(currentFolder, ascfile);
        fid = fopen(path);
        allEntries = textscan(fid, '%s','delimiter','\n');
        startLabel = strfind(allEntries{:}, 'MODE RECORD');
        header = find(not(cellfun('isempty', startLabel)));
        targetLabel = strfind(allEntries{:}, 'SYNCTIME');
        targetPositionIdx = find(not(cellfun('isempty', targetLabel)));
        targetOnset = targetPositionIdx(1) - header;
%         for k = 1:length(targetPositionIdx)
%             edfEntry = allEntries{1,1}(targetPositionIdx(k));
%             timeStamp = str2double(edfEntry{1}(5:11));
%             startIdx = strfind(edfEntry, '(');
%             breakIdx = strfind(edfEntry, ',');
%             stopIdx = strfind(edfEntry, ')');
%             xPos = str2double(edfEntry{1}(startIdx{1}+1:breakIdx{1}-1));
%             yPos = str2double(edfEntry{1}(breakIdx{1}+1:stopIdx{1}-1));
%             currentTargetPosition(k,:) = [timeStamp xPos yPos]; 
%         end
        name = {['trial' num2str(j)]};
        targetPosition.(name{1}) = targetOnset;
        freqLabel = strfind(allEntries{:}, 'freq_x');
        frequencyIdx = allEntries{1,1}(find(not(cellfun('isempty', freqLabel)))); 
        frequency(j) = str2double(frequencyIdx{1,1}(end-5:end-1));
        fclose(fid);
    end
    cd(currentFolder)
    targetPosition.frequency = frequency;
    save('targetPosition', 'targetPosition')
    cd(startFolder)
    [res, stat] = system([startFolder 'edf2asc -y -s -miss 9999 -nflags ' currentFolder '\*.edf']);
end