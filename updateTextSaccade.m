function [] = updateTextSaccade(trial, fig, choice, name)

if strcmp(name, 'minuteSaccade')
    
else
    screenSize = get(0,'ScreenSize');
    name = evalin('base', 'name');
    
    xPosition = 10; %screenSize(3)*2/3-50;
    yPosition = screenSize(4)-screenSize(4)*2/3; %screenSize(4)*2/5-50;
    verticalDistance = 20;
    width = 180 ;
    height = 20;
    textblock = 0;
    
    if ~isempty(trial.saccades.direction)
        if trial.saccades.direction(1) == 1
            direction = 'right';
        else
            direction = 'left';
        end
    end
    
    if strcmp(name, 'minuteSaccade')
        selection = num2str(trial.saccades.number);
    else
        if trial.saccades.targetSelection == 1
            selection = 'correct';
        elseif trial.saccades.targetSelection == 0
            selection = 'incorrect';
        else
            selection = 'changed';
        end
    end
    
    fileNameText = uicontrol(fig,'Style','text',...
        'String', ['subject ID: ' trial.log.subject],...
        'Position',[xPosition yPosition width height],...
        'HorizontalAlignment','left'); %#ok<*NASGU>
    
    textblock = textblock+1;
    subjectTypeText = uicontrol(fig,'Style','text',...
        'String', ['group: ' choice],...
        'Position',[xPosition yPosition-textblock*verticalDistance width height],...
        'HorizontalAlignment','left');
    
    textblock = textblock+1;
    trialText = uicontrol(fig,'Style','text',...
        'String', ['Trial: ' num2str(trial.number)],...
        'Position',[xPosition yPosition-textblock*verticalDistance width height],...
        'HorizontalAlignment','left');
    
    textblock = textblock+1;
    directionText = uicontrol(fig,'Style','text',...
        'String', ['Initial saccade direction: ' direction],...
        'Position',[xPosition yPosition-textblock*verticalDistance width height],...
        'HorizontalAlignment','left');
    
    textblock = textblock+1;
    latencyText = uicontrol(fig,'Style','text',...
        'String', ['Saccade latency: ' num2str(trial.saccades.latency)],...
        'Position',[xPosition yPosition-textblock*verticalDistance width height],...
        'HorizontalAlignment','left');
    
    textblock = textblock+1;
    accuracyText = uicontrol(fig,'Style','text',...
        'String', ['Saccade accuracy: ' num2str(trial.saccades.accuracy)],...
        'Position',[xPosition yPosition-textblock*verticalDistance width height],...
        'HorizontalAlignment','left');
    
    textblock = textblock+1;
    selectionText = uicontrol(fig,'Style','text', 'ForegroundColor', 'r',...
        'String', ['targetSelection: ' selection],...
        'Position',[xPosition yPosition-textblock*verticalDistance width height],...
        'HorizontalAlignment','left');
end
end

