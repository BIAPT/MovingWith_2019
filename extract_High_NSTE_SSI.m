% Dannie Fu February 24 2020
% Extract the top 10% of NSTE and SSI values and plot 

% Input: file name for NSTE, file name for SSI 

clear

load("/Volumes/Seagate/Moving With 2019/analysis/NSTE/parameter_scanning/Session6_Dec12/P3P8/Dec12_P3P8_NSTE_60_3_60.mat");
load("/Volumes/Seagate/Moving With 2019/analysis/SSI/Dec12_P3P8_SSI.mat");

% Init variables 
top_ssi = zeros(size(ssi(:,2)));
top_nste_xy = zeros(size(NSTE_XY));
top_nste_yx = zeros(size(NSTE_YX));

% Find CI and take value outside of the CI as the values to extract
CIFcn = @(x,p)prctile(x,abs([0,100]-(100-p)/2));

% SSI
ssi_vals = ssi(:,2);
histogram(ssi_vals,50)
CI_ssi = CIFcn(ssi_vals,80); 
arrayfun(@(x)xline(x,'-m','prctile'),CI_ssi);
top_ssi(ssi_vals > CI_ssi(2)) = ssi_vals(ssi_vals > CI_ssi(2));
top_ssi(ssi_vals < CI_ssi(1)) = ssi_vals(ssi_vals < CI_ssi(1));

% NSTE XY
figure
histogram(NSTE_XY,50)
CI_nste_xy = CIFcn(NSTE_XY,80); 
arrayfun(@(x)xline(x,'-m','prctile'),CI_nste_xy);
top_nste_xy(NSTE_XY > CI_nste_xy(2)) = NSTE_XY(NSTE_XY > CI_nste_xy(2));
 
% NSTE YX
figure
histogram(NSTE_YX,50)
CI_nste_yx = CIFcn(NSTE_YX,80); 
arrayfun(@(x)xline(x,'-m','prctile'),CI_nste_yx);
top_nste_yx(NSTE_YX > CI_nste_yx(2)) = NSTE_YX(NSTE_YX > CI_nste_yx(2));


% Plot 
figure
tiledlayout(2,1)

nste_time = plt_time(1:length(top_nste_yx))/60;
ssi_time = (ssi(:,1) - ssi(1,1))/60000;

ax1 = nexttile;
plot(ax1,nste_time, top_nste_xy);
hold on
plot(ax1,nste_time, top_nste_yx);
title('NSTE');
ylabel('NSTE');
xlabel('Time (minutes)');
legend('NSTE XY','NSTE YX');

ax2 = nexttile;
yyaxis left
plot(ax2, ssi_time, top_ssi,'LineWidth',1);
yline(0,'b-')

yyaxis right
plot(ax2, ssi_time, pval,'LineWidth',0.5);
title('SSI and P vals');
