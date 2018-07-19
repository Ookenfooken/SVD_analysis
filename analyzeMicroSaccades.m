function [trial, saccades] = analyzeMicroSaccades(trial, saccades)
    %% store microSaccades in trial information
    trial.microSaccades.X.onsets = [];
    trial.microSaccades.X.offsets = [];


    for i = 1:length(saccades.X.onsets)
        trial.microSaccades.X.onsets(i,1) = saccades.X.onsets(i);
        trial.microSaccades.X.offsets(i,1) = saccades.X.offsets(i);
    end
    
    %% same for Y
    trial.microSaccades.Y.onsets = [];
    trial.microSaccades.Y.offsets = [];

    for i = 1:length(saccades.Y.onsets)
        trial.microSaccades.Y.onsets(i,1) = saccades.Y.onsets(i);
        trial.microSaccades.Y.offsets(i,1) = saccades.Y.offsets(i);
    end
    
    %% get onsets and offsets   
    trial.microSaccades.X.onsets = sort([trial.saccades.X.fixOnsets; trial.microSaccades.X.onsets]);
    trial.microSaccades.Y.onsets = sort([trial.saccades.Y.fixOnsets; trial.microSaccades.Y.onsets]);
    
    trial.microSaccades.X.offsets = sort([trial.saccades.X.fixOffsets; trial.microSaccades.X.offsets]);
    trial.microSaccades.Y.offsets = sort([trial.saccades.Y.fixOffsets; trial.microSaccades.Y.offsets]);

    %% calculate saccade amplitudes
    % if there are no y-microSaccades, use x and y position of x microSaccades
    % otherwise check if y microSaccades are within x microSaccades
    xSac = length(trial.microSaccades.X.onsets);
    ySac = length(trial.microSaccades.Y.onsets);
    if isempty(ySac)
        trial.microSaccades.amplitudes = sqrt((trial.eyeX_filt(trial.microSaccades.X.offsets) - trial.eyeX_filt(trial.microSaccades.X.onsets)).^2 ...
            + (trial.eyeY_filt(trial.microSaccades.X.offsets) - trial.eyeY_filt(trial.microSaccades.X.onsets)).^2);
    elseif isempty(xSac)
        trial.microSaccades.amplitudes = sqrt((trial.eyeX_filt(trial.microSaccades.Y.offsets) - trial.eyeX_filt(trial.microSaccades.Y.onsets)).^2 ...
            + (trial.eyeY_filt(trial.microSaccades.Y.offsets) - trial.eyeY_filt(trial.microSaccades.Y.onsets)).^2);
    elseif numel(trial.microSaccades.onsets) == 0
        trial.microSaccades.amplitudes = NaN;
    else
        testOnsets = sort(trial.microSaccades.onsets);
        testOffsets = sort(trial.microSaccades.offsets);
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
            trial.microSaccades.amplitudes = sqrt((trial.eyeX_filt(trial.microSaccades.X.offsets) - trial.eyeX_filt(trial.microSaccades.X.onsets)).^2 ...
                + (trial.eyeY_filt(trial.microSaccades.X.offsets) - trial.eyeY_filt(trial.microSaccades.X.onsets)).^2);
        else
            trial.microSaccades.amplitudes = sqrt((trial.eyeX_filt(offsets) - trial.eyeX_filt(onsets)).^2 ...
                + (trial.eyeY_filt(offsets) - trial.eyeY_filt(onsets)).^2);
        end
        trial.microSaccades.onsets = onsets;                     
        trial.microSaccades.offsets = offsets;
    end
    trial.microSaccades.number = length(trial.microSaccades.onsets);
    trial.microSaccades.sum = sum(trial.microSaccades.amplitudes);
    
    %% calculate saccade directions
    if ~isempty(trial.microSaccades.X.onsets)
        for i = 1:length(trial.microSaccades.X.onsets)
            if trial.eyeX_filt(trial.microSaccades.X.onsets(i)+ 25) - trial.eyeX_filt(trial.microSaccades.X.onsets(i)) > 0
                trial.microSaccades.direction(i,1) = 1;
            else
                trial.microSaccades.direction(i,1) = 0;
            end
        end
    else
        trial.microSaccades.direction(i,1) = NaN;
    end
    
    %% caluclate mean amplitude
    trial.microSaccades.meanAmplitude = nanmean(trial.microSaccades.amplitudes);
    if isempty(trial.microSaccades.meanAmplitude)
        trial.microSaccades.meanAmplitude = NaN;
    end
    
    %% calculate max amplitude
    trial.microSaccades.maxAmplitude = max(trial.microSaccades.amplitudes);
    if isempty(trial.microSaccades.maxAmplitude)
        trial.microSaccades.maxAmplitude = NaN;
    end
       
    %% calculate mean duration
    trial.microSaccades.X.meanDuration = mean(trial.microSaccades.X.offsets - trial.microSaccades.X.onsets);
    if isempty(trial.microSaccades.X.meanDuration)
        trial.microSaccades.X.meanDuration = NaN;
    end
    trial.microSaccades.Y.meanDuration = mean(trial.microSaccades.Y.offsets - trial.microSaccades.Y.onsets);
    if isempty(trial.microSaccades.Y.meanDuration)
        trial.microSaccades.Y.meanDuration = NaN;
    end
    trial.microSaccades.meanDuration = sqrt(nanmean([trial.microSaccades.X.meanDuration.^2; trial.microSaccades.Y.meanDuration.^2]))*sqrt(2);
    
    %% calculate mean and peak velocity
    trial.microSaccades.X.velocity = [];
    trial.microSaccades.Y.velocity = [];

    microSaccadesXXvelocity = NaN(length(trial.microSaccades.X.onsets),1);
    microSaccadesXYvelocity = NaN(length(trial.microSaccades.X.onsets),1);
    for i = 1:length(trial.microSaccades.X.onsets)
       microSaccadesXXvelocity(i) = max(abs(trial.eyeDX_filt(trial.microSaccades.X.onsets(i):trial.microSaccades.X.offsets(i))));
       microSaccadesXYvelocity(i) = max(abs(trial.eyeDY_filt(trial.microSaccades.X.onsets(i):trial.microSaccades.X.offsets(i))));
    end
    microSaccadesYYvelocity = NaN(length(trial.microSaccades.Y.onsets),1);
    microSaccadesYXvelocity = NaN(length(trial.microSaccades.Y.onsets),1);
    for i = 1:length(trial.microSaccades.Y.onsets)
       microSaccadesYYvelocity(i) = max(abs(trial.eyeDY_filt(trial.microSaccades.Y.onsets(i):trial.microSaccades.Y.offsets(i))));
       microSaccadesYXvelocity(i) = max(abs(trial.eyeDX_filt(trial.microSaccades.Y.onsets(i):trial.microSaccades.Y.offsets(i))));
    end
    trial.microSaccades.X.velocity = [microSaccadesXXvelocity; microSaccadesYXvelocity];
    trial.microSaccades.Y.velocity = [microSaccadesXYvelocity; microSaccadesYYvelocity];
           
    trial.microSaccades.velocities = unique(sqrt(trial.microSaccades.X.velocity.^2 + trial.microSaccades.Y.velocity.^2));
         
end
