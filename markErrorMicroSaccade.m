cd(currentSubjectPath);
if strcmp(choice, 'controls')
    patient = 0;
else
    patient = 1;
end
errorType = 'blink in fixation';
if strcmp(name, 'minuteSaccade')
    testType = 3;
elseif strcmp(name, 'proSaccade')
    testType = 1;
elseif strcmp(name, 'antiSaccade')
    testType = 2;
end

fid = fopen([currentSubject 'errors.txt'],'a');

fprintf(fid, char(errorType), 'char');

fclose(fid);

cd(analysisPath);

currentError = [patient, testType, str2double(currentSubject(2:4)), trial.number];
errorsMS = [errorsMS; currentError];