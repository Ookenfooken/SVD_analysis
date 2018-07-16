%% define data home base
analysisPath = pwd;

%% Read out controls 
% initiate result parameters
resultPath = fullfile(pwd, 'minuteSaccade\controls'); 
allResults = dir(resultPath);
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
    patient = zeros(numTrials,1);
    subject = (j-2)*ones(numTrials,1);
    % initiate saccade parameters
    meanAmplitude = NaN(numTrials,1);
    cumulative = NaN(numTrials,1);
    number = NaN(numTrials,1);
    accuracy = NaN(numTrials,1);
    velocity = NaN(numTrials,1);
    numberDiff = NaN(numTrials,1);
    
    % loop over trials
    for i = 1:numTrials
        % read out saccade parameters
        meanAmplitude(i,1) = block(i).trial.saccades.meanAmplitude;
        cumulative(i,1) = sum(block(i).trial.saccades.amplitudes);
        number(i,1) = length(block(i).trial.saccades.onsets);
        accuracy(i,1) = block(i).trial.saccades.accuracy;
        velocity(i,1) = block(i).trial.saccades.velocities;
        numberDiff(i,1) = sum(block(i).trial.saccades.onsets <= 3000) - ...
            sum(block(i).trial.saccades.onsets > 3000 & block(i).trial.saccades.onsets <= 6000);
    end
    
    currentControl = [patient subject meanAmplitude cumulative number accuracy velocity numberDiff];
    
    controls = [controls; currentControl];
    
    clear block patient subject task meanAmplitude cumulative number accuracy velocity numberDiff
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

% loop over all participants
for j = 3:length(allResults)    
    % load data
    selectedResult{j-2} = allResults(j).name;    
    block = load(selectedResult{j-2} );
    block = block.analysisResults;
    numTrials = length(block);    
    
    % initiate conditions and experimental factors
    patient = ones(numTrials,1);
    subject = (j-2)*ones(numTrials,1);
    % initiate saccade parameters
    meanAmplitude = NaN(numTrials,1);
    cumulative = NaN(numTrials,1);
    number = NaN(numTrials,1);
    accuracy = NaN(numTrials,1);
    velocity = NaN(numTrials,1);
    numberDiff = NaN(numTrials,1);
    
    % loop over trials
    for i = 1:numTrials
        % read out saccade parameters
        meanAmplitude(i,1) = block(i).trial.saccades.meanAmplitude;
        cumulative(i,1) = sum(block(i).trial.saccades.amplitudes);
        number(i,1) = length(block(i).trial.saccades.onsets);
        accuracy(i,1) = block(i).trial.saccades.accuracy;
        velocity(i,1) = block(i).trial.saccades.velocities;
        numberDiff(i,1) = sum(block(i).trial.saccades.onsets <= 3000) - ...
            sum(block(i).trial.saccades.onsets > 3000 & block(i).trial.saccades.onsets <= 6000);
    end
    
    currentPatient = [patient subject meanAmplitude cumulative number accuracy velocity numberDiff];
    
    patients = [patients; currentPatient];
    
    clear block patient subject task meanAmplitude cumulative number accuracy velocity numberDiff
    
end

cd(analysisPath);


clear resultPath allResults numResults selectedResult 

%% Now combine the 2 results and save data

minuteSaccadeResults = [controls; patients];
save('minuteSaccadeResults', 'minuteSaccadeResults')
csvwrite('minuteSaccadeResults.csv', minuteSaccadeResults)
