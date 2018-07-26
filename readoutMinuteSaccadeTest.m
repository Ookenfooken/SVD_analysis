%% define data home base
analysisPath = pwd;
savePath = fullfile(pwd, 'resultFiles');

%% Read out controls 
% initiate result parameters
resultPath = fullfile(pwd, 'minuteSaccade\controls'); 
allResults = dir(resultPath);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
controls = [];

% loop over all control participants
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
    noGoal = NaN(numTrials,1);
    goalAccuracy = NaN(numTrials,1);
    noCorrective = NaN(numTrials,1);
    correctiveAmplitude = NaN(numTrials,1);
    correctiveAccuracy = NaN(numTrials,1);
    noBlinks = NaN(numTrials,1);
    
    % loop over trials
    for i = 1:numTrials
        % read out saccade parameters
        noGoal(i,1) = block(i).trial.saccades.numSaccGoal;
        goalAccuracy(i,1) = nanmean(block(i).trial.saccades.accuraciesGoal);
        noCorrective(i,1) = block(i).trial.saccades.numCorrective;
        correctiveAccuracy(i,1) = nanmean(block(i).trial.saccades.accuraciesCorrective);
        correctiveAmplitude(i,1) = nanmean(block(i).trial.saccades.amplitudesCorrective);       
        noBlinks(i,1) = block(i).trial.saccades.numBlinks;
    end
    
    currentControl = [patient subject noGoal goalAccuracy noCorrective correctiveAccuracy correctiveAmplitude noBlinks];
    
    controls = [controls; currentControl];
    
    clear block patient subject noGoal goalAccuracy noBlinks noCorrective correctiveAccuracy noBlinks
end

cd(analysisPath);

clear resultPath allResults numResults selectedResult 

%% Read out patients
% initiate result parameters
resultPath = fullfile(pwd, 'minuteSaccade\patients'); 
allResults = dir(resultPath);
cd(resultPath);
numResults = length(allResults)-2;
selectedResult = cell(numResults,1);
patients = [];

% loop over all patient participants
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
    noGoal = NaN(numTrials,1);
    goalAccuracy = NaN(numTrials,1);
    noCorrective = NaN(numTrials,1);
    correctiveAmplitude = NaN(numTrials,1);
    correctiveAccuracy = NaN(numTrials,1);
    noBlinks = NaN(numTrials,1);
    
    % loop over trials
    for i = 1:numTrials
        % read out saccade parameters
        noGoal(i,1) = block(i).trial.saccades.numSaccGoal;
        goalAccuracy(i,1) = nanmean(block(i).trial.saccades.accuraciesGoal);
        noCorrective(i,1) = block(i).trial.saccades.numCorrective;
        correctiveAccuracy(i,1) = nanmean(block(i).trial.saccades.accuraciesCorrective);
        correctiveAmplitude(i,1) = nanmean(block(i).trial.saccades.amplitudesCorrective);       
        noBlinks(i,1) = block(i).trial.saccades.numBlinks;
    end
    
    currentPatient = [patient subject noGoal goalAccuracy noCorrective correctiveAccuracy correctiveAmplitude noBlinks];
    
    patients = [patients; currentPatient];
    
    clear block patient subject noGoal goalAccuracy noBlinks noCorrective correctiveAccuracy noBlinks
    
end

cd(analysisPath);


clear resultPath allResults numResults selectedResult 

%% Now combine the 2 results and save data
cd(savePath)
minuteSaccadeResults = [controls; patients];
save('minuteSaccadeResults', 'minuteSaccadeResults')
csvwrite('minuteSaccadeResults.csv', minuteSaccadeResults)
cd(analysisPath)