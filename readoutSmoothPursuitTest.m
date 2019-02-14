%% define data home base
analysisPath = pwd;
savePath = fullfile(pwd, 'resultFiles');
% currently no error list
%errorList = load('errors_pursuit.csv'.csv');

%% Read out controls 
% initiate result parameters
resultPath = fullfile(pwd, 'smoothPursuit\controls'); 
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
    currentSubject = str2double(selectedResult{j-2}(2:4));
    patient = zeros(numTrials,1);
    subject = currentSubject*ones(numTrials,1);
    % initiate target measures
    trackDirection = NaN(numTrials,1);
    targetSpeed = NaN(numTrials,1);
    % initiate eye movement measures
    gain = NaN(numTrials,1);
    positionError = NaN(numTrials,1);
    velocityError = NaN(numTrials,1);
    blinkNumber = NaN(numTrials,1);
    sacNumber = NaN(numTrials,1);
    sacRate = NaN(numTrials,1);
    cumulative = NaN(numTrials,1);
    eyeTargetMax = NaN(numTrials,1);
    eyeTargetMin = NaN(numTrials,1);
    eyeLag = NaN(numTrials,1);
    
    % loop over trials
    for i = 1:numTrials
        if isempty(block(i).trial)
            continue
        else
            if sum(block(i).trial.target.Y) == 0
                trackDirection(i,1) = 1;
                eyeTargetMax(i,1) = nanmean(block(i).trial.X_noSac(block(i).trial.target.maxima) - ...
                                         block(i).trial.target.X(block(i).trial.target.maxima));
                eyeTargetMin(i,1) = nanmean(block(i).trial.target.X(block(i).trial.target.minima) - ...
                                         block(i).trial.X_noSac(block(i).trial.target.minima));
                extrema = [block(i).trial.target.maxima; block(i).trial.target.minima];
                eyeLag(i,1) = mean(abs(block(i).trial.eye.X_filt(extrema))-abs(block(i).trial.target.X(extrema)));
                clear extrema
            elseif sum(block(i).trial.target.X) == 0
                trackDirection(i,1) = 2;
                eyeTargetMax(i,1) = nanmean(block(i).trial.Y_noSac(block(i).trial.target.maxima) - ...
                                         block(i).trial.target.Y(block(i).trial.target.maxima));
                eyeTargetMin(i,1) = nanmean(block(i).trial.target.Y(block(i).trial.target.minima) - ...
                                         block(i).trial.Y_noSac(block(i).trial.target.minima));
                extrema = [block(i).trial.target.maxima; block(i).trial.target.minima];
                eyeLag(i,1) = mean(abs(block(i).trial.eye.Y_filt(extrema))-abs(block(i).trial.target.Y(extrema)));
                clear extrema
            end
            targetSpeed(i,1) = block(i).trial.target.speed;
            gain(i,1) = block(i).trial.pursuit.gain;
            positionError(i,1) = block(i).trial.pursuit.positionError;
            velocityError(i,1) = block(i).trial.pursuit.velocityError;
            count = 0;
            blinkOnsets = sort(block(i).trial.saccades.blinkOnsets);
            blinkOffsets = sort(block(i).trial.saccades.blinkOffsets);
            for k = 2:length(blinkOnsets)
                if blinkOnsets(k) > blinkOffsets(k-1)
                    count = count + 1;
                end
            end
            blinkNumber(i,1) = count;
            sacNumber(i,1) = block(i).trial.saccades.number;
            sacRate(i,1) = block(i).trial.saccades.number/round(block(i).trial.length/1000);
            cumulative(i,1) = block(i).trial.saccades.sacSum;
            clear blinkOnsets blinkOffsets
        end        
    end
    
    currentControl = [patient subject trackDirection targetSpeed gain positionError velocityError...
                      blinkNumber sacNumber sacRate cumulative eyeTargetMax eyeTargetMin eyeLag];
                  
    controls = [controls; currentControl];
    
    clear patient subject trackDirection targetSpeed gain positionError velocityError
    clear blinkNumber sacNumber sacRate cumulative eyeTargetMax eyeTargetMin eyeLag
end

cd(analysisPath);

%% Read out controls 
% initiate result parameters
resultPath = fullfile(pwd, 'smoothPursuit\patients'); 
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
    currentSubject = str2double(selectedResult{j-2}(2:4));
    patient = zeros(numTrials,1);
    subject = currentSubject*ones(numTrials,1);
    % initiate target measures
    trackDirection = NaN(numTrials,1);
    targetSpeed = NaN(numTrials,1);
    % initiate eye movement measures
    gain = NaN(numTrials,1);
    positionError = NaN(numTrials,1);
    velocityError = NaN(numTrials,1);
    blinkNumber = NaN(numTrials,1);
    sacNumber = NaN(numTrials,1);
    sacRate = NaN(numTrials,1);
    cumulative = NaN(numTrials,1);
    eyeTargetMax = NaN(numTrials,1);
    eyeTargetMin = NaN(numTrials,1);
    eyeLag = NaN(numTrials,1);
    
    % loop over trials
    for i = 1:numTrials
        if isempty(block(i).trial)
            continue
        else
            if sum(block(i).trial.target.Y) == 0
                trackDirection(i,1) = 1;
                eyeTargetMax(i,1) = nanmean(block(i).trial.X_noSac(block(i).trial.target.maxima) - ...
                                         block(i).trial.target.X(block(i).trial.target.maxima));
                eyeTargetMin(i,1) = nanmean(block(i).trial.target.X(block(i).trial.target.minima) - ...
                                         block(i).trial.X_noSac(block(i).trial.target.minima));
                extrema = [block(i).trial.target.maxima; block(i).trial.target.minima];
                eyeLag(i,1) = mean(abs(block(i).trial.eye.X_filt(extrema))-abs(block(i).trial.target.X(extrema)));
                clear extrema
            elseif sum(block(i).trial.target.X) == 0
                trackDirection(i,1) = 2;
                eyeTargetMax(i,1) = nanmean(block(i).trial.Y_noSac(block(i).trial.target.maxima) - ...
                                         block(i).trial.target.Y(block(i).trial.target.maxima));
                eyeTargetMin(i,1) = nanmean(block(i).trial.target.Y(block(i).trial.target.minima) - ...
                                         block(i).trial.Y_noSac(block(i).trial.target.minima));
                extrema = [block(i).trial.target.maxima; block(i).trial.target.minima];
                eyeLag(i,1) = mean(abs(block(i).trial.eye.Y_filt(extrema))-abs(block(i).trial.target.Y(extrema)));
                clear extrema
            end
            targetSpeed(i,1) = block(i).trial.target.speed;
            gain(i,1) = block(i).trial.pursuit.gain;
            positionError(i,1) = block(i).trial.pursuit.positionError;
            velocityError(i,1) = block(i).trial.pursuit.velocityError;
            count = 0;
            blinkOnsets = sort(block(i).trial.saccades.blinkOnsets);
            blinkOffsets = sort(block(i).trial.saccades.blinkOffsets);
            for k = 2:length(blinkOnsets)
                if blinkOnsets(k) > blinkOffsets(k-1)
                    count = count + 1;
                end
            end
            blinkNumber(i,1) = count;
            sacNumber(i,1) = block(i).trial.saccades.number;
            sacRate(i,1) = block(i).trial.saccades.number/round(block(i).trial.length/1000);
            cumulative(i,1) = block(i).trial.saccades.sacSum;
            clear blinkOnsets blinkOffsets
        end        
    end
    
    currentControl = [patient subject trackDirection targetSpeed gain positionError velocityError...
                      blinkNumber sacNumber sacRate cumulative eyeTargetMax eyeTargetMin eyeLag];
                  
    patients = [patients; currentControl];
    
    clear patient subject trackDirection targetSpeed gain positionError velocityError
    clear blinkNumber sacNumber sacRate cumulative eyeTargetMax eyeTargetMin eyeLag
end

cd(analysisPath);

%% Now combine the 2 results and save data
cd(savePath)
smoothPursuitResults = [controls; patients];
save('smoothPursuitResults', 'smoothPursuitResults')
csvwrite('smoothPursuitResults.csv', smoothPursuitResults)
cd(analysisPath)