%% setup data
%% Eye Data
%  eye data have been converted in readEDF
%  first step: read in converted eye data
ascFile = eyeFiles(currentTrial,1).name;
eyeData = readEyeData(ascFile, dataPath, currentSubject, analysisPath);
eyeData = processEyeDataSaccade(eyeData, str2double(ascFile(end-5:end-4)), targetOnset); % equivalent to socscalexy

%% setup trial
trial = readoutTrialSaccade(ascFile, eyeData, currentSubject, targetOnset, saccadeTarget); 

%% find saccades
threshold = evalin('base', 'saccadeThreshold');
[saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(1, trial.length, trial.eyeDX_filt, trial.eyeDDX_filt, threshold, 0);
[saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(1, trial.length, trial.eyeDY_filt, trial.eyeDDY_filt, threshold, 0);

%% analyze saccades
[trial] = analyzeSaccades(trial, saccades, name);

clear saccades;
%% remove saccades
% option to remove large saccades during fixation period 
trial = removeSaccades(trial);

m_threshold = evalin('base', 'microSaccadeThreshold');
[saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(1, targetOnset(currentTrial)-50, trial.DX_noSac, trial.DDX_noSac, m_threshold, 0);
[saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(1, targetOnset(currentTrial)-50, trial.DY_noSac, trial.DDY_noSac, m_threshold, 0);
%[saccades.micro, saccades.radius] = microsacc([trial.eyeX(1:1001) trial.eyeY(1:1001)], [trial.eyeDX(1:1001) trial.eyeDY(1:1001)], microSaccadeThreshold, 0.5, zeros(1000,1));
%% analyze micro-saccades
[trial] = analyzeMicroSaccades(trial, saccades);

clear saccades;