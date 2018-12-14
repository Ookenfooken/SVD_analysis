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
trial = readoutTrialPursuit(ascFile, eyeData, currentSubject, target); 

%% find saccades
threshold = evalin('base', 'saccadeThreshold');
[saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(1, trial.length, trial.eye.DX_filt, trial.eye.DDX_filt, threshold, trial.target.Xvel);
[saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(1, trial.length, trial.eye.DY_filt, trial.eye.DDY_filt, threshold, trial.target.Yvel);

%% analyze saccades
[trial] = analyzeSaccadesPursuit(trial, saccades);

clear saccades;
%% remove saccades (include blinks
trial = removeBlinksSaccades(trial);
