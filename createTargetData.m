% function to match target to eye data
% Since the target data and the eye data are recorded at different frames
% we need to extrapolate target data
function target = createTargetData(targetPosition, trialNo, eyeData)

sampleRate = evalin('base', 'sampleRate');

currentTrial = trialNo(end-4);
name = {['trial' currentTrial]};
currentTarget = targetPosition.(name{1});
onset = find(eyeData.timeStamp == currentTarget(1,1));
offset = find(eyeData.timeStamp == currentTarget(end,1));
targetLength = offset-onset;
trialLength = size(eyeData.X_filt,1);

target.onset = onset;
target.offset = offset;

% generate target data in the same time framze as eye movement data
frequency = targetPosition.frequency(str2double(trialNo(end-4)));
amplitude = 400; %in pixels
t = 0:1/sampleRate:targetLength/sampleRate-0.001;
if sum(currentTarget(:,2)) ~= 0
    x = amplitude*sin(2*pi*frequency*t);
    target.Xpixel = x';
    target.Ypixel = zeros(targetLength,1);
else
    target.Xpixel = zeros(targetLength,1);
    y = amplitude*sin(2*pi*frequency*t);
    target.Ypixel = y';
end
targetXY = pixels2degrees(target.Xpixel, target.Ypixel);

target.Xdeg = [zeros(onset,1); targetXY.degX; zeros(trialLength-offset,1)];
target.Ydeg = [zeros(onset,1); targetXY.degY; zeros(trialLength-offset,1)];

target.Xvel = [zeros(onset,1); diff(targetXY.degX)*sampleRate; zeros(trialLength-offset+1,1)];
target.Yvel = [zeros(onset,1); diff(targetXY.degY)*sampleRate; zeros(trialLength-offset+1,1)];

end