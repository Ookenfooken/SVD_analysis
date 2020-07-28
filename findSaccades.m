function [onsets, offsets, isMax] = findSaccades(stim_onset, stim_offset, speed, acceleration, threshold, stimulusSpeed)
%% set up
startFrame = stim_onset;
endFrame = min([stim_offset length(speed)]);

upperThreshold = stimulusSpeed + threshold;
lowerThreshold = stimulusSpeed - threshold;

speed = speed(startFrame:endFrame);
acceleration = acceleration(startFrame:endFrame);

%% speed
middle = speed<lowerThreshold | speed>upperThreshold;

predecessor = [middle(2:end); 0];
successor = [0; middle(1:end-1)];
relevantFrames = middle+predecessor+successor == 3;

% uncomment if you want to use 5 instead of 3 ceonsecutive frames
%****
% prepredecessor = [predecessor(2:end); 0];
% sucsuccessor = [0; successor(1:end-1)];
% relevantFrames = middle+predecessor+successor+sucsuccessor+prepredecessor == 5;
% %****

relevantFramesDiff = diff(relevantFrames);
relevantFramesOnsets = [relevantFramesDiff; 0];
relevantFramesOffsets = [0; relevantFramesDiff];

speedOnsets = relevantFramesOnsets == 1;
speedOffsets = relevantFramesOffsets == -1;

speedOnsets = find(speedOnsets);
speedOffsets = find(speedOffsets);

%% acceleration
middle = acceleration/1000;
predecessor = [middle(2:end); 0];
signSwitches = find((middle .* predecessor) < 0)+1;

onsets = NaN(1,length(speedOnsets));
offsets = NaN(1,length(speedOnsets));
isMax = NaN(1,length(speedOnsets));

%% find onsets and offsets
onsetLength = min([length(speedOnsets) length(speedOffsets)]);
for i = 1:onsetLength
    
    % make sure, that there is always both, an onset and an offset
    % otherwise, skip this saccade
    if speedOnsets(i) < min(signSwitches) || speedOffsets(i) > max(signSwitches) 
        continue
    end
    
    onsets(i) = max(signSwitches(signSwitches <= speedOnsets(i)));
    offsets(i) = min(signSwitches(signSwitches >= speedOffsets(i))-1); %the -1 is a subjective adjustment
    isMax(i) = speed(speedOnsets(i)) > 0;
    
end

%% trim to delete NaNs
onsets = onsets(~isnan(onsets))+startFrame;
offsets = offsets(~isnan(offsets))+startFrame;
isMax = isMax(~isnan(isMax));
isMax = logical(isMax);

%% make sure that saccades don't overlap. This is, find overlapping saccades and delete intermediate onset/offset
earlyOnsets = find(diff(reshape([onsets;offsets],1,[]))<0)/2+1;
previousOffsets = earlyOnsets - 1;
onsets(earlyOnsets) = [];
offsets(previousOffsets) = [];
isMax(earlyOnsets) = [];



end