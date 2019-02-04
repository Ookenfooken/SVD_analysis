cd(currentSubjectPath);
if strcmp(choice, 'controls')
    patient = 0;
else
    patient = 1;
end

errorType = 'signal loss';
if strcmp(name, 'minuteSaccade')
    testType = 3;
elseif strcmp(name, 'proSaccade')
    testType = 1;
elseif strcmp(name, 'antiSaccade')
    testType = 2;
end

fid = fopen([currentSubject 'errors.txt'],'a');
errorName = [errorType ' ' num2str(trial.number)];
fprintf(fid, char(errorName), 'char');

fclose(fid);

cd(analysisPath);

currentError = [patient, testType, str2double(currentSubject(2:3)), trial.number];
errors = [errors; currentError];