% function to match target to eye data
% Since the target data and the eye data are recorded at different frames
% we need to extrapolate target data
function target = createTargetData(targetPosition, trialNo, eyeData)

sampleRate = evalin('bae', 'sampleRate');

currentTrial = trialNo(end-4);
name = {['trial' currentTrial]};
currentTarget = targetPosition.(name{1});
onset = find(eyeData.timeStamp == currentTarget(1,1));
offset = find(eyeData.timeStamp == currentTarget(end,1));
lengthTarget = offset-onset;

target.onset = onset;
target.offset = offset;

target.Xpixel = interp1(currentTarget(:,1), currentTarget(:,2), ...
    0:1/sampleRate:lengthTarget/sampleRate-0.001, 'spline');
target.Ypixel = interp1(currentTarget(:,1), currentTarget(:,3), ...
    0:1/sampleRate:lengthTarget/sampleRate-0.001, 'spline');

targetXY = pixels2degrees(target.Xpixel, target.Ypixel);
target.Xdeg = targetXY.degX';
target.Ydeg = targetXY.degY';

end