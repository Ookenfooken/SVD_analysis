%% define colours
pink = [255,20,147]./255;
black = [0 0 0];

%% load data 
load('eyePosition_antiSac_controls.mat');
load('eyePosition_antiSac_patients.mat');

%%
% plot correct trials
figure(1)
hold on
plot(controls.eyePosition.X_correct(1:750), controls.eyePosition.Y_correct(1:750)-controls.eyePosition.Y_correct(1), ...
    'Color', black, 'Linewidth', 2)
plot(patients.eyePosition.X_correct(1:750), patients.eyePosition.Y_correct(1:750)-patients.eyePosition.Y_correct(1), ...
    'Color', pink, 'Linewidth', 2)
plot(5.641, 0, 'ro', 'Markersize', 10)

set(gca, 'Xtick', [-6 -4 -2 0 2 4 6], 'XtickLabel', [-6 -4 -2 0 2 4 6])
ylim([-.3 .3])
set(gca, 'Ytick', [-.3 -.15 0 .15 .3],'YTickLabel', [-.3 -.15 0 .15 .3])
legend('controls', 'patients')

%%
% plot incorrect trials
figure(2)
hold on
plot(controls.eyePosition.X_error(1:750), controls.eyePosition.Y_error(1:750)-controls.eyePosition.Y_error(1), ...
    'Color', black, 'Linewidth', 2)
plot(patients.eyePosition.X_error(1:750), patients.eyePosition.Y_error(1:750)-patients.eyePosition.Y_error(1), ...
    'Color', pink, 'Linewidth', 2)
plot(5.641, 0, 'ro', 'Markersize', 10)

set(gca, 'Xtick', [-6 -4 -2 0 2 4 6], 'XtickLabel', [-6 -4 -2 0 2 4 6])
ylim([-.5 .5])
set(gca, 'Ytick', [-.5 -.25 0 .25 .5],'YTickLabel', [-.5 -.25 0 .25 .5])

%%
% plot change of mind trials
figure(2)
hold on
plot(controls.eyePosition.X_com(1:750), controls.eyePosition.Y_com(1:750)-controls.eyePosition.Y_com(1), ...
    'Color', black, 'Linewidth', 2)
plot(patients.eyePosition.X_com(1:750), patients.eyePosition.Y_com(1:750)-patients.eyePosition.Y_com(1), ...
    'Color', pink, 'Linewidth', 2)
plot(5.641, 0, 'ro', 'Markersize', 10)

set(gca, 'Xtick', [-6 -4 -2 0 2 4 6], 'XtickLabel', [-6 -4 -2 0 2 4 6])
ylim([-.25 .25])
set(gca, 'Ytick', [-.25 0 .25],'YTickLabel', [-.25 0 .25])