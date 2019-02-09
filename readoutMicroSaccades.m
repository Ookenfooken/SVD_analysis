%% define data home base
analysisPath = pwd;
savePath = fullfile(pwd, 'resultFiles');
errorList = load('errors_microSaccade.csv');

%% Read out controls 
errorsMicroSaccade_controls = errorList(errorList(:,1) == 0, :);
% initiate result parameters
resultPath = fullfile(pwd, 'proSaccade\controls'); 
allResults = dir(resultPath);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
controls_pro = [];

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
    task = ones(numTrials,1);
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
    flagged(errorsMicroSaccade_controls(idx,4)) = 1;
        
    % loop over trials
    for i = 1:numTrials
        if flagged(i)
            continue
        end
        if ~isempty(block(i).trial) 
            % separate into micro-saccades and normal saccades done during
            % fixaton
            if isempty(block(i).trial.saccades.X.fixOnsets) && isempty(block(i).trial.saccades.Y.fixOnsets)
                % read out saccade parameters
                numberMicro(i,1) = block(i).trial.microSaccades.number;
                if block(i).trial.microSaccades.number == 0
                    sacSumMicro(i,1) = 0;
                    meanAmpMicro(i,1) = 0;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                else
                    sacSumMicro(i,1) = block(i).trial.microSaccades.sum;
                    meanAmpMicro(i,1) = block(i).trial.microSaccades.meanAmplitude;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                end
            else
                microIdx = block(i).trial.microSaccades.amplitudes < 3;
                numberMicro(i,1) = sum(microIdx);
                sacSumMicro(i,1) = sum(block(i).trial.microSaccades.amplitudes(microIdx));
                meanAmpMicro(i,1) = mean(block(i).trial.microSaccades.amplitudes(microIdx));
                numberLarge(i,1) = block(i).trial.microSaccades.number - numberMicro(i,1);
                sacSumLarge(i,1) = block(i).trial.microSaccades.sum - sacSumMicro(i,1);
                meanAmpLarge(i,1) = sacSumLarge(i,1)/numberLarge(i,1);
            end
        else
            numberMicro(i,1) = NaN;
            sacSumMicro(i,1) = NaN;
            meanAmpMicro(i,1) = NaN;
            numberLarge(i,1) = NaN;
            sacSumLarge(i,1) = NaN;
            meanAmpLarge(i,1) = NaN;
        end
    end
        
    currentControl_pro = [flagged patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];
    
    controls_pro = [controls_pro; currentControl_pro];
    
    clear block patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge flagged
end
cd(analysisPath);

%% zScore controls data
controls_pro = controls_pro(controls_pro(:,1) == 0, :);

numberMicro = controls_pro(:,5);
nomIdx = isnan(numberMicro);
zScore_nom = zscore(numberMicro(~isnan(numberMicro)));
numberMicro((zScore_nom > 3 | zScore_nom < -3)) = NaN;
numberMicro(nomIdx) = NaN;

sacSumMicro = controls_pro(:,6);
msumIdx = isnan(sacSumMicro);
zScore_msum = zscore(sacSumMicro(~isnan(sacSumMicro)));
sacSumMicro((zScore_msum > 3 | zScore_msum < -3)) = NaN;
sacSumMicro(msumIdx) = NaN;

meanAmpMicro = controls_pro(:,7);
mampIdx = isnan(meanAmpMicro);
zScore_namp = zscore(meanAmpMicro(~isnan(meanAmpMicro)));
meanAmpMicro((zScore_namp > 3 | zScore_namp < -3)) = NaN;
meanAmpMicro(mampIdx) = NaN;

numberLarge = controls_pro(:,8);
nolIdx = isnan(numberLarge);
zScore_nol = zscore(numberLarge(~isnan(numberLarge)));
numberLarge((zScore_nol > 3 | zScore_nol < -3)) = NaN;
numberLarge(nolIdx) = NaN;

sacSumLarge = controls_pro(:,9);
lsumIdx = isnan(sacSumLarge);
zScore_lsum = zscore(sacSumLarge(~isnan(sacSumLarge)));
sacSumLarge((zScore_lsum > 3 | zScore_lsum < -3)) = NaN;
sacSumLarge(lsumIdx) = NaN;

meanAmpLarge = controls_pro(:,10);
lampIdx = isnan(meanAmpLarge);
zScore_lamp = zscore(meanAmpLarge(~isnan(meanAmpLarge)));
meanAmpLarge((zScore_lamp > 3 | zScore_lamp < -3)) = NaN;
meanAmpLarge(lampIdx) = NaN;

controls_pro = [controls_pro(:,2:4) numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];

clear numberMicro nomIdx zScore_nom sacSumMicro msumIdx zScore_msum
clear meanAmpMicro mampIdx zScore_namp numberLarge nolIdx zScore_nol
clear sacSumLarge lsumIdx zScore_lsum meanAmpLarge lampIdx zScore_lamp
%%
% initiate result parameters
resultPath = fullfile(pwd, 'antiSaccade\controls'); 
allResults = dir(resultPath);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
controls_anti = [];

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
    task = 2*ones(numTrials,1);
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
    flagged(errorsMicroSaccade_controls(idx,4)) = 1;
        
    % loop over trials
    for i = 1:numTrials
        if flagged(i)
            continue
        end
        if ~isempty(block(i).trial) 
            % separate into micro-saccades and normal saccades done during
            % fixaton
            if isempty(block(i).trial.saccades.X.fixOnsets) && isempty(block(i).trial.saccades.Y.fixOnsets)
                % read out saccade parameters
                numberMicro(i,1) = block(i).trial.microSaccades.number;
                if block(i).trial.microSaccades.number == 0
                    sacSumMicro(i,1) = 0;
                    meanAmpMicro(i,1) = 0;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                else
                    sacSumMicro(i,1) = block(i).trial.microSaccades.sum;
                    meanAmpMicro(i,1) = block(i).trial.microSaccades.meanAmplitude;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                end
            else
                microIdx = block(i).trial.microSaccades.amplitudes < 3;
                numberMicro(i,1) = sum(microIdx);
                sacSumMicro(i,1) = sum(block(i).trial.microSaccades.amplitudes(microIdx));
                meanAmpMicro(i,1) = mean(block(i).trial.microSaccades.amplitudes(microIdx));
                numberLarge(i,1) = block(i).trial.microSaccades.number - numberMicro(i,1);
                sacSumLarge(i,1) = block(i).trial.microSaccades.sum - sacSumMicro(i,1);
                meanAmpLarge(i,1) = sacSumLarge(i,1)/numberLarge(i,1);
            end
        else
            numberMicro(i,1) = NaN;
            sacSumMicro(i,1) = NaN;
            meanAmpMicro(i,1) = NaN;
            numberLarge(i,1) = NaN;
            sacSumLarge(i,1) = NaN;
            meanAmpLarge(i,1) = NaN;
        end
    end
        
    currentControl_anti = [flagged patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];
    
    controls_anti = [controls_anti; currentControl_anti];
    
    clear block patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge flagged
end
cd(analysisPath);
%% zScore controls data
controls_anti = controls_anti(controls_anti(:,1) == 0, :);

numberMicro = controls_anti(:,5);
nomIdx = isnan(numberMicro);
zScore_nom = zscore(numberMicro(~isnan(numberMicro)));
numberMicro((zScore_nom > 3 | zScore_nom < -3)) = NaN;
numberMicro(nomIdx) = NaN;

sacSumMicro = controls_anti(:,6);
msumIdx = isnan(sacSumMicro);
zScore_msum = zscore(sacSumMicro(~isnan(sacSumMicro)));
sacSumMicro((zScore_msum > 3 | zScore_msum < -3)) = NaN;
sacSumMicro(msumIdx) = NaN;

meanAmpMicro = controls_anti(:,7);
mampIdx = isnan(meanAmpMicro);
zScore_namp = zscore(meanAmpMicro(~isnan(meanAmpMicro)));
meanAmpMicro((zScore_namp > 3 | zScore_namp < -3)) = NaN;
meanAmpMicro(mampIdx) = NaN;

numberLarge = controls_anti(:,8);
nolIdx = isnan(numberLarge);
zScore_nol = zscore(numberLarge(~isnan(numberLarge)));
numberLarge((zScore_nol > 3 | zScore_nol < -3)) = NaN;
numberLarge(nolIdx) = NaN;

sacSumLarge = controls_anti(:,9);
lsumIdx = isnan(sacSumLarge);
zScore_lsum = zscore(sacSumLarge(~isnan(sacSumLarge)));
sacSumLarge((zScore_lsum > 3 | zScore_lsum < -3)) = NaN;
sacSumLarge(lsumIdx) = NaN;

meanAmpLarge = controls_anti(:,10);
lampIdx = isnan(meanAmpLarge);
zScore_lamp = zscore(meanAmpLarge(~isnan(meanAmpLarge)));
meanAmpLarge((zScore_lamp > 3 | zScore_lamp < -3)) = NaN;
meanAmpLarge(lampIdx) = NaN;

controls_anti = [controls_anti(:,2:4) numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];

clear numberMicro nomIdx zScore_nom sacSumMicro msumIdx zScore_msum
clear meanAmpMicro mampIdx zScore_namp numberLarge nolIdx zScore_nol
clear sacSumLarge lsumIdx zScore_lsum meanAmpLarge lampIdx zScore_lamp

controls = [controls_pro; controls_anti];
%% Read out patients
errorsMicroSaccade_patients = errorList(errorList(:,1) == 1, :);
% initiate result parameters
resultPath = fullfile(pwd, 'proSaccade\patients'); 
allResults = dir(resultPath);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
patients_pro = [];

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
    task = ones(numTrials,1);
    % initiate saccade parameters
    numberMicro = NaN(numTrials,1);
    sacSumMicro = NaN(numTrials,1);
    meanAmpMicro = NaN(numTrials,1);
    numberLarge = NaN(numTrials,1);
    sacSumLarge = NaN(numTrials,1);
    meanAmpLarge = NaN(numTrials,1);
    
    % flag the trials that had blinks
    flagged = zeros(numTrials,1);
    idx = find((errorsMicroSaccade_patients(:,3) == currentSubject));
    flagged(errorsMicroSaccade_patients(idx,4)) = 1;
        
    % loop over trials
    for i = 1:numTrials
        if flagged(i)
            continue
        end
        if ~isempty(block(i).trial) 
            % separate into micro-saccades and normal saccades done during
            % fixaton
            if isempty(block(i).trial.saccades.X.fixOnsets) && isempty(block(i).trial.saccades.Y.fixOnsets)
                % read out saccade parameters
                numberMicro(i,1) = block(i).trial.microSaccades.number;
                if block(i).trial.microSaccades.number == 0
                    sacSumMicro(i,1) = 0;
                    meanAmpMicro(i,1) = 0;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                else
                    sacSumMicro(i,1) = block(i).trial.microSaccades.sum;
                    meanAmpMicro(i,1) = block(i).trial.microSaccades.meanAmplitude;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                end
            else
                microIdx = block(i).trial.microSaccades.amplitudes < 3;
                numberMicro(i,1) = sum(microIdx);
                sacSumMicro(i,1) = sum(block(i).trial.microSaccades.amplitudes(microIdx));
                meanAmpMicro(i,1) = mean(block(i).trial.microSaccades.amplitudes(microIdx));
                numberLarge(i,1) = block(i).trial.microSaccades.number - numberMicro(i,1);
                sacSumLarge(i,1) = block(i).trial.microSaccades.sum - sacSumMicro(i,1);
                meanAmpLarge(i,1) = sacSumLarge(i,1)/numberLarge(i,1);
            end
        else
            numberMicro(i,1) = NaN;
            sacSumMicro(i,1) = NaN;
            meanAmpMicro(i,1) = NaN;
            numberLarge(i,1) = NaN;
            sacSumLarge(i,1) = NaN;
            meanAmpLarge(i,1) = NaN;
        end
    end
        
    currentPatient_pro = [flagged patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];
    
    patients_pro = [patients_pro; currentPatient_pro];
    
    clear block patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge flagged
end
cd(analysisPath); 
%% zScore patients data
patients_pro = patients_pro(patients_pro(:,1) == 0, :);

numberMicro = patients_pro(:,5);
nomIdx = isnan(numberMicro);
zScore_nom = zscore(numberMicro(~isnan(numberMicro)));
numberMicro((zScore_nom > 3 | zScore_nom < -3)) = NaN;
numberMicro(nomIdx) = NaN;

sacSumMicro = patients_pro(:,6);
msumIdx = isnan(sacSumMicro);
zScore_msum = zscore(sacSumMicro(~isnan(sacSumMicro)));
sacSumMicro((zScore_msum > 3 | zScore_msum < -3)) = NaN;
sacSumMicro(msumIdx) = NaN;

meanAmpMicro = patients_pro(:,7);
mampIdx = isnan(meanAmpMicro);
zScore_namp = zscore(meanAmpMicro(~isnan(meanAmpMicro)));
meanAmpMicro((zScore_namp > 3 | zScore_namp < -3)) = NaN;
meanAmpMicro(mampIdx) = NaN;

numberLarge = patients_pro(:,8);
nolIdx = isnan(numberLarge);
zScore_nol = zscore(numberLarge(~isnan(numberLarge)));
numberLarge((zScore_nol > 3 | zScore_nol < -3)) = NaN;
numberLarge(nolIdx) = NaN;

sacSumLarge = patients_pro(:,9);
lsumIdx = isnan(sacSumLarge);
zScore_lsum = zscore(sacSumLarge(~isnan(sacSumLarge)));
sacSumLarge((zScore_lsum > 3 | zScore_lsum < -3)) = NaN;
sacSumLarge(lsumIdx) = NaN;

meanAmpLarge = patients_pro(:,10);
lampIdx = isnan(meanAmpLarge);
zScore_lamp = zscore(meanAmpLarge(~isnan(meanAmpLarge)));
meanAmpLarge((zScore_lamp > 3 | zScore_lamp < -3)) = NaN;
meanAmpLarge(lampIdx) = NaN;

patients_pro = [patients_pro(:,2:4) numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];

clear numberMicro nomIdx zScore_nom sacSumMicro msumIdx zScore_msum
clear meanAmpMicro mampIdx zScore_namp numberLarge nolIdx zScore_nol
clear sacSumLarge lsumIdx zScore_lsum meanAmpLarge lampIdx zScore_lamp
%%
% initiate result parameters
resultPath = fullfile(pwd, 'antiSaccade\patients'); 
allResults = dir(resultPath);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
patients_anti = [];

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
    task = 2*ones(numTrials,1);
    % initiate saccade parameters
    numberMicro = NaN(numTrials,1);
    sacSumMicro = NaN(numTrials,1);
    meanAmpMicro = NaN(numTrials,1);
    numberLarge = NaN(numTrials,1);
    sacSumLarge = NaN(numTrials,1);
    meanAmpLarge = NaN(numTrials,1);
    
    % flag the trials that had blinks
    flagged = zeros(numTrials,1);
    idx = find((errorsMicroSaccade_patients(:,3) == currentSubject));
    flagged(errorsMicroSaccade_patients(idx,4)) = 1;
        
    % loop over trials
    for i = 1:numTrials
        if flagged(i)
            continue
        end
        if ~isempty(block(i).trial) 
            % separate into micro-saccades and normal saccades done during
            % fixaton
            if isempty(block(i).trial.saccades.X.fixOnsets) && isempty(block(i).trial.saccades.Y.fixOnsets)
                % read out saccade parameters
                numberMicro(i,1) = block(i).trial.microSaccades.number;
                if block(i).trial.microSaccades.number == 0
                    sacSumMicro(i,1) = 0;
                    meanAmpMicro(i,1) = 0;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                else
                    sacSumMicro(i,1) = block(i).trial.microSaccades.sum;
                    meanAmpMicro(i,1) = block(i).trial.microSaccades.meanAmplitude;
                    numberLarge(i,1) = 0;
                    sacSumLarge(i,1) = 0;
                    meanAmpLarge(i,1) = 0;
                end
            else
                microIdx = block(i).trial.microSaccades.amplitudes < 3;
                numberMicro(i,1) = sum(microIdx);
                sacSumMicro(i,1) = sum(block(i).trial.microSaccades.amplitudes(microIdx));
                meanAmpMicro(i,1) = mean(block(i).trial.microSaccades.amplitudes(microIdx));
                numberLarge(i,1) = block(i).trial.microSaccades.number - numberMicro(i,1);
                sacSumLarge(i,1) = block(i).trial.microSaccades.sum - sacSumMicro(i,1);
                meanAmpLarge(i,1) = sacSumLarge(i,1)/numberLarge(i,1);
            end
        else
            numberMicro(i,1) = NaN;
            sacSumMicro(i,1) = NaN;
            meanAmpMicro(i,1) = NaN;
            numberLarge(i,1) = NaN;
            sacSumLarge(i,1) = NaN;
            meanAmpLarge(i,1) = NaN;
        end
    end
        
    currentPatient_anti = [flagged patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];
    
    patients_anti = [patients_anti; currentPatient_anti];
    
    clear block patient subject task numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge flagged
end
cd(analysisPath);
%% zScore patient data
patients_anti = patients_anti(patients_anti(:,1) == 0, :);

numberMicro = patients_anti(:,5);
nomIdx = isnan(numberMicro);
zScore_nom = zscore(numberMicro(~isnan(numberMicro)));
numberMicro((zScore_nom > 3 | zScore_nom < -3)) = NaN;
numberMicro(nomIdx) = NaN;

sacSumMicro = patients_anti(:,6);
msumIdx = isnan(sacSumMicro);
zScore_msum = zscore(sacSumMicro(~isnan(sacSumMicro)));
sacSumMicro((zScore_msum > 3 | zScore_msum < -3)) = NaN;
sacSumMicro(msumIdx) = NaN;

meanAmpMicro = patients_anti(:,7);
mampIdx = isnan(meanAmpMicro);
zScore_namp = zscore(meanAmpMicro(~isnan(meanAmpMicro)));
meanAmpMicro((zScore_namp > 3 | zScore_namp < -3)) = NaN;
meanAmpMicro(mampIdx) = NaN;

numberLarge = patients_anti(:,8);
nolIdx = isnan(numberLarge);
zScore_nol = zscore(numberLarge(~isnan(numberLarge)));
numberLarge((zScore_nol > 3 | zScore_nol < -3)) = NaN;
numberLarge(nolIdx) = NaN;

sacSumLarge = patients_anti(:,9);
lsumIdx = isnan(sacSumLarge);
zScore_lsum = zscore(sacSumLarge(~isnan(sacSumLarge)));
sacSumLarge((zScore_lsum > 3 | zScore_lsum < -3)) = NaN;
sacSumLarge(lsumIdx) = NaN;

meanAmpLarge = patients_anti(:,10);
lampIdx = isnan(meanAmpLarge);
zScore_lamp = zscore(meanAmpLarge(~isnan(meanAmpLarge)));
meanAmpLarge((zScore_lamp > 3 | zScore_lamp < -3)) = NaN;
meanAmpLarge(lampIdx) = NaN;

patients_anti = [patients_anti(:,2:4) numberMicro sacSumMicro meanAmpMicro numberLarge sacSumLarge meanAmpLarge];

clear numberMicro nomIdx zScore_nom sacSumMicro msumIdx zScore_msum
clear meanAmpMicro mampIdx zScore_namp numberLarge nolIdx zScore_nol
clear sacSumLarge lsumIdx zScore_lsum meanAmpLarge lampIdx zScore_lamp

patients = [patients_pro; patients_anti];
%% Now combine the 2 results and save data
cd(savePath)
microSaccadeResults = [controls; patients];
save('microSaccadeResults', 'microSaccadeResults')
csvwrite('microSaccadeResults.csv', microSaccadeResults)
cd(analysisPath)
