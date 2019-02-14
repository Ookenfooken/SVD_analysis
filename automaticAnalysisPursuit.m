function trial = automaticAnalysisPursuit(eyeFiles, currentTrial, currentSubject, analysisPath, dataPath, targetPosition)
%% Eye Data
%  eye data have been converted in readEDF
%  first step: read in converted eye data
ascFile = eyeFiles(currentTrial,1).name;
eyeData = readEyeData(ascFile, dataPath, currentSubject, analysisPath);
eyeData = processEyeData(eyeData); % equivalent to socscalexy

%% Target data
% set up target file
target = createTargetData(targetPosition, ascFile, eyeData, str2double(currentSubject(end-2:end)));

if length(target.cycle.maxima) ~= 5
    trial = [];
else
    
    %% setup trial
    trial = readoutTrialPursuit(ascFile, eyeData, currentSubject, target);
    
    %% find saccades
    thresholdMoveDirection = 10;%evalin('base', 'saccadeThreshold');
    thresholdZero = evalin('base', 'microSaccadeThreshold');
    if sum(trial.target.X) == 0
        [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(1, trial.length, trial.eye.DX_filt, trial.eye.DDX_filt, thresholdZero, trial.target.Xvel);
        [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(1, trial.length, trial.eye.DY_filt, trial.eye.DDY_filt, thresholdMoveDirection, trial.target.Yvel);
    elseif sum(trial.target.Y) == 0
        [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(1, trial.length, trial.eye.DX_filt, trial.eye.DDX_filt, thresholdMoveDirection, trial.target.Xvel);
        [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(1, trial.length, trial.eye.DY_filt, trial.eye.DDY_filt, thresholdZero, trial.target.Yvel);
    end
    %% analyze saccades
    [trial] = analyzeSaccadesPursuit(trial, saccades);
    
    clear saccades;
    
    %% remove saccades (include blinks
    trial = removeBlinksSaccades(trial);
    
    %% analyze pursuit
    trial = analyzePursuit(trial);
end
end