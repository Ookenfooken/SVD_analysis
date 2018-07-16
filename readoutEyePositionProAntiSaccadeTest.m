analysisPath = pwd;
resultPath = fullfile(pwd, 'antiSaccade\patients'); 
allResults = dir(resultPath);
numSubjects = length(allResults)-2;

cd(resultPath)
counter = 1;

for j = 3:length(allResults)
    
    selectedResult{j-2} = allResults(j).name;
    
    data = load(selectedResult{j-2} );
    block = data.analysisResults(1:end);
    
    numTrials = length(block);
    currentSubject = j-2;
    %if currentSubject == 4 %
    for i = 1:numTrials
        % make sure they made a saccade
        if isempty(block(i).trial.saccades.onsets)
            region = block(i).trial.log.targetOnset:trialStop;
            eyeX(counter, 1:length(region)+2) = NaN(1, length(region) +2);
            eyeY(counter, 1:length(region)+2) = NaN(1, length(region) +2);
        else
            % read out trial type: correct, error, or change of mind
            type = block(i).trial.saccades.targetSelection;
            % read out trial length
            trialStop = min([block(i).trial.saccades.offsets(end) length(block(i).trial.eyeX_filt)]);
            % mark left target position with xFactor = -1
            if block(i).trial.log.saccadeTarget
                xFactor = 1;
            else
                xFactor = -1;
            end
            
            region = block(i).trial.log.targetOnset:trialStop;
            
            posX = block(i).trial.eyeX_filt(region)*xFactor;
            posY = block(i).trial.eyeY_filt(region);
            
            if mean(posX > 2) && type == 1
                eyeX(counter, 1:length(region)+2) = NaN(1, length(region) +2);
                eyeY(counter, 1:length(region)+2) = NaN(1, length(region) +2);
            elseif mean(posX < -2) && type == 0
                eyeX(counter, 1:length(region)+2) = NaN(1, length(region) +2);
                eyeY(counter, 1:length(region)+2) = NaN(1, length(region) +2);
            elseif abs(mean(posY > 2))
                eyeX(counter, 1:length(region)+2) = NaN(1, length(region) +2);
                eyeY(counter, 1:length(region)+2) = NaN(1, length(region) +2);
            else   
                eyeX(counter, 1:length(region)+2) = [currentSubject; type; posX];
                eyeY(counter, 1:length(region)+2) = [currentSubject; type; posY];
            end
            counter = counter + 1;
            clear region posX posY
        end
    end
end    
cd(analysisPath)

%%
% collapse data per condition and each subject
x_correct = eyeX(eyeX(:,2) == 1, :);
x_error = eyeX(eyeX(:,2) == 0, :);
x_com = eyeX(eyeX(:,2) == 2, :);

y_correct = eyeY(eyeY(:,2) == 1, :);
y_error = eyeY(eyeY(:,2) == 0, :);
y_com = eyeY(eyeY(:,2) == 2, :);

% calculate the average x and y position per subject
eyeX_correct = NaN(numSubjects, length(eyeX));
eyeX_error = NaN(numSubjects, length(eyeX));
eyeX_com = NaN(numSubjects, length(eyeX));

eyeY_correct = NaN(numSubjects, length(eyeY));
eyeY_error = NaN(numSubjects, length(eyeY));
eyeY_com = NaN(numSubjects, length(eyeY));

for i = 1:numSubjects
    eyeX_correct(i,:) = nansum(x_correct(x_correct(:,1) == i,:),1)./...
        nansum(x_correct(x_correct(:,1) == i,:)~=0,1);
    eyeX_error(i,:) = nansum(x_error(x_error(:,1) == i,:),1)./...
        nansum(x_error(x_error(:,1) == i,:)~=0,1);
    eyeX_com(i,:) = nansum(x_com(x_com(:,1) == i,:),1)./...
        nansum(x_com(x_com(:,1) == i,:)~=0,1);
    
    eyeY_correct(i,:) = nansum(y_correct(y_correct(:,1) == i,:),1)./...
        nansum(y_correct(y_correct(:,1) == i,:)~=0,1);
    eyeY_error(i,:) = nansum(y_error(y_error(:,1) == i,:),1)./...
        nansum(y_error(y_error(:,1) == i,:)~=0,1);
    eyeY_com(i,:) = nansum(y_com(y_com(:,1) == i,:),1)./...
        nansum(y_com(y_com(:,1) == i,:)~=0,1);
end

% controls.eyePosition.X_correct = nanmean(eyeX_correct(:, 3:end));
% controls.eyePosition.X_error = nanmean(eyeX_error(:, 3:end));
% controls.eyePosition.X_com = nanmean(eyeX_com(:, 3:end));
% 
% controls.eyePosition.Y_correct = nanmean(eyeY_correct(:, 3:end));
% controls.eyePosition.Y_error = nanmean(eyeY_error(:, 3:end));
% controls.eyePosition.Y_com = nanmean(eyeY_com(:, 3:end));
%  
% save('eyePosition_antiSac_controls', 'controls')

patients.eyePosition.X_correct = nanmean(eyeX_correct(:, 3:end));
patients.eyePosition.X_error = nanmean(eyeX_error(:, 3:end));
patients.eyePosition.X_com = nanmean(eyeX_com(:, 3:end));

patients.eyePosition.Y_correct = nanmean(eyeY_correct(:, 3:end));
patients.eyePosition.Y_error = nanmean(eyeY_error(:, 3:end));
patients.eyePosition.Y_com = nanmean(eyeY_com(:, 3:end));

save('eyePosition_antiSac_patients', 'patients')

%%
% controls.eyePosition.X_correct = eyeX_correct(:, 3:end);
% controls.eyePosition.X_error = eyeX_error(:, 3:end);
% controls.eyePosition.X_com = eyeX_com(:, 3:end);
% 
% controls.eyePosition.Y_correct = eyeY_correct(:, 3:end);
% controls.eyePosition.Y_error = eyeY_error(:, 3:end);
% controls.eyePosition.Y_com = eyeY_com(:, 3:end);
% 
% save('eyePosition_antiSac_perControls', 'controls')

% 
% patients.eyePosition.X_correct = eyeX_correct(:, 3:end);
% patients.eyePosition.X_error = eyeX_error(:, 3:end);
% patients.eyePosition.X_com = eyeX_com(:, 3:end);
% 
% patients.eyePosition.Y_correct = eyeY_correct(:, 3:end);
% patients.eyePosition.Y_error = eyeY_error(:, 3:end);
% patients.eyePosition.Y_com = eyeY_com(:, 3:end);
% 
% save('eyePosition_antiSac_perPatients', 'patients')
