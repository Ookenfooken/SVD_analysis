function [eyeData] = readEyeData(ascFile, dataPath, currentSubject, analysisPath)
    
    screenResX = evalin('base', 'screenResX');
    screenResY = evalin('base', 'screenResY');

    currentSubjectPath = fullfile(dataPath, currentSubject);
    cd(currentSubjectPath);
    
    allData = load(ascFile);
   
    eyeDataX = allData(:,2);
    replace = eyeDataX > 9000;
    eyeDataX(replace) = 0;
    eyeDataTempX = eyeDataX-(screenResX/2);
    
    eyeDataY = allData(:,3);
    replace = eyeDataY > 9000;
    eyeDataY(replace) = 0;
    eyeDataTempY = (screenResY/2)-eyeDataY;
    
    cd(analysisPath);

    eyeData = pixels2degrees(eyeDataTempX, eyeDataTempY);

    eyeData.X = eyeData.degX;
    eyeData.Y = eyeData.degY;
    
    eyeData.rawX = eyeDataX;
    eyeData.rawY = eyeDataY;
    
end

