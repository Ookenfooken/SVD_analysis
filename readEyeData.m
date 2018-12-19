function [eyeData] = readEyeData(ascFile, dataPath, currentSubject, analysisPath)
    
    screenResX = evalin('base', 'screenResX');
    screenResY = evalin('base', 'screenResY');

    currentSubjectPath = fullfile(dataPath, currentSubject);
    cd(currentSubjectPath);
    
    allData = load(ascFile);
   
    eyeDataX = allData(:,2);
    replace = eyeDataX > 9000;
    eyeDataX(replace) = screenResX/2;
    eyeDataTempX = eyeDataX-(screenResX/2);
    
    eyeDataY = allData(:,3);
    replace = eyeDataY > 9000;
    eyeDataY(replace) = screenResY/2;
    eyeDataTempY = (screenResY/2)-eyeDataY;
    
    cd(analysisPath);

    eyeDataXY = pixels2degrees(eyeDataTempX, eyeDataTempY);

    eyeData.X = eyeDataXY.degX;
    eyeData.Y = eyeDataXY.degY;
    
    eyeData.rawX = eyeDataX;
    eyeData.rawY = eyeDataY;
    
    eyeData.timeStamp = allData(:,1);
    
end

