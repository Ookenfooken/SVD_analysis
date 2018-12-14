function [] = updatePlotsSaccade(trial, name, targetOnset, currentTrial)

if strcmp(name, 'minuteSaccade')
   %% relative position plot
    startFrame = 1;
    endFrame = length(trial.eyeX_filt);
    subplot(2,1,1,'replace');
    axis([startFrame endFrame -10 10]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Position (degree)', 'fontsize', 12);
    plot(startFrame:endFrame,trial.eyeX_filt(startFrame:endFrame),'k');
    plot(startFrame:endFrame,trial.eyeY_filt(startFrame:endFrame),'b');
    legend('x position','y position');
    
    plot(trial.saccades.X.onsets,trial.eyeX_filt(trial.saccades.X.onsets),'g*');
    plot(trial.saccades.X.offsets,trial.eyeX_filt(trial.saccades.X.offsets),'m*');
    plot(trial.saccades.Y.onsets,trial.eyeY_filt(trial.saccades.Y.onsets),'y*');
    plot(trial.saccades.Y.offsets,trial.eyeY_filt(trial.saccades.Y.offsets),'c*');
    
    line([trial.log.targetOnset trial.log.targetOnset], [-10 10],'Color','k','LineStyle',':');
    line([trial.length trial.length], [-10 10],'Color','k','LineStyle',':'); 
       
     %% velocity plot
    subplot(2,1,2,'replace');
    axis([startFrame endFrame -150 150]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Speed (degree/second)', 'fontsize', 12);
    plot(startFrame:endFrame,trial.eyeDX_filt(startFrame:endFrame),'k');
    plot(startFrame:endFrame,trial.eyeDY_filt(startFrame:endFrame),'b');
    plot(trial.saccades.X.onsets,trial.eyeDX_filt(trial.saccades.X.onsets),'g*');
    plot(trial.saccades.X.offsets,trial.eyeDX_filt(trial.saccades.X.offsets),'m*');
    plot(trial.saccades.Y.onsets,trial.eyeDY_filt(trial.saccades.Y.onsets),'y*');
    plot(trial.saccades.Y.offsets,trial.eyeDY_filt(trial.saccades.Y.offsets),'c*');
    line([trial.log.targetOnset trial.log.targetOnset], [-150 150],'Color','k','LineStyle',':');
    line([trial.length trial.length], [-150 150],'Color','k','LineStyle',':');
    
else
    startFrame = 1;
    stimOnset = trial.log.targetOnset;
    endFrame = length(trial.eyeX_filt);
    
    %% relative position plot
    subplot(2,2,1,'replace');
    axis([startFrame endFrame -10 10]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Position (degree)', 'fontsize', 12);
    plot(startFrame:endFrame,trial.eyeX_filt(startFrame:endFrame),'k');
    plot(startFrame:endFrame,trial.eyeY_filt(startFrame:endFrame),'b');
    legend('x position','y position');
    
    plot(trial.saccades.X.onsets,trial.eyeX_filt(trial.saccades.X.onsets),'g*');
    plot(trial.saccades.X.offsets,trial.eyeX_filt(trial.saccades.X.offsets),'m*');
    plot(trial.saccades.Y.onsets,trial.eyeY_filt(trial.saccades.Y.onsets),'y*');
    plot(trial.saccades.Y.offsets,trial.eyeY_filt(trial.saccades.Y.offsets),'c*');
    
    line([trial.log.targetOnset trial.log.targetOnset], [-10 10],'Color','k','LineStyle',':');
    line([trial.length trial.length], [-10 10],'Color','k','LineStyle',':');
    
    %% velocity plot
    subplot(2,2,2,'replace');
    axis([startFrame endFrame -150 150]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Speed (degree/second)', 'fontsize', 12);
    plot(startFrame:endFrame,trial.eyeDX_filt(startFrame:endFrame),'k');
    plot(startFrame:endFrame,trial.eyeDY_filt(startFrame:endFrame),'b');
    plot(trial.saccades.X.onsets,trial.eyeDX_filt(trial.saccades.X.onsets),'g*');
    plot(trial.saccades.X.offsets,trial.eyeDX_filt(trial.saccades.X.offsets),'m*');
    plot(trial.saccades.Y.onsets,trial.eyeDY_filt(trial.saccades.Y.onsets),'y*');
    plot(trial.saccades.Y.offsets,trial.eyeDY_filt(trial.saccades.Y.offsets),'c*');
    line([trial.log.targetOnset trial.log.targetOnset], [-150 150],'Color','k','LineStyle',':');
    line([trial.length trial.length], [-150 150],'Color','k','LineStyle',':');
    
    
    %% absolute position plot
    posEnd = min([trial.length length(trial.eyeX_filt)]);
    subplot(2,3,4,'replace');
    axis([-10 10 -2.5 2.5]);
    hold on
    xlabel('x-position (deg)', 'fontsize', 12);
    ylabel('y-position (deg)', 'fontsize', 12);
    plot(trial.eyeX_filt(stimOnset:posEnd), trial.eyeY_filt(stimOnset:posEnd) ,'k');
    plot(trial.log.initialFixation(1), trial.log.initialFixation(2), 'ob')
    if strcmp(name, 'antiSaccade')
        targetPosition = [trial.log.antiSacPosition.deg.degX trial.log.antiSacPosition.deg.degY];
    elseif strcmp(name, 'proSaccade')
        targetPosition = [trial.log.proSacPosition.deg.degX trial.log.proSacPosition.deg.degY];
    else
        targetPosition = [trial.log.antiSacPosition.deg.degX trial.log.antiSacPosition.deg.degY;...
            trial.log.proSacPosition.deg.degX trial.log.proSacPosition.deg.degY];
    end
    plot(targetPosition(:,1), targetPosition(:,2), 'or')
    
    %% micro-saccade position plot
    msEnd = targetOnset(currentTrial)-50;
    subplot(2,3,5,'replace');
    axis([1 msEnd -1 1]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Position (degree)', 'fontsize', 12);
    plot(1:msEnd,trial.X_noSac(1:msEnd),'k');
    plot(1:msEnd,trial.Y_noSac(1:msEnd),'b');
    legend('x position','y position');
    
    plot(trial.microSaccades.X.onsets,trial.eyeX_filt(trial.microSaccades.X.onsets),'g*');
    plot(trial.microSaccades.X.offsets,trial.eyeX_filt(trial.microSaccades.X.offsets),'m*');
    plot(trial.microSaccades.Y.onsets,trial.eyeY_filt(trial.microSaccades.Y.onsets),'y*');
    plot(trial.microSaccades.Y.offsets,trial.eyeY_filt(trial.microSaccades.Y.offsets),'c*');
    
    line([trial.log.targetOnset trial.log.targetOnset], [-1 1],'Color','k','LineStyle',':');
    line([trial.length trial.length], [-1 1],'Color','k','LineStyle',':');
    
    %% micro-saccade velocity plot
    subplot(2,3,6,'replace');
    axis([1 msEnd -10 10]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Speed (degree/second)', 'fontsize', 12);
    plot(1:msEnd,trial.DX_noSac(1:msEnd),'k');
    plot(1:msEnd,trial.DY_noSac(1:msEnd),'b');
    plot(trial.microSaccades.X.onsets,trial.eyeDX_filt(trial.microSaccades.X.onsets),'g*');
    plot(trial.microSaccades.X.offsets,trial.eyeDX_filt(trial.microSaccades.X.offsets),'m*');
    plot(trial.microSaccades.Y.onsets,trial.eyeDY_filt(trial.microSaccades.Y.onsets),'y*');
    plot(trial.microSaccades.Y.offsets,trial.eyeDY_filt(trial.microSaccades.Y.offsets),'c*');
    line([trial.log.targetOnset trial.log.targetOnset], [-10 10],'Color','k','LineStyle',':');
    line([trial.length trial.length], [-10 10],'Color','k','LineStyle',':');
end
end