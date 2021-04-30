% Dannie Fu October 30 2020
%
% This script does some random plotting. Each section should be run
% seperately.
% ------------------

%% Plot signal, z score data, Pearson corrs, ssi vals, and pvals

clear;
LOAD_DIR_SSI = "/Volumes/Seagate/Moving With 2019/analysis/Dec5_analysis/SSI/noconnection/";
LOAD_DIR_NSTE = "/Volumes/Seagate/Moving With 2019/analysis/Dec5_analysis/NSTE/noconnection/";
LOAD_NAME = "Dec5_P4P6";

%SAVE_DIR = "/Volumes/Seagate/Moving With 2019/analysis/Dec5_analysis/Figures/";
%SAVE_NAME = strcat(LOAD_NAME,"_real.fig");

load(strcat(LOAD_DIR_SSI,LOAD_NAME, "_SSI.mat"));
load(strcat(LOAD_DIR_NSTE,LOAD_NAME, "_NSTE.mat"));
load(strcat(LOAD_DIR_NSTE,LOAD_NAME, "_NSTE_asym.mat"));

tiledlayout(6,1);

t = unix_to_datetime(signal_1(:,1));
t1 = t(:) - t(1);

ax1 = nexttile;
plot(ax1, t1,signal_1(:,2),'LineWidth',1);
hold(ax1,'on')
plot(ax1, t1,signal_2(:,2),'LineWidth',1);
legend('X', 'Y');
title("EDA Signal");

ax2 = nexttile;
plot(ax2, t1,Z_1,'LineWidth',1);
hold(ax2,'on')
plot(ax2, t1,Z_2,'LineWidth',1);
legend('X', 'Y');
title('Z score standardized EDA Signal');

t = unix_to_datetime(corrs(:,1));
t2 = t(:) - t(1);

ax3 = nexttile;
plot(ax3, t2,corrs(:,2),'LineWidth',1);
title('Pearson Corrs');
yline(0,'b-')

t = unix_to_datetime(ssi(:,1));
t3 = t(:) - t(1);

ax4 = nexttile;
yyaxis left
plot(ax4, t3, ssi(:,2),'LineWidth',1);
yline(0,'b-')

yyaxis right
plot(ax4, t3,pval,'LineWidth',1);
title('SSI and P vals');

% NSTE should be using same time as ssi because there should be 1 sample
% per second.
t = unix_to_datetime(ssi(:,1));
t4 = t(:) - t(1);

NSTE = [NSTE_XY;NSTE_YX];

ax5 = nexttile;
plot(ax5,t4(1:length(NSTE_XY)), NSTE_XY,'LineWidth',1);
hold on;
plot(ax5,t4(1:length(NSTE_XY)), NSTE_YX,'LineWidth',1);
legend('NSTE X->Y', 'NSTE Y->X');
title('NSTE');
ylim([0, max(NSTE)])
ylabel('NSTE');
xlabel('Time (minutes)');

t = unix_to_datetime(ssi(1:5:end,1));
t5 = t(:) - t(1);

ax6 = nexttile;
plot(ax6,t5(1:length(asym_ave)), asym_ave,'LineWidth',1);
title('Ave Asymmetry X-Y Over 5 sec windows');
ylabel('asym');
xlabel('Time (minutes)');
yline(0);

saveas(gcf,strcat(SAVE_DIR,SAVE_NAME));

%% Plot segments of signal, z score data, Pearson corrs, ssi vals, and pvals

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/analysis/Dec5_analysis/Activities/";
LOAD_NAME = "Dec5_P8P14_SSI_NSTE_trim_duo_resistance.mat";
load(strcat(LOAD_DIR,LOAD_NAME));

tiledlayout(6,1);

t1 = unix_to_datetime(signal_1_segment(:,1));

ax1 = nexttile;
plot(ax1, t1,signal_1_segment(:,2),'LineWidth',1);
hold(ax1,'on')
plot(ax1, t1,signal_2_segment(:,2),'LineWidth',1);
legend('X', 'Y');
title("EDA Signal");

ax2 = nexttile;
plot(ax2, t1,Z_1_segment,'LineWidth',1);
hold(ax2,'on')
plot(ax2, t1,Z_2_segment,'LineWidth',1);
legend('X', 'Y');
title('Z score standardized EDA Signal');

t2 = unix_to_datetime(corrs_segment(:,1));

ax3 = nexttile;
plot(ax3, t2,corrs_segment(:,2),'LineWidth',1);
title('Pearson Corrs');
yline(0,'b-')

t3 = unix_to_datetime(ssi_segment(:,1));

ax4 = nexttile;
yyaxis left
plot(ax4, t3, ssi_segment(:,2),'LineWidth',1);
yline(0,'b-')

yyaxis right
plot(ax4, t3,pval_segment,'LineWidth',1);
title('SSI and P vals');

% NSTE should be using same time as ssi because there should be 1 sample
% per second.
t4 = unix_to_datetime(ssi_segment(:,1));

NSTE = [NSTE_XY_segment;NSTE_YX_segment];

ax5 = nexttile;
plot(ax5,t4(1:length(NSTE_XY_segment)), NSTE_XY_segment,'LineWidth',1);
hold on;
plot(ax5,t4(1:length(NSTE_XY_segment)), NSTE_YX_segment,'LineWidth',1);
legend('NSTE X->Y', 'NSTE Y->X');
title('NSTE');
ylim([0, max(NSTE)])
ylabel('NSTE');
xlabel('Time (minutes)');

t5 = unix_to_datetime(ssi_segment(1:5:end,1));

ax6 = nexttile;
plot(ax6,t5(1:length(asym_ave_segment)), asym_ave_segment,'LineWidth',1);
title('Ave Asymmetry X-Y Over 5 sec windows');
ylabel('asym');
xlabel('Time (minutes)');
yline(0);

%saveas(gcf,strcat(SAVE_DIR,SAVE_NAME));

