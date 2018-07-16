function [eyeData] = processEyeData(eyeData)
% processEyeData (i.e. SOCSCALEXY) recomputes position from pixel to degrees of visual angle, and
% flips traces, if applicable; filtering is also done here

% file checked and corrected on 05/31/11

%% set up filter
sampleRate = 1000;
filtFrequency = sampleRate/2;
filtOrder = 2;
filtCutoffPosition = 15;
filtCutoffVelocity = 30;

[a,b] = butter(filtOrder,filtCutoffPosition/filtFrequency);
[c,d] = butter(filtOrder,filtCutoffVelocity/filtFrequency);

%% position
eyeData.X_filt = filtfilt(a,b,eyeData.X);
eyeData.Y_filt = filtfilt(a,b,eyeData.Y);

%% velocity
eyeData.DX = diff(eyeData.X)*sampleRate;
eyeData.DY = diff(eyeData.Y)*sampleRate;

DX_tmp = diff(eyeData.X_filt)*sampleRate;
eyeData.DX_filt = filtfilt(c,d,DX_tmp);

DY_tmp = diff(eyeData.Y_filt)*sampleRate;
eyeData.DY_filt = filtfilt(c,d,DY_tmp);

%% acceleration
eyeData.DDX = diff(eyeData.DX)*sampleRate;
eyeData.DDY = diff(eyeData.DY)*sampleRate;

DDX_tmp = diff(eyeData.DX_filt)*sampleRate;
eyeData.DDX_filt = filtfilt(c,d,DDX_tmp);

DDY_tmp = diff(eyeData.DY_filt)*sampleRate;
eyeData.DDY_filt = filtfilt(c,d,DDY_tmp);

%% jerk for detecting saccades and quick phases
eyeData.DDDX = diff(eyeData.DDX_filt)*sampleRate;
eyeData.DDDY = diff(eyeData.DDY_filt)*sampleRate;

%% make sure all data series have the same length
eyeData.DX = [eyeData.DX; NaN];
eyeData.DY = [eyeData.DY; NaN];
eyeData.DX_filt = [eyeData.DX_filt; NaN];
eyeData.DY_filt = [eyeData.DY_filt; NaN];

eyeData.DDX = [eyeData.DDX; NaN; NaN];
eyeData.DDY = [eyeData.DDY; NaN; NaN];
eyeData.DDX_filt = [eyeData.DDX_filt; NaN; NaN];
eyeData.DDY_filt = [eyeData.DDY_filt; NaN; NaN];

eyeData.DDDX = [eyeData.DDDX; NaN; NaN; NaN];
eyeData.DDDY = [eyeData.DDDY; NaN; NaN; NaN];

end
