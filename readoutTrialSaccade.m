function [trial] = readoutTrialSaccade(ascFile, eyeData, currentSubject, targetOnset, saccadeTarget)

trial.number = str2double(ascFile(end-5:end-4));
currentTrial = trial.number;
name = evalin('base', 'name');
%% get eyeData for this trial
trial.eyeX = eyeData.X;
trial.eyeY = eyeData.Y;

trial.eyeDX = eyeData.DX;
trial.eyeDY = eyeData.DY;

trial.eyeDDX = eyeData.DDX;
trial.eyeDDY = eyeData.DDY;

trial.eyeX_filt = eyeData.X_filt;
trial.eyeY_filt = eyeData.Y_filt;

trial.eyeDX_filt = eyeData.DX_filt;
trial.eyeDY_filt = eyeData.DY_filt;

trial.eyeDDX_filt = eyeData.DDX_filt;
trial.eyeDDY_filt = eyeData.DDY_filt;

trial.eyeDDDX = eyeData.DDDX;
trial.eyeDDDY = eyeData.DDDY;

if strcmp(name, 'minuteSaccade')
    trial.length = length(eyeData.X_filt);
else
    trial.length = targetOnset(currentTrial) + 1001; %
end
%% read log eyeData    
trial.log.subject = currentSubject;
 if xor(strcmp(name, 'proSaccade'), strcmp(name, 'antiSaccade'))
     trial.log.targetOnset = targetOnset(currentTrial);
%     if targetOnset(currentTrial) > 50
%         trial.log.targetOnset = targetOnset(currentTrial)-50;
%     else
%         trial.log.targetOnset = targetOnset(currentTrial);
%     end
 else
    trial.log.targetOnset = targetOnset;
end

if strcmp(name, 'antiSaccade')
    trial.log.saccadeTarget = saccadeTarget(currentTrial);
    % the targetInfo.dots was different for subject A049 so it's now hard coded
    if saccadeTarget(currentTrial)
        %trial.log.antiSacPosition.pix = [targetInfo.dots(1,2)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,2)];
        trial.log.antiSacPosition.pix = [324 0];
        %trial.log.proSacPosition.pix = [targetInfo.dots(1,3)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,3)];
        trial.log.proSacPosition.pix = [-324 0];
    else
        %trial.log.antiSacPosition.pix = [targetInfo.dots(1,3)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,3)];
        trial.log.antiSacPosition.pix = [-324 0];
        %trial.log.proSacPosition.pix = [targetInfo.dots(1,2)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,2)];
        trial.log.proSacPosition.pix = [324 0];
    end
    trial.log.antiSacPosition.deg = pixels2degrees(trial.log.antiSacPosition.pix(1), trial.log.antiSacPosition.pix(2));
    trial.log.proSacPosition.deg = pixels2degrees(trial.log.proSacPosition.pix(1), trial.log.proSacPosition.pix(2));
elseif strcmp(name, 'proSaccade')
    trial.log.saccadeTarget = saccadeTarget(currentTrial);
    if saccadeTarget(currentTrial)
        %trial.log.proSacPosition.pix = [targetInfo.dots(1,2)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,2)];
        trial.log.proSacPosition.pix = [324 0];
        %trial.log.antiSacPosition.pix = [targetInfo.dots(1,3)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,3)];
        trial.log.antiSacPosition.pix = [-324 0];
    else
        %trial.log.proSacPosition.pix = [targetInfo.dots(1,3)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,3)];
        trial.log.proSacPosition.pix = [-324 0];
        %trial.log.antiSacPosition.pix = [targetInfo.dots(1,2)-(screenResX/2) (screenResY/2)-targetInfo.dots(2,2)];
        trial.log.antiSacPosition.pix = [324 0];
    end
    trial.log.antiSacPosition.deg = pixels2degrees(trial.log.antiSacPosition.pix(1), trial.log.antiSacPosition.pix(2));
    trial.log.proSacPosition.deg = pixels2degrees(trial.log.proSacPosition.pix(1), trial.log.proSacPosition.pix(2));
elseif strcmp(name, 'minuteSaccade')
    trial.log.saccadeTarget = saccadeTarget;
    trial.log.proSacPosition.deg.degX = saccadeTarget.saccadeTarget.right(1);
    trial.log.proSacPosition.deg.degY = saccadeTarget.saccadeTarget.right(2);
    trial.log.antiSacPosition.deg.degX = saccadeTarget.saccadeTarget.left(1);
    trial.log.antiSacPosition.deg.degY = saccadeTarget.saccadeTarget.left(2);
end

trial.log.initialFixation = [0 0];

end