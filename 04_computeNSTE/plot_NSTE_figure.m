% Dannie Fu January 27 2020
%
% This script generates figures for NSTE and STE YX and XY
% The variables must be loaded into the workspace before running.
%
% ------------------------

t = unix_to_datetime(nste_time);
plt_time = t(:) - t(1);

% Plot NSTE X-Y and Y-X
plot(plt_time, NSTE_YX);
hold on
plot(plt_time, NSTE_XY);
title('NSTE');
ylabel('NSTE');
xlabel('Time (minutes)');
legend('NSTE Y->X','NSTE X->Y');

% Plot STE X-Y and Y-X
% figure
% plot(plt_time, STE_YX);
% hold on
% plot(plt_time, STE_XY);
% title('STE');
% ylabel('STE');
% xlabel('Time (minutes)');
% legend('STE Y->X','STE X->Y');

% Plot asymmetry
figure
plot(plt_time(1:5:end), asym_ave);
title('Averate Asymetry X-Y (5 sec window)');
ylabel('STE');
xlabel('Time (minutes)');