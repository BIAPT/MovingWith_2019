% Dannie Fu October 30 2020
%
% This script does some random plotting. Each section should be run
% seperately.
% ------------------

%% Plot signal, z score data, Pearson corrs, ssi vals, and pvals

clear;
LOAD_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/final/1_missingtoNaN/asym_5/";
LOAD_NAME = "Dec5_P5P11";
load(strcat(LOAD_DIR,LOAD_NAME, "_SSI_NSTE_trim.mat"));

tiledlayout(6,1);
 
t = unix_to_datetime(signal_1(:,1));
t1 = t(:) - t(1);

ax1 = nexttile;
plot(ax1, t1,signal_1(:,2),'LineWidth',3);
hold(ax1,'on')
plot(ax1, t1,signal_2(:,2),'LineWidth',3);
legend('Anne', 'Erica');
title("EDA Signals");
set(gca,'FontSize',14)

ax2 = nexttile;
plot(ax2, t1,Z_1,'LineWidth',3);
hold(ax2,'on')
plot(ax2, t1,Z_2,'LineWidth',3);
legend('Anne', 'Erica');
title('Z-score Standardized EDA Signals');
set(gca,'FontSize',20)

t = unix_to_datetime(corrs(:,1));
t2 = t(:) - t(1);

ax3 = nexttile;
plot(ax3, t2,corrs(:,2),'LineWidth',3);
title('Physiological Concordance');
yline(0,'b-')
set(gca,'FontSize',20)

t = unix_to_datetime(ssi(:,1));
t3 = t(:) - t(1);

ax4 = nexttile;
yyaxis left
plot(ax4, t3, ssi(:,2),'LineWidth',3);
ylabel('SSI');
yline(0,'b-')
set(gca,'ycolor','k') 
yyaxis right
plot(ax4, t3,pval,'--','LineWidth',1, 'Color', '#808080');
title('Rolling SSI and Significance');
ylabel('p-values');
set(gca,'FontSize',20)
set(gca,'ycolor','k') 

t = unix_to_datetime(nste_time);
t4 = t(:) - t(1);

NSTE = [NSTE_XY;NSTE_YX];

ax5 = nexttile;
plot(ax5,t4(1:length(NSTE_XY)), NSTE_XY,'LineWidth',2);
hold on;
plot(ax5,t4(1:length(NSTE_XY)), NSTE_YX,'LineWidth',2);
legend('NSTE X->Y', 'NSTE Y->X');
title('NSTE');
ylim([0, max(NSTE)])
ylabel('NSTE');
xlabel('Time (minutes)');
set(gca,'FontSize',20)

t = unix_to_datetime(nste_time(1:30:end));
t5 = t(:) - t(1);

ax6 = nexttile;
plot(ax6,t5, asym_ave,'LineWidth',3);
title('Average Asymmetry X-Y (5 sec window)');
ylabel('Asymmetry');
xlabel('Time (minutes)');
yline(0,'b-');
set(gca,'FontSize',14)

%% Plot segments of signal, z score data, Pearson corrs, ssi vals, and pvals

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/final/2_segmented/asym_5/";
LOAD_NAME = "Dec5_P3P6_SSI_NSTE_trim_improv.mat";
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

t4 = unix_to_datetime(nste_time_segment);

NSTE = [NSTE_XY_segment;NSTE_YX_segment];

ax5 = nexttile;
plot(ax5,t4, NSTE_XY_segment,'LineWidth',1);
hold on;
plot(ax5,t4, NSTE_YX_segment,'LineWidth',1);
legend('NSTE X->Y', 'NSTE Y->X');
title('NSTE');
ylim([0, max(NSTE)])
ylabel('NSTE');
xlabel('Time (minutes)');

t5 = unix_to_datetime(nste_time_segment(1:5:end));

ax6 = nexttile;
plot(ax6,t5, asym_ave_segment,'LineWidth',1);
title('Ave Asymmetry X-Y Over 5 sec windows');
ylabel('asym');
xlabel('Time (minutes)');
yline(0);

%% Plot just concordance and ssi 

tiledlayout(2,1);

t2 = unix_to_datetime(corrs_segment(:,1));

ax3 = nexttile;
plot(ax3, t2,corrs_segment(:,2),'LineWidth',3);
title('Physiological Concordance');
yline(0,'b-')
set(gca,'FontSize',16)


t3 = unix_to_datetime(ssi_segment(:,1));

ax4 = nexttile;
yyaxis left
ssi = plot(ax4, t3, ssi_segment(:,2),'LineWidth',3);
yline(0,'b-')
ylabel("SSI")
set(gca,'ycolor','k') 
yyaxis right
pvals = plot(ax4, t3,pval_segment,'--','LineWidth',1, 'Color', '#808080');
legend([ssi pvals], 'SSI', 'p-values')
set(gca,'ycolor','k') 
title('Rolling SSI and Significance');
ylabel("p-values")
set(gca,'ycolor','k') 
set(gca,'FontSize',16)

%% Plot just asymmetry

t5 = unix_to_datetime(nste_time_segment(1:5:end));

ax6 = nexttile;
plot(ax6,t5, asym_ave_segment,'LineWidth',3);
title('Average Asymmetry X-Y');
ylabel('Asymmetry');
xlabel('Time of Day');
yline(0,'b-');
set(gca,'FontSize',16)
