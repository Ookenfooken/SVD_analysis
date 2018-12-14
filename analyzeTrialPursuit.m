%% setup data
%% Eye Data
%  eye data have been converted in readEDF
%  first step: read in converted eye data
ascFile = eyeFiles(currentTrial,1).name;
eyeData = readEyeData(ascFile, dataPath, currentSubject, analysisPath);
eyeData = processEyeData(eyeData); % equivalent to socscalexy

%% Target data
% set up target file
target = createTargetData(targetPosition, ascFile, eyeData);

%% setup trial
trial = readoutTrialPursuit(ascFile, eyeData, currentSubject, targetOnset, saccadeTarget); 

%% find saccades
threshold = evalin('base', 'saccadeThreshold');
[saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(1, trial.length, trial.eyeDX_filt, trial.eyeDDX_filt, threshold, 0);
[saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(1, trial.length, trial.eyeDY_filt, trial.eyeDDY_filt, threshold, 0);

%% analyze saccades
[trial] = analyzeSaccades(trial, saccades, name);

clear saccades;
%% remove saccades
% option to remove large saccades during fixation period 
if ~strcmp(name, 'minuteSaccade')
    trial = removeSaccades(trial);
    %% fi-saccades
    m_threshold = evalin('base', 'microSaccadeThreshold');
    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(1, targetOnset(currentTrial)-50, trial.DX_noSac, trial.DDX_noSac, m_threshold, 0);
    [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(1, targetOnset(currentTrial)-50, trial.DY_noSac, trial.DDY_noSac, m_threshold, 0);
    %% analyze micro-saccades
    [trial] = analyzeMicroSaccades(trial, saccades);
    
    clear saccades;
end