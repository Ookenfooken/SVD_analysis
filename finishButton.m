if currentTrial == numTrials
    buttons.finish = uicontrol(fig, 'String', 'Save Errors', 'Position',[100,65,100,60],...
       'callback', 'saveErrors');
end

