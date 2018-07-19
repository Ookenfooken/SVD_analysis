%% define data home base
analysisPath = pwd;
savePath = fullfile(pwd, 'resultFiles');
errorList = load('errors_microSaccades.csv');

%% Read out controls 
% initiate result parameters
resultPath = fullfile(pwd, 'proSaccade\controls'); 
allResults = dir(resultPath);
errorsMicroSaccade_controls = errorList(errorList(:,1) == 0, :);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
controls = [];

% loop over all participants
for j = 3:length(allResults)    
    % load data
    selectedResult{j-2} = allResults(j).name;    
    block = load(selectedResult{j-2} );
    block = block.analysisResults;
    numTrials = length(block);    
    
    % initiate conditions and experimental factors
    currentSubject = str2double(selectedResult{j-2}(2:4));
    patient = zeros(numTrials,1);
    subject = currentSubject*ones(numTrials,1);
    % initiate saccade parameters
    numberMicro = NaN(numTrials,1);
    sacSumMicro = NaN(numTrials,1);
    meanAmpMicro = NaN(numTrials,1);
    numberLarge = NaN(numTrials,1);
    sacSumLarge = NaN(numTrials,1);
    meanAmpLarge = NaN(numTrials,1);
    
    % flag the trials that had blinks
    flagged = zeros(numTrials,1);
    idx = find((errorsMicroSaccade_controls(:,3) == currentSubject));
    flagged(errorListMicroSaccade_controls(idx,4)) = 1;
        
    % loop over trials
    for i = 1:numTrials
        if ~isempty(block(i).trial) && ~isempty(block(i).trial.microSaccades.onsets)
            % separate into micro-saccades and normal saccades done during
            % fixaton
            for k = 1:length(block(i).trial.microSaccades.onsets)
                if block(i).trial.microSaccades.amplitudes(k) > 5
                    sacIdx(k) = 0;
                else
                    sacIdx(k) = 1;
                end
            end
            % read out saccade parameters
            numberMicro(i,1) = sum(sacIdx);
            numberLarge(i,1) = block(i).trial.microSaccades.number - sum(sacIdx);
            sacSumMicro(i,1) = sacIdx*block(i).trial.microSaccades.amplitudes;
            sacSumLarge(i,1) = block(i).trial.microSaccades.sum - sacSumMicro(i,1);
        else
            numberMicro(i,1) = NaN;
            % read out saccade parameters
            sacSumMicro(i,1) = NaN;
            meanAmpMicro(i,1) = NaN;
            numberLarge(i,1) = NaN;
            sacSumLarge(i,1) = NaN;
            meanAmpLarge(i,1) = NaN;
        end
    end
        
    currentControl_pro = [flagged patient subject numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];
    
    controls_pro = [controls_pro; currentControl_pro];
    
    clear block patient subject numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge flagged
end

controls = [controls_pro; controls_anti];
cd(analysisPath);
%% zScore controls data
controls = controls(controls(:,1) == 0, :);

sacSumMicro = controls(:,5);
latIdx = isnan(sacSumMicro);
zScore_lat = zscore(sacSumMicro(~isnan(sacSumMicro)));
sacSumMicro((zScore_lat > 3 | zScore_lat < -3)) = NaN;
sacSumMicro(latIdx) = NaN;

meanAmpMicro = controls(:,6);
velIdx = isnan(meanAmpMicro);
zScore_vel = zscore(meanAmpMicro(~isnan(meanAmpMicro)));
meanAmpMicro((zScore_vel > 3 | zScore_vel < -3)) = NaN;
meanAmpMicro(velIdx) = NaN;

numberLarge = controls(:,7);
accIdx = isnan(numberLarge);
zScore_acc = zscore(numberLarge(~isnan(numberLarge)));
numberLarge((zScore_acc > 3 | zScore_acc < -3)) = NaN;
numberLarge(accIdx) = NaN;

sacSumLarge = controls(:,8);
accxIdx = isnan(sacSumLarge);
zScore_accx = zscore(sacSumLarge(~isnan(sacSumLarge)));
sacSumLarge((zScore_accx > 3 | zScore_accx < -3)) = NaN;
sacSumLarge(accxIdx) = NaN;

meanAmpLarge = controls(:,9);
accyIdx = isnan(meanAmpLarge);
zScore_accy = zscore(meanAmpLarge(~isnan(meanAmpLarge)));
meanAmpLarge((zScore_accy > 3 | zScore_accy < -3)) = NaN;
meanAmpLarge(accyIdx) = NaN;

controls = [controls(:,2:4) sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];

clear latency latIdx zScore_lat accuracy_x accxIdx zScore_accx
clear accuracy_y accyIdx zScore_accy accuracy_abs accIdx zScore_acc 
clear velocity velIdx zScore_vel
clear resultPath allResults numResults selectedResult 

%% Read out patients
% initiate result parameters
resultPath = fullfile(pwd, 'proSaccade\patients'); 
allResults = dir(resultPath);
errorsProSaccade_patients = errorsProSaccade(errorsProSaccade(:,1) == 1, :);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
patients = [];

% loop over all participants
for j = 3:length(allResults)    
    % load data
    selectedResult{j-2} = allResults(j).name;    
    block = load(selectedResult{j-2} );
    block = block.analysisResults;
    numTrials = length(block);    
    
    % initiate conditions and experimental factors
    currentSubject = str2double(selectedResult{j-2}(2:4));
    patient = ones(numTrials,1);
    subject = currentSubject*ones(numTrials,1);
    % initiate saccade parameters
    numberMicro = NaN(numTrials,1);
    sacSumMicro = NaN(numTrials,1);
    meanAmpMicro = NaN(numTrials,1);
    numberLarge = NaN(numTrials,1);
    sacSumLarge = NaN(numTrials,1);
    meanAmpLarge = NaN(numTrials,1);
    
    % flag the trials that had blinks
    flagged = zeros(numTrials,1);
    idx = find((errorsProSaccade_patients(:,3) == currentSubject));
    flagged(errorList(idx,4)) = 1;
    
    % loop over trials
    for i = 1:numTrials
        if ~isempty(block(i).trial) && ~isempty(block(i).trial.saccades.onsets)
            % if task done correctly assign 1, if invalid assign 0, for change
            % of mind assign 2
            numberMicro(i,1) = block(i).trial.saccades.targetSelection;
            % read out saccade parameters
            sacSumMicro(i,1) = block(i).trial.saccades.latency;
            meanAmpMicro(i,1) = max(block(i).trial.saccades.velocities);
            numberLarge(i,1) = block(i).trial.saccades.accuracy;
            if ~isnan(block(i).trial.saccades.accuracy)
                sacSumLarge(i,1) = block(i).trial.saccades.accuracyX;
                meanAmpLarge(i,1) = block(i).trial.saccades.accuracyY;
            else
                sacSumLarge(i,1) = NaN;
                meanAmpLarge(i,1) = NaN;
            end
        else
            numberMicro(i,1) = NaN;
            % read out saccade parameters
            sacSumMicro(i,1) = NaN;
            meanAmpMicro(i,1) = NaN;
            numberLarge(i,1) = NaN;
            sacSumLarge(i,1) = NaN;
            meanAmpLarge(i,1) = NaN;
        end
    end
    
    currentPatient = [flagged patient subject numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];
    
    patients = [patients; currentPatient];
    
    clear block patient subject task latency velocity accuracy_abs accuracy_x accuracy_y flagged
    
end

cd(analysisPath);

%% zScore patient data
patients = patients(patients(:,1) == 0, :);

sacSumMicro = patients(:,5);
latIdx = isnan(sacSumMicro);
zScore_lat = zscore(sacSumMicro(~isnan(sacSumMicro)));
sacSumMicro((zScore_lat > 3 | zScore_lat < -3)) = NaN;
sacSumMicro(latIdx) = NaN;

meanAmpMicro = patients(:,6);
velIdx = isnan(meanAmpMicro);
zScore_vel = zscore(meanAmpMicro(~isnan(meanAmpMicro)));
meanAmpMicro((zScore_vel > 3 | zScore_vel < -3)) = NaN;
meanAmpMicro(velIdx) = NaN;

numberLarge = patients(:,7);
accIdx = isnan(numberLarge);
zScore_acc = zscore(numberLarge(~isnan(numberLarge)));
numberLarge((zScore_acc > 3 | zScore_acc < -3)) = NaN;
numberLarge(accIdx) = NaN;

sacSumLarge = patients(:,8);
accxIdx = isnan(sacSumLarge);
zScore_accx = zscore(sacSumLarge(~isnan(sacSumLarge)));
sacSumLarge((zScore_accx > 3 | zScore_accx < -3)) = NaN;
sacSumLarge(accxIdx) = NaN;

meanAmpLarge = patients(:,9);
accyIdx = isnan(meanAmpLarge);
zScore_accy = zscore(meanAmpLarge(~isnan(meanAmpLarge)));
meanAmpLarge((zScore_accy > 3 | zScore_accy < -3)) = NaN;
meanAmpLarge(accyIdx) = NaN;

patients = [patients(:,2:4) sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];

clear latency latIdx zScore_lat accuracy_x accxIdx zScore_accx
clear accuracy_y accyIdx zScore_accy accuracy_abs accIdx zScore_acc 
clear velocity velIdx zScore_vel
clear resultPath allResults numResults selectedResult  

%% Now combine the 2 results and save data
cd(savePath)
proSaccadeResults = [controls; patients];
save('proSaccadeResults', 'proSaccadeResults')
csvwrite('proSaccadeResults.csv', proSaccadeResults)
cd(analysisPath)
