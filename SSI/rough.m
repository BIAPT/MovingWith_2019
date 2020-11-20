% Dannie Fu October 30 2020
%
% This script does some random processing or plotting. Each section should be run
% seperately.
% ------------------

%% Plot signal, z score data, Pearson corrs, ssi vals, and pvals 

vid_start = load("/Volumes/Seagate/Moving With 2019/data/2. Session_Nov_7/Original Data/start_recording_time.txt");
starttime = 17.22;
endtime = 19.51;
savename = "Nov7_P6P8_SSI_NSTE";

tiledlayout(5,1);

t1 = (signal_1(:,1)-vid_start)/60000;

ax1 = nexttile;
plot(ax1, t1,signal_1(:,2),'LineWidth',1);
hold(ax1,'on')
plot(ax1, t1,signal_2(:,2),'LineWidth',1);
title("EDA Signal");
xline(starttime, 'k-')
xline(endtime, 'k-')

ax2 = nexttile;
plot(ax2, t1,Z_1,'LineWidth',1);
hold(ax2,'on')
plot(ax2, t1,Z_2,'LineWidth',1);
title('Z score standardized EDA Signal');
xline(starttime, 'k-')
xline(endtime, 'k-')

t2 = (corrs(:,1)-vid_start)/60000;

ax3 = nexttile;
plot(ax3, t2,corrs(:,2),'LineWidth',1);
title('Pearson Corrs');
yline(0,'b-')
xline(starttime, 'k-')
xline(endtime, 'k-')

t3 = (ssi(:,1)-vid_start)/60000;

ax4 = nexttile;
yyaxis left
plot(ax4, t3, ssi(:,2),'LineWidth',1);
yline(0,'b-')

yyaxis right
plot(ax4, t3,pval,'LineWidth',1);
title('SSI and P vals');
xline(starttime, 'k-')
xline(endtime, 'k-')

ax5 = nexttile;
plot(ax5,plt_time(1:length(NSTE))/60, NSTE);
xline(starttime, 'k-')
xline(endtime, 'k-')
title('NSTE');
ylim([0, 1])
ylabel('NSTE');
xlabel('Time (minutes)');
legend('NSTE Y->X','NSTE X->Y');
%saveas(gcf,savename)

%% Unpad beginning 

clean.EDA = unpadBeginning(EDA,60, 15);
clean.TEMP = unpadBeginning(TEMP, 60, 15);
clean.HR = unpadBeginning(HR, 60, 1);
clean.HRVZY = unpadBeginning(HRVZY,60, 4);

save(strcat('/Volumes/Seagate/Moving With 2019/data/5. Session_Dec_5/P6_TP001689_orange/','clean.mat'),'-struct','clean');

%% Unpad end 

clean.EDA = unpadEnd(EDA,60, 15);
clean.TEMP = unpadEnd(TEMP, 60, 15);
clean.HR = unpadEnd(HR, 60, 1);
clean.HRVZY = unpadEnd(HRVZY,60, 4);

save(strcat('/Volumes/Seagate/Moving With 2019/data/5. Session_Dec_5/P6_TP001689_orange/','clean.mat'),'-struct','clean');


