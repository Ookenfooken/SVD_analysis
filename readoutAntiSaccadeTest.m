%% define data home base
analysisPath = pwd;
savePath = fullfile(pwd, 'resultFiles');
errorList = load('errors_saccades.csv');
errorsAntiSaccade = errorList(errorList(:,2) == 2, :);

%% Read out controls 
% initiate result parameters
resultPath = fullfile(pwd, 'antiSaccade\controls'); 
allResults = dir(resultPath);
errorsAntiSaccade_controls = errorsAntiSaccade(errorsAntiSaccade(:,1) == 0, :);
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
    task = NaN(numTrials,1);
    latency = NaN(numTrials,1);
    velocity = NaN(numTrials,1);
    firstAmp = NaN(numTrials,1);
    cumulative = NaN(numTrials,1);
    number = NaN(numTrials,1);
    accuracy_abs = NaN(numTrials,1);
    accuracy_x = NaN(numTrials,1);
    accuracy_y = NaN(numTrials,1);
    
    % flag the trials that had blinks
    flagged = zeros(numTrials,1);
    idx = find((errorsAntiSaccade_controls(:,3) == currentSubject));
    flagged(errorsAntiSaccade_controls(idx,4)) = 1;
    
    % loop over trials
    for i = 1:numTrials
        if ~isempty(block(i).trial) && ~isempty(block(i).trial.saccades.onsets) 
            % if task done correctly assign 1, if invalid assign 0, for change
            % of mind assign 2
            task(i,1) = block(i).trial.saccades.targetSelection;
            % read out saccade parameters
            latency(i,1) = block(i).trial.saccades.latency;
            velocity(i,1) = block(i).trial.saccades.velocities(1);
            firstAmp(i,1) = block(i).trial.saccades.amplitudes(1);
            cumulative(i,1) = sum(block(i).trial.saccades.amplitudes);
            number(i,1) = block(i).trial.saccades.number;
            accuracy_abs(i,1) = block(i).trial.saccades.accuracy;
            if ~isnan(block(i).trial.saccades.accuracy)
                accuracy_x(i,1) = block(i).trial.saccades.accuracyX;
                accuracy_y(i,1) = block(i).trial.saccades.accuracyY;
            else
                accuracy_x(i,1) = NaN;
                accuracy_y(i,1) = NaN;
            end
        else
            task(i,1) = NaN;
            % read out saccade parameters
            latency(i,1) = NaN;
            velocity(i,1) = NaN;
            firstAmp(i,1) = NaN;
            cumulative(i,1) = NaN;
            number(i,1) = NaN;
            accuracy_abs(i,1) = NaN;
            accuracy_x(i,1) = NaN;
            accuracy_y(i,1) = NaN;
        end
    end
    
    currentControl = [flagged patient subject task latency velocity firstAmp cumulative number accuracy_abs accuracy_x accuracy_y];
    
    controls = [controls; currentControl];
    
    clear block patient subject task latency velocity firstAmp cumulative number accuracy_abs accuracy_x accuracy_y flagged
end

cd(analysisPath);
%% zScore controls data
controls = controls(controls(:,1) == 0, :);

latency = controls(:,5);
latIdx = isnan(latency);
zScore_lat = zscore(latency(~isnan(latency)));
latency((zScore_lat > 3 | zScore_lat < -3)) = NaN;
latency(latIdx) = NaN;

velocity = controls(:,6);
velIdx = isnan(velocity);
zScore_vel = zscore(velocity(~isnan(velocity)));
velocity((zScore_vel > 3 | zScore_vel < -3)) = NaN;
velocity(velIdx) = NaN;

firstAmp = controls(:,7);
ampIdx = isnan(firstAmp);
zScore_amp = zscore(firstAmp(~isnan(firstAmp)));
firstAmp((zScore_amp > 3 | zScore_amp < -3)) = NaN;
firstAmp(ampIdx) = NaN;

cumulative = controls(:,8);
cumIdx = isnan(cumulative);
zScore_cum = zscore(cumulative(~isnan(cumulative)));
cumulative((zScore_cum > 3 | zScore_cum < -3)) = NaN;
cumulative(cumIdx) = NaN;

number = controls(:,9);
numIdx = isnan(number);
zScore_num = zscore(number(~isnan(number)));
number((zScore_num > 3 | zScore_num < -3)) = NaN;
number(numIdx) = NaN;

accuracy_abs = controls(:,10);
accIdx = isnan(accuracy_abs);
zScore_acc = zscore(accuracy_abs(~isnan(accuracy_abs)));
accuracy_abs((zScore_acc > 3 | zScore_acc < -3)) = NaN;
accuracy_abs(accIdx) = NaN;

accuracy_x = controls(:,11);
accxIdx = isnan(accuracy_x);
zScore_accx = zscore(accuracy_x(~isnan(accuracy_x)));
accuracy_x((zScore_accx > 3 | zScore_accx < -3)) = NaN;
accuracy_x(accxIdx) = NaN;

accuracy_y = controls(:,12);
accyIdx = isnan(accuracy_y);
zScore_accy = zscore(accuracy_y(~isnan(accuracy_y)));
accuracy_y((zScore_accy > 3 | zScore_accy < -3)) = NaN;
accuracy_y(accyIdx) = NaN;

controls = [controls(:,2:4) latency velocity firstAmp cumulative number accuracy_abs accuracy_x accuracy_y];

clear latency latIdx zScore_lat cumulative cumIdx zScore_cum
clear firstAmp ampIdx zScore_amp velocity velIdx zScore_vel
clear number numIdx zScore_num accuracy_abs accIdx zScore_acc 
clear accuracy_x accxIdx zScore_acxc accuracy_y accyIdx zScore_accy
clear resultPath allResults numResults selectedResult 

%% Read out patients
% initiate result parameters
resultPath = fullfile(pwd, 'antiSaccade\patients'); 
allResults = dir(resultPath);
errorsAntiSaccade_patients = errorsAntiSaccade(errorsAntiSaccade(:,1) == 1, :);
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
    task = NaN(numTrials,1);
    latency = NaN(numTrials,1);
    velocity = NaN(numTrials,1);
    firstAmp = NaN(numTrials,1);
    cumulative = NaN(numTrials,1);
    number = NaN(numTrials,1);
    accuracy_abs = NaN(numTrials,1);
    accuracy_x = NaN(numTrials,1);
    accuracy_y = NaN(numTrials,1);
    
    % flag the trials that had blinks
    flagged = zeros(numTrials,1);
    idx = find((errorsAntiSaccade_patients(:,3) == currentSubject));
    flagged(errorsAntiSaccade_patients(idx,4)) = 1;
    
    % loop over trials
    for i = 1:numTrials
        if ~isempty(block(i).trial) && ~isempty(block(i).trial.saccades.onsets) 
            % if task done correctly assign 1, if invalid assign 0, for change
            % of mind assign 2
            task(i,1) = block(i).trial.saccades.targetSelection;
            % read out saccade parameters
            latency(i,1) = block(i).trial.saccades.latency;
            velocity(i,1) = block(i).trial.saccades.velocities(1);
            firstAmp(i,1) = block(i).trial.saccades.amplitudes(1);
            cumulative(i,1) = sum(block(i).trial.saccades.amplitudes);
            number(i,1) = block(i).trial.saccades.number;
            accuracy_abs(i,1) = block(i).trial.saccades.accuracy;
            if ~isnan(block(i).trial.saccades.accuracy)
                accuracy_x(i,1) = block(i).trial.saccades.accuracyX;
                accuracy_y(i,1) = block(i).trial.saccades.accuracyY;
            else
                accuracy_x(i,1) = NaN;
                accuracy_y(i,1) = NaN;
            end
        else
            task(i,1) = NaN;
            % read out saccade parameters
            latency(i,1) = NaN;
            velocity(i,1) = NaN;
            firstAmp(i,1) = NaN;
            cumulative(i,1) = NaN;
            number(i,1) = NaN;
            accuracy_abs(i,1) = NaN;
            accuracy_x(i,1) = NaN;
            accuracy_y(i,1) = NaN;
        end
    end
    
    currentPatient = [flagged patient subject task latency velocity firstAmp cumulative number accuracy_abs accuracy_x accuracy_y];
    
    patients = [patients; currentPatient];
    
    clear block patient subject task latency cumulative number accuracy velocity flagged
    
end

cd(analysisPath);

%% zScore patient data
patients = patients(patients(:,1) == 0, :);

latency = patients(:,5);
latIdx = isnan(latency);
zScore_lat = zscore(latency(~isnan(latency)));
latency((zScore_lat > 3 | zScore_lat < -3)) = NaN;
latency(latIdx) = NaN;

velocity = patients(:,6);
velIdx = isnan(velocity);
zScore_vel = zscore(velocity(~isnan(velocity)));
velocity((zScore_vel > 3 | zScore_vel < -3)) = NaN;
velocity(velIdx) = NaN;

firstAmp = patients(:,7);
ampIdx = isnan(firstAmp);
zScore_amp = zscore(firstAmp(~isnan(firstAmp)));
firstAmp((zScore_amp > 3 | zScore_amp < -3)) = NaN;
firstAmp(ampIdx) = NaN;

cumulative = patients(:,8);
cumIdx = isnan(cumulative);
zScore_cum = zscore(cumulative(~isnan(cumulative)));
cumulative((zScore_cum > 3 | zScore_cum < -3)) = NaN;
cumulative(cumIdx) = NaN;

number = patients(:,9);
numIdx = isnan(number);
zScore_num = zscore(number(~isnan(number)));
number((zScore_num > 3 | zScore_num < -3)) = NaN;
number(numIdx) = NaN;

accuracy_abs = patients(:,10);
accIdx = isnan(accuracy_abs);
zScore_acc = zscore(accuracy_abs(~isnan(accuracy_abs)));
accuracy_abs((zScore_acc > 3 | zScore_acc < -3)) = NaN;
accuracy_abs(accIdx) = NaN;

accuracy_x = patients(:,11);
accxIdx = isnan(accuracy_x);
zScore_accx = zscore(accuracy_x(~isnan(accuracy_x)));
accuracy_x((zScore_accx > 3 | zScore_accx < -3)) = NaN;
accuracy_x(accxIdx) = NaN;

accuracy_y = patients(:,12);
accyIdx = isnan(accuracy_y);
zScore_accy = zscore(accuracy_y(~isnan(accuracy_y)));
accuracy_y((zScore_accy > 3 | zScore_accy < -3)) = NaN;
accuracy_y(accyIdx) = NaN;

patients = [patients(:,2:4) latency velocity firstAmp cumulative number accuracy_abs accuracy_x accuracy_y];

clear latency latIdx zScore_lat cumulative cumIdx zScore_cum
clear firstAmp ampIdx zScore_amp velocity velIdx zScore_vel
clear number numIdx zScore_num accuracy accIdx zScore_acc 
clear accuracy_x accxIdx zScore_acxc accuracy_y accyIdx zScore_accy
clear resultPath allResults numResults selectedResult 

%% Now combine the 2 results and save data
cd(savePath)
antiSaccadeResults = [controls; patients];
save('antiSaccadeResults', 'antiSaccadeResults')
csvwrite('antiSaccadeResults.csv', antiSaccadeResults)
cd(analysisPath)