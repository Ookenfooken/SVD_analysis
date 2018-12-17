function [] = updatePlotsPursuit(trial, name)

startFrame = 1;
endFrame = length(trial.eye.X_filt);
green = [77 175 74]./255;

if strcmp(name, 'smoothPursuit')
    %% position over time
    subplot(2,1,1,'replace');
    axis([startFrame endFrame -10 10]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Position (degree)', 'fontsize', 12);
    % plot eye and target position
    plot(startFrame:endFrame,trial.eye.X_filt(startFrame:endFrame),'Color', green);
    plot(startFrame:length(trial.target.X),trial.target.X(1:end),'Color', green, 'LineStyle', '--');
    plot(startFrame:endFrame,trial.eye.Y_filt(startFrame:endFrame),'b');
    plot(startFrame:length(trial.target.Y),trial.target.Y(1:end),'b', 'LineStyle', '--');
    legend('x eye', 'x target', 'y eye', 'y target');
    % add saccades
    if sum(trial.target.X) == 0
        plot(trial.saccades.onsets,trial.eye.Y_filt(trial.saccades.onsets),'g*');
        plot(trial.saccades.offsets,trial.eye.Y_filt(trial.saccades.offsets),'m*');
    elseif sum(trial.target.Y) == 0
        plot(trial.saccades.onsets,trial.eye.X_filt(trial.saccades.onsets),'g*');
        plot(trial.saccades.offsets,trial.eye.X_filt(trial.saccades.offsets),'m*');
    end
    % indicate blinks
    for i = 1:length(trial.saccades.blinkOnsets)
        line([trial.saccades.blinkOnsets(i) trial.saccades.blinkOffsets(i)], [0 0],'Color','r', 'LineWidth', 2);
    end
    % indicate target on and offset
    line([trial.target.onset trial.target.onset], [-10 10],'Color','k','LineStyle',':');
    line([trial.target.offset trial.target.offset], [-10 10],'Color','k','LineStyle',':');
        
    %% velocity over time
    subplot(2,1,2,'replace');
    axis([startFrame endFrame -25 25]);
    hold on;
    xlabel('Time(ms)', 'fontsize', 12);
    ylabel('Speed (degree/second)', 'fontsize', 12);
    % plot eye and target velocity
    plot(startFrame:endFrame,trial.eye.DX_filt(startFrame:endFrame),'Color', green);
    plot(startFrame:length(trial.target.Xvel),trial.target.Xvel(1:end),'Color', green, 'LineStyle', '--');
    plot(startFrame:endFrame,trial.eye.DY_filt(startFrame:endFrame),'b');
    plot(startFrame:length(trial.target.Yvel),trial.target.Yvel(1:end),'b', 'LineStyle', '--');
    % add saccades
    if sum(trial.target.X) == 0
        plot(trial.saccades.onsets,trial.eye.DY_filt(trial.saccades.onsets),'g*');
        plot(trial.saccades.offsets,trial.eye.DY_filt(trial.saccades.offsets),'m*');
    elseif sum(trial.target.Y) == 0
        plot(trial.saccades.onsets,trial.eye.DX_filt(trial.saccades.onsets),'g*');
        plot(trial.saccades.offsets,trial.eye.DX_filt(trial.saccades.offsets),'m*');
    end
    % indicate blinks
    for i = 1:length(trial.saccades.blinkOnsets)
        line([trial.saccades.blinkOnsets(i) trial.saccades.blinkOffsets(i)], [0 0],'Color','r', 'LineWidth', 2);
    end
    % indicate target on and offset
    line([trial.target.onset trial.target.onset], [-25 25],'Color','k','LineStyle',':');
    line([trial.target.offset trial.target.offset], [-25 25],'Color','k','LineStyle',':');
    
else
    %anticipatory pursuit will probably go here
    
end
end