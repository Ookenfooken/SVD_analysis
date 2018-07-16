function selectedSubject = selectSubject(dataPath)

currentLocation = pwd;
cd(dataPath);
% Default folder
folder = pwd;
cd(currentLocation);

% Get Pahntom data file
[selectedSubject] = uigetdir(folder,'select subject in Data');


end