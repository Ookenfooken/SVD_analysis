% script to aggregate eye movement battery data for different tests
% define data home base
analysisPath = pwd;
dataPath = fullfile(pwd, 'resultFiles');

%% start with pro-saccade test
% load data
cd(dataPath)
load('proSaccadeResults')
% determine number of subjects
subjectList = unique(proSaccadeResults(:,2));
numSubs = length(subjectList);
numVariables = size(proSaccadeResults,2);
% open matrix that we will write aggregated results in
proSaccades_agg = NaN(numSubs, numVariables+1);
% loop over each subject to find mean value per category
for i = 1:numSubs
    currentSubject = proSaccadeResults(proSaccadeResults(:,2) == subjectList(i), :);
    percent_incorrect = length(currentSubject(currentSubject(:,3) == 0, 3))/length(currentSubject);
    percent_com = length(currentSubject(currentSubject(:,3) == 2, 3))/length(currentSubject);
    proSaccades_agg(i,:) = [currentSubject(1,1) subjectList(i) percent_incorrect percent_com nanmean(currentSubject(:,4:end))];
end
clear currentSubject percent_com percent_incorrect

csvwrite('proSaccadesAggregated.csv', proSaccades_agg)
cd(analysisPath)

%% anti-saccade test next
% load data
cd(dataPath)
load('antiSaccadeResults')
% determine number of subjects
subjectList = unique(antiSaccadeResults(:,2));
numSubs = length(subjectList);
numVariables = size(antiSaccadeResults,2);
% open matrix that we will write aggregated results in
antiSaccades_agg = NaN(numSubs, numVariables+1);
% loop over each subject to find mean value per category
for i = 1:numSubs
    currentSubject = antiSaccadeResults(antiSaccadeResults(:,2) == subjectList(i), :);
    percent_incorrect = length(currentSubject(currentSubject(:,3) == 0, 3))/length(currentSubject);
    percent_com = length(currentSubject(currentSubject(:,3) == 2, 3))/length(currentSubject);
    antiSaccades_agg(i,:) = [currentSubject(1,1) subjectList(i) percent_incorrect percent_com nanmean(currentSubject(:,4:end))];
end
clear currentSubject percent_com percent_incorrect

csvwrite('antiSaccadesAggregated.csv', antiSaccades_agg)
cd(analysisPath)

%% finally microsaccades
% load data
cd(dataPath)
load('microSaccadeResults')
% determine number of subjects
subjectList = unique(microSaccadeResults(:,2));
numSubs = length(subjectList);
numVariables = size(microSaccadeResults,2);
% open matrix that we will write aggregated results in
microSaccades_agg = NaN(numSubs*2, numVariables);
% loop over each subject to find mean value per category
count = 1;
for i = 1:2:numSubs*2-1
    currentSubject = microSaccadeResults(microSaccadeResults(:,2) == subjectList(count), :);
    proSaccades = nanmean(currentSubject(currentSubject(:,3) == 1, 4:end));
    antiSaccades = nanmean(currentSubject(currentSubject(:,3) == 2, 4:end));
    microSaccades_agg(i,:) = [currentSubject(1,1) subjectList(count) 1 proSaccades];
    microSaccades_agg(i+1,:) = [currentSubject(1,1) subjectList(count) 2 antiSaccades];
    count = count + 1;
end
clear currentSubject proSaccades antiSaccades

csvwrite('microSaccadesAggregated.csv', microSaccades_agg)
cd(analysisPath)