cd(currentSubjectPath);
save(currentSubject, 'targetSelectionAdj'); 
cd(analysisPath);

csvwrite('errors_saccades.csv', errors)  
csvwrite('errors_microSaccade.csv', errorsMS) 

close all