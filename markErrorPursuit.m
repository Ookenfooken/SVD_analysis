cd(currentSubjectPath);
if strcmp(choice, 'controls')
    patient = 0;
else
    patient = 1;
end

prompt = {'Frequency mismatch: 999 _ Discard entire trial: 0 _ Discard cycle: chose 1-10'};
title = 'Pursuit error type';
num_lines = 1;
answer = inputdlg(prompt, title, num_lines);

if str2double(answer{1}) == 999
    type = str2double(answer{1});
    fid = fopen([currentSubject 'errors.txt'],'a');
    errorName = ['Trial ' num2str(trial.number) ' frequency error'];
    fprintf(fid, char(errorName), 'char');
    fclose(fid);
    currentError = [patient, str2double(currentSubject(2:4)), trial.number, type];
elseif length(answer{1}) == 1
    type = str2double(answer{1});
    fid = fopen([currentSubject 'errors.txt'],'a');
    errorName = ['Trial ' num2str(trial.number) ' bad trial'];
    fprintf(fid, char(errorName), 'char');
    fclose(fid);
    currentError = [patient, str2double(currentSubject(2:4)), trial.number, type];
elseif ~str2double(answer{1}) == 999
    separators = strfind(answer{1},',' );
    separators = [separators separators(end)+2];
    numErrors = length(separators);
    for i = 1:numErrors
        currentCycle = answer{1}(separators(i)-1);
        type = str2double(currentCycle);
        fid = fopen([currentSubject 'errors.txt'],'a');
        errorName = ['Trial ' num2str(trial.number) ' cycle ' num2str(currentCycle)];
        fprintf(fid, char(errorName), 'char');
        fclose(fid);
        currentError(i,:) = [patient, str2double(currentSubject(2:4)), trial.number, type];
    end
end

cd(analysisPath);
errors = [errors; currentError];