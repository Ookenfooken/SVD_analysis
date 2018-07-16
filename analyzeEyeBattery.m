%% Main Data Analysis for Baseball Testing 2013/2014
%  Always update at the same time as viewEyeData!!!
%% General definitions of the set up here!
sampleRate = 1000;
screenSizeX = 40.6;
screenSizeY = 30.4;
screenResX = 1600; 
screenResY = 1200;
distance = 83.5;

saccadeThreshold = 30; %threshold for saccade sensitivity
microSaccadeThreshold = 5;
%% chose patients or controls here
analysisPath = pwd;
dataPath = fullfile(pwd, '..','data\controls\');
%% select eye movement battery to run through
str = {'anti saccade', 'pro saccade', '1 minute saccades', 'smooth purusit', 'predictive pursuit'};

[s,v] = listdlg('PromptString','Select an eye movement test:',...
    'SelectionMode','single',...
    'ListString',str);

if s == 1 
    dataPath = fullfile(dataPath, 'antiSac_data\');
    name = 'antiSaccade';
elseif s == 2
    dataPath = fullfile(dataPath, 'proSac_data\');
    name = 'proSaccade';
elseif s == 3
    dataPath = fullfile(dataPath, 'saccade_data\');
    name = 'minuteSaccade';
elseif s == 4
    dataPath = fullfile(dataPath, 'pursuit_data\');
    name = 'smoothPursuit';
else
    dataPath = fullfile(dataPath, 'predict_pursuit_data\');
    name = 'predictivePursuit';
end  

resultPath = fullfile(pwd, name, '\controls');
%% create list of all subjects
folderNames = dir(dataPath);
currentSubject = {};

%% Loop over all subjects

for i = 3:length(folderNames)
    currentSubject{i-2} = folderNames(i).name;
    
    currentFolder = [dataPath currentSubject{i-2}];
    cd(currentFolder);    
    numTrials = length(dir('*.asc'));
    eyeFiles = dir('*.asc');
    matFiles = dir('*.mat');
    if length(matFiles) > 3
        if strcmp(matFiles(1).name(end-6:end), 'Sac.mat')
            load(matFiles(2).name)
        else
            load(matFiles(1).name)
        end
    else 
       targetSelectionAdj = []; 
    end
    load('targetOnset.mat');
    % for reading out pro and anti saccade tasks uncomment here
    load('saccadeTarget.mat');
    % go into analysis folder
    cd(analysisPath)
    % for reading out the minut saccade uncomment here
    % saccadeTarget = load('saccadeTarget.mat');
    
    % Ich bin in einem Folder drin. Loope ueber trials
    %% analyze for each trial
    for currentTrial = 1:numTrials
    % for currentTrial = 1:27 % this is for baseline trials only
        [results.trial] = automaticAnalysisSaccade(eyeFiles, currentTrial, currentSubject{i-2}, analysisPath, dataPath, targetOnset, saccadeTarget, targetSelectionAdj);
        analysisResults(:,currentTrial) = results;
    end
    
    cd(resultPath)
    save(currentSubject{i-2}, 'analysisResults')
    
    cd(analysisPath)
    
    clear analysisResults
    clear results
    clear targetInfor targetOnset saccadeTarget
    clear eyeFiles
    clear ascfiles
    clear numTrials
    clear currentFolder

end