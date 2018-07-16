prompt = {'Enter updated trial type (1: correct; 0: incorrect; 2: change of mind)'};
title = 'Target selection correction';
num_lines = 1;
defaultans = {''};
answer = inputdlg(prompt, title, num_lines, defaultans);
% overwrite target selection
currentAdj = [currentTrial str2double(answer{1})];
targetSelectionAdj = [targetSelectionAdj; currentAdj];
