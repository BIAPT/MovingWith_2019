% Dannie Fu January 27 2020
% This script generates figures for NSTE and STE YX and XY
% The variables must be loaded into the workspace before running.

% Plot NSTE X-Y and Y-X
plot(plt_time(1:length(NSTE_YX))/60, NSTE_YX);
hold on
plot(plt_time(1:length(NSTE_XY))/60, NSTE_XY);
title('NSTE');
ylabel('NSTE');
xlabel('Time (minutes)');
legend('NSTE Y->X','NSTE X->Y');
%saveas(gcf,strcat(OUT_DIR,SAVE_NAME))

% Plot STE X-Y and Y-X
figure
plot(plt_time(1:length(STE_YX))/60, STE_YX);
hold on
plot(plt_time(1:length(STE_XY))/60, STE_XY);
title('STE');
ylabel('STE');
xlabel('Time (minutes)');
legend('STE Y->X','STE X->Y');