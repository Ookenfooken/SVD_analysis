%% Script to manually look at subjects and Trials
%  chose eye movement test first

choice = questdlg('Which subject group are you looking at?', ...
	'subject type', ...
	'patients','controls', 'patients');

switch choice
    case 'patients'
        dataPath = fullfile(pwd, '..','data\patients\');
    case 'controls'
        dataPath = fullfile(pwd, '..','data\controls\');
end

str = {'anti saccade', 'pro saccade', '1 minute saccades', 'smooth purusit', 'predictive pursuit'};

[s,v] = listdlg('PromptString','Select an eye movement test:',...
    'SelectionMode','single',...
    'ListString',str);
    

%% General definitions of the set up here!
%  (should be changed, if e.g. the projector was moved, i.e. the size of
%  the projective are changed. Distance should be fixed, but double
%  checking doesn't hurt
currentTrial = 1;
% % For 2016 EyeStrike testing:
sampleRate = 1000;
screenSizeX = 40.6;
screenSizeY = 30.4;
screenResX = 1600; 
screenResY = 1200;
distance = 83.5;

saccadeThreshold = 30; %threshold for saccade sensitivity
microSaccadeThreshold = 5;
%% Subject selection

analysisPath = pwd;
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

currentSubjectPath = selectSubject(dataPath);
%errors = csvread(['errors' name '.csv']);

cd(currentSubjectPath);
numTrials = length(dir('*.asc'));
eyeFiles = dir('*.asc');
matFiles = dir('*.mat');
% targetInfo = matFiles(1).name;
% targetInfo = load(targetInfo);

if strcmp(name, 'minuteSaccade')
    load('targetOnset.mat');
    cd(analysisPath);
    saccadeTarget = load('saccadeTarget.mat');
elseif strcmp(name, 'antiSaccade') || strcmp(name, 'proSaccade')
    load('targetOnset.mat');
    load('saccadeTarget.mat');
    cd(analysisPath);
    errors = load('errors_saccades.csv');
    errorsMS = load('errors_microSaccades.csv');
elseif strcmp(name, 'smoothPursuit')
    load('targetPosition.mat');
    cd(analysisPath);
end


currentSubject = currentSubjectPath(end-3:end);
targetSelectionAdj = [];

%% open window to plot in
screenSize = get(0,'ScreenSize');
close all;
fig = figure('Position', [25 50 screenSize(3)-100, screenSize(4)-150],'Name','View eye movement data');
set(fig,'defaultLegendAutoUpdate','off');

%% analyze and plot for each trial
if xor(strcmp(name, 'antiSaccade'), strcmp(name, 'proSaccade'))
    analyzeTrialSaccade;
    plotResultsSaccade;
    buttons.discardMS = uicontrol(fig,'string','Discard Micro-Sac','Position',[screenSize(3)-220,250,100,30],...
        'callback', 'currentTrial = currentTrial;analyzeTrialSaccade;plotResultsSaccade; markErrorMicroSaccade');
    
    buttons.changeType = uicontrol(fig,'string','change trial type','Position',[10,200,100,30],...
        'callback', 'currentTrial = currentTrial;analyzeTrialSaccade;plotResultsSaccade; changeTrialType');
    
    buttons.previous = uicontrol(fig,'string','<< Previous','Position',[0,50,100,30],...
        'callback','clc; currentTrial = max(currentTrial-1,1);analyzeTrialSaccade;plotResultsSaccade');
    
    buttons.next = uicontrol(fig,'string','Next (0) >>','Position',[0,85,100,30],...
        'callback','clc; currentTrial = currentTrial+1;analyzeTrialSaccade;plotResultsSaccade;finishButton');
    
    buttons.discardTrial = uicontrol(fig,'string','!Discard Trial!','Position',[20,700,100,30],...
        'callback', 'currentTrial = currentTrial;analyzeTrialSaccade;plotResultsSaccade; markErrorSaccade');
    
elseif strcmp(name, 'minuteSaccade')
    analyzeTrialSaccade;
    plotResultsSaccade;
elseif strcmp(name, 'smoothPursuit')
    analyzeTrialPursuit;
    plotResultsPursuit;
    
    buttons.previous = uicontrol(fig,'string','<< Previous','Position',[0,50,100,30],...
        'callback','clc; currentTrial = max(currentTrial-1,1);analyzeTrialPursuit;plotResultsPursuit');
    
    buttons.next = uicontrol(fig,'string','Next (0) >>','Position',[0,85,100,30],...
        'callback','clc; currentTrial = currentTrial+1;analyzeTrialPursuit;plotResultsPursuit;finishButton');
    
    buttons.discardTrial = uicontrol(fig,'string','!Discard Trial!','Position',[20,700,100,30],...
        'callback', 'currentTrial = currentTrial;analyzeTrialPursuit;plotResultsPursuit; markErrorPursuit');
 
end





clear listboxDataFiles;
clear listboxLogFiles;
clear e;
clear selectedBlock;
clear block;