function [trial, saccades] = analyzeSaccades(trial, saccades, name)
    %% store saccades in trial information
    trial.saccades.X.onsets = [];
    trial.saccades.X.offsets = [];
    
    sacX = find(saccades.X.onsets < trial.log.targetOnset);
    if ~isempty(sacX) 
        for i = 1:length(sacX)
            trial.saccades.X.fixOnsets(i,1) = saccades.X.onsets(i);
            trial.saccades.X.fixOffsets(i,1) = saccades.X.offsets(i);
        end
    else
        sacX = 0;
        trial.saccades.X.fixOnsets = [];
        trial.saccades.X.fixOffsets = [];
    end
    cx = 1;
    for i = sacX(end)+1:length(saccades.X.onsets)
        trial.saccades.X.onsets(cx,1) = saccades.X.onsets(i);
        trial.saccades.X.offsets(cx,1) = saccades.X.offsets(i);
        cx = cx+1;
    end
    
    %% same for Y
    trial.saccades.Y.onsets = [];
    trial.saccades.Y.offsets = [];
    
    sacY = find(saccades.Y.onsets < trial.log.targetOnset);
    if ~isempty(sacY) 
        for i = 1:sacY
            trial.saccades.Y.fixOnsets(i,1) = saccades.X.onsets(i);
            trial.saccades.Y.fixOffsets(i,1) = saccades.X.offsets(i);
        end
    else
        sacY = 0;
        trial.saccades.Y.fixOnsets = [];
        trial.saccades.Y.fixOffsets = [];
    end
    cy = 1;
    for i = sacY(end)+1:length(saccades.Y.onsets)
        trial.saccades.Y.onsets(cy,1) = saccades.Y.onsets(i);
        trial.saccades.Y.offsets(cy,1) = saccades.Y.offsets(i);
        cy = cy+1;
    end
    
    %% get onsets and offsets   
    trial.saccades.onsets = [trial.saccades.X.onsets; trial.saccades.Y.onsets];
    trial.saccades.offsets = [trial.saccades.X.offsets; trial.saccades.Y.offsets];

    %% calculate saccade directions
    if ~isempty(trial.saccades.X.onsets)
        for i = 1:length(trial.saccades.X.onsets)
            if trial.eyeX_filt(trial.saccades.X.onsets(i)+ 25) - trial.eyeX_filt(trial.saccades.X.onsets(i)) > 0
                trial.saccades.direction(i,1) = 1;
            else
                trial.saccades.direction(i,1) = 0;
            end
        end
    else
        trial.saccades.direction(i,1) = NaN;
    end
    
    if strcmp(name, 'minuteSaccade')
       % cut out blinks first - use y, because we don't expect any drastic
       % velocity changes in y (movement is in x!)
       blinkIdx = onses(length(trial.saccades.onsets),1);
       for i = 1:length(trial.saccades.onsets)
           if max(abs(trial.eyeDY_filt(trial.saccades.onsets(i):trial.saccades.offsets(i)))) > 25
               blinkIdx(i,1) = 0;
           end
       end
       trial.saccades.onsets = trial.saccades.onsets(blinkIdx);
       trial.saccades.direction = trial.saccades.direction(blinkIdx);
    else
    %% save pre-task fixation duration
    trial.saccades.fixationDuration = trial.log.targetOnset-50;
    %% calculate saccade amplitudes
    % if there are no y-saccades, use x and y position of x saccades
    % otherwise check if y saccades are within x saccades
    xSac = length(trial.saccades.X.onsets);
    ySac = length(trial.saccades.Y.onsets);
    if isempty(ySac)
        trial.saccades.amplitudes = sqrt((trial.eyeX_filt(trial.saccades.X.offsets) - trial.eyeX_filt(trial.saccades.X.onsets)).^2 ...
            + (trial.eyeY_filt(trial.saccades.X.offsets) - trial.eyeY_filt(trial.saccades.X.onsets)).^2);
    elseif isempty(xSac)
        trial.saccades.amplitudes = sqrt((trial.eyeX_filt(trial.saccades.Y.offsets) - trial.eyeX_filt(trial.saccades.Y.onsets)).^2 ...
            + (trial.eyeY_filt(trial.saccades.Y.offsets) - trial.eyeY_filt(trial.saccades.Y.onsets)).^2);
    elseif numel(trial.saccades.onsets) == 0
        trial.saccades.amplitudes = NaN;
    else
        testOnsets = sort(trial.saccades.onsets);
        testOffsets = sort(trial.saccades.offsets);
        count1 = 1;
        tempOnset1 = [];
        tempOffset1 = [];
        count2 = 1;
        tempOnset2 = [];
        tempOffset2 = [];
        
        for i = 1:length(testOnsets)-1
            if testOnsets(i+1)-testOnsets(i) < 20    
                tempOnset1(count1) = testOnsets(i);
                tempOffset1(count1) = testOffsets(i);
                count1 = length(tempOnset1) +1;
            else
                tempOnset2(count2) = testOnsets(i+1);
                tempOffset2(count2) = testOffsets(i+1);
                count2 = length(tempOnset2) +1;
            end
        end
        onsets = unique([tempOnset1 tempOnset2 testOnsets(1)])';
        offsets = unique([tempOffset1 tempOffset2 testOffsets(1)])';
        if length(onsets) ~= length(offsets)
            trial.saccades.amplitudes = sqrt((trial.eyeX_filt(trial.saccades.X.offsets) - trial.eyeX_filt(trial.saccades.X.onsets)).^2 ...
                + (trial.eyeY_filt(trial.saccades.X.offsets) - trial.eyeY_filt(trial.saccades.X.onsets)).^2);
        else
            trial.saccades.amplitudes = sqrt((trial.eyeX_filt(offsets) - trial.eyeX_filt(onsets)).^2 ...
                + (trial.eyeY_filt(offsets) - trial.eyeY_filt(onsets)).^2);
        end
        trial.saccades.onsets = onsets;                     
        trial.saccades.offsets = offsets;
    end
    trial.saccades.number = length(trial.saccades.onsets);
    trial.saccades.sum = sum(trial.saccades.amplitudes);
    if ~isempty(trial.saccades.onsets)
        trial.saccades.latency = trial.saccades.onsets(1) - trial.log.targetOnset;
    else
        trial.saccades.latency = NaN;
    end
        
    %% calculate landing accuracy
    if ~isempty(trial.saccades.X.onsets)
        if strcmp(name, 'minuteSaccade')
            for i = 1:length(trial.saccades.X.onsets)
                if trial.eyeX_filt(trial.saccades.offsets(i)) > 0
                    trial.saccades.accuracies(i,1) = sqrt( (trial.eyeX_filt(trial.saccades.offsets(i)) - trial.log.proSacPosition.deg.degX).^2 + ...
                        (trial.eyeY_filt(trial.saccades.offsets(i)) - trial.log.proSacPosition.deg.degY).^2);
                elseif trial.eyeX_filt(trial.saccades.offsets(i)) < 0
                    trial.saccades.accuracies(i,1) = sqrt( (trial.eyeX_filt(trial.saccades.offsets(i)) - trial.log.antiSacPosition.deg.degX).^2 + ...
                        (trial.eyeY_filt(trial.saccades.offsets(i)) - trial.log.antiSacPosition.deg.degY).^2);
                end
            end
        else
            trial.saccades.accuracies = sqrt( (trial.eyeX_filt(trial.saccades.offsets) - trial.log.proSacPosition.deg.degX).^2 + ...
                (trial.eyeY_filt(trial.saccades.offsets) - trial.log.proSacPosition.deg.degY).^2);
        end
    else
        trial.saccades.accuracies = NaN;
    end
    trial.saccades.accuracy = min(trial.saccades.accuracies);
    interceptIdx = find(trial.saccades.accuracies == min(trial.saccades.accuracies));
    intercept = trial.saccades.offsets(interceptIdx);
    trial.saccades.accuracyX = abs(trial.eyeX_filt(intercept)) - abs(trial.log.proSacPosition.deg.degX);
    trial.saccades.accuracyY = trial.eyeY_filt(intercept) - trial.log.proSacPosition.deg.degY;
    
    if ~isempty(trial.saccades.X.onsets)
        if strcmp(name, 'proSaccade')
            if trial.saccades.direction(1) == trial.log.saccadeTarget && trial.saccades.accuracy < 5
                trial.saccades.targetSelection = 1;
            elseif trial.saccades.direction(1) ~= trial.log.saccadeTarget && trial.saccades.accuracy < 5
                trial.saccades.targetSelection = 2;
            else
                trial.saccades.targetSelection = 0;
            end
        elseif strcmp(name, 'antiSaccade')
            if trial.saccades.direction(1) ~= trial.log.saccadeTarget && trial.saccades.accuracy < 5
                trial.saccades.targetSelection = 1;
            elseif trial.saccades.direction(1) == trial.log.saccadeTarget && trial.saccades.accuracy < 5
                trial.saccades.targetSelection = 2;
            else
                trial.saccades.targetSelection = 0;
            end
        end
    else
        trial.saccades.targetSelection = NaN;
    end
    %% caluclate mean amplitude
    trial.saccades.meanAmplitude = nanmean(trial.saccades.amplitudes);
    if isempty(trial.saccades.meanAmplitude)
        trial.saccades.meanAmplitude = NaN;
    end
    
    %% calculate max amplitude
    trial.saccades.maxAmplitude = max(trial.saccades.amplitudes);
    if isempty(trial.saccades.maxAmplitude)
        trial.saccades.maxAmplitude = NaN;
    end
       
    %% calculate mean duration
    trial.saccades.X.meanDuration = mean(trial.saccades.X.offsets - trial.saccades.X.onsets);
    if isempty(trial.saccades.X.meanDuration)
        trial.saccades.X.meanDuration = NaN;
    end
    trial.saccades.Y.meanDuration = mean(trial.saccades.Y.offsets - trial.saccades.Y.onsets);
    if isempty(trial.saccades.Y.meanDuration)
        trial.saccades.Y.meanDuration = NaN;
    end
    trial.saccades.meanDuration = sqrt(nanmean([trial.saccades.X.meanDuration.^2; trial.saccades.Y.meanDuration.^2]))*sqrt(2);
    
    %% calculate mean and peak velocity
    trial.saccades.X.velocity = [];
    trial.saccades.Y.velocity = [];

    saccadesXXvelocity = NaN(length(trial.saccades.X.onsets),1);
    saccadesXYvelocity = NaN(length(trial.saccades.X.onsets),1);
    for i = 1:length(trial.saccades.X.onsets)
       saccadesXXvelocity(i) = max(abs(trial.eyeDX_filt(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i))));
       saccadesXYvelocity(i) = max(abs(trial.eyeDY_filt(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i))));
    end
    saccadesYYvelocity = NaN(length(trial.saccades.Y.onsets),1);
    saccadesYXvelocity = NaN(length(trial.saccades.Y.onsets),1);
    for i = 1:length(trial.saccades.Y.onsets)
       saccadesYYvelocity(i) = max(abs(trial.eyeDY_filt(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i))));
       saccadesYXvelocity(i) = max(abs(trial.eyeDX_filt(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i))));
    end
    trial.saccades.X.velocity = [saccadesXXvelocity; saccadesYXvelocity];
    trial.saccades.Y.velocity = [saccadesXYvelocity; saccadesYYvelocity];
           
    trial.saccades.velocities = sqrt(trial.saccades.X.velocity.^2 + trial.saccades.Y.velocity.^2);

    end
end
