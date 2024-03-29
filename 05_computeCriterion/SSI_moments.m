% Dannie Fu May 27 2021
% This script loads an SSI file and finds all segments of SSI higher/lower than 0
% for at least 30 seconds 

clear;

% Load file
load("/Volumes/Seagate/Moving With 2019/dec5_analysis/final/1_missingtoNaN/asym_5/Dec5_P4P10_SSI_NSTE_trim.mat");

% Start and end time of moment of connection in video (see
% MW2019_200516_moments.xls file for reference)
connect_start = duration("00:15:33");
connect_end = duration("00:17:17");
connect_start1 = duration("00:20:06");
connect_end1 = duration("00:22:44");
connect_start2 = duration("00:25:28");
connect_end2 = duration("00:27:15");

% activity times
% musical_textures_start = duration("00:00:00");
% musical_textures_end = duration("00:07:00");
% duositting_start = duration("00:10:30");
% duositting_end = duration("00:17:30");
% duostand_start = duration("00:20:00");
% duostand_end = duration("00:23:00");
% improv_start = duration("00:24:50");
% improv_end = duration("00:27:15");

% Params 
min_time = 30;
min_amp = 0;

% Find sustained moments of high/low SSI (minimum 30 seconds) using image
% processing toolbox

% Find consecutive abs(values) that are greater than or less than a threshold of 0 (0 is arbitrary right
% now). "area" = # of samples, "PixelValues" = ssi value
SSI_pos = regionprops(ssi(:,2)> min_amp, ssi(:,2), 'area', 'PixelValues');
SSI_pos_idx = regionprops(ssi(:,2)> min_amp, ssi(:,2), 'area', 'PixelIdxList');

SSI_neg = regionprops(ssi(:,2)< min_amp, ssi(:,2), 'area', 'PixelValues');
SSI_neg_idx = regionprops(ssi(:,2)< min_amp, ssi(:,2), 'area', 'PixelIdxList');

% Get start and end times where SSI is at greater than 0/ less than 0
for i=1:length(SSI_pos)
    if SSI_pos(i).Area < min_time
        continue;
    else
        start_idx = SSI_pos_idx(i).PixelIdxList(1);
        end_idx = SSI_pos_idx(i).PixelIdxList(end);

        SSI_pos_times(i,:) = [ ssi(start_idx,1) ssi(end_idx,1)] ;
    end 
end

for i=1:length(SSI_neg)
    if SSI_neg(i).Area < min_time
        continue;
    else
        start_idx = SSI_neg_idx(i).PixelIdxList(1);
        end_idx = SSI_neg_idx(i).PixelIdxList(end);

        SSI_neg_times(i,:) = [ ssi(start_idx,1) ssi(end_idx,1)] ;
    end 
end

% Remove 0s 
if exist('SSI_pos_times', 'var')
    SSI_pos_times = SSI_pos_times(any(SSI_pos_times,2),:);
end 

if exist('SSI_neg_times', 'var')
    SSI_neg_times = SSI_neg_times(any(SSI_neg_times,2),:);
end 

% Plot sustained moments of SSI from above

tiledlayout(2,1);

ax4 = nexttile;

t = unix_to_datetime(ssi(:,1));
xaxis = t(:) - t(1);

if exist('SSI_pos_times', 'var')
    pos_times = unix_to_datetime(SSI_pos_times) - t(1); 
end 

if exist('SSI_neg_times', 'var')
    neg_times = unix_to_datetime(SSI_neg_times) - t(1); 
end 

yyaxis left
ssiplot = plot(ax4, xaxis, ssi(:,2),'LineWidth',3);
ylabel('SSI');
yline(0,'b-')
set(gca,'ycolor','k') 
hold on

yyaxis right
pvalplot = plot(ax4, xaxis,pval,'--','LineWidth',1, 'Color', '#808080');
title('Rolling SSI and Significance');
ylabel('p-values');
set(gca,'ycolor','k') 

if exist('SSI_pos_times', 'var')
    for j=1:size(pos_times,1)
        y = get(gca,'ylim'); % current y-axis limits
        start = pos_times(j,1);
        endtime = pos_times(j,2);
        plot([start start], [y(1), y(2)], "w",'Marker', 'none');
        hold on;
        plot([endtime endtime], [y(1), y(2)], "w",'Marker', 'none');
        x2 = [xaxis, fliplr(xaxis)];
        inbetween = [start, fliplr(endtime)];
        f = fill([start start endtime endtime], [y fliplr(y)],[0, 0.5, 0],'EdgeColor','none');
        alpha(f,.2)
    end
end 

if exist('SSI_neg_times', 'var')
    for k=1:size(neg_times,1)
        y = get(gca,'ylim'); % current y-axis limits
        start2 = neg_times(k,1);
        endtime2 = neg_times(k,2);
        plot([start2 start2], [y(1), y(2)], "w",'Marker', 'none');
        hold on;
        plot([endtime2 endtime2], [y(1), y(2)], "w",'Marker', 'none');
        x2 = [xaxis, fliplr(xaxis)];
        inbetween = [start2, fliplr(endtime2)];
        f2 = fill([start2 start2 endtime2 endtime2], [y fliplr(y)],[1 0.2 0.2],'EdgeColor','none');
        alpha(f2,.2)
    end
end 

% Moments of connection
xline(connect_start, 'r', 'LineWidth',3);
xline(connect_end, 'r', 'LineWidth',3);
xline(connect_start1, 'r', 'LineWidth',3);
xline(connect_end1, 'r', 'LineWidth',3);
xline(connect_start2, 'r', 'LineWidth',3);
xline(connect_end2, 'r', 'LineWidth',3);

% activities
% xline(musical_textures_start, 'k', 'LineWidth',3);
% xline(musical_textures_end, 'k', 'LineWidth',3);
% xline(duositting_start, 'k', 'LineWidth',3);
% xline(duositting_end, 'k', 'LineWidth',3);
% xline(duostand_start, 'k', 'LineWidth',3);
% xline(duostand_end, 'k', 'LineWidth',3);
% xline(improv_start, 'k', 'LineWidth',3);
% xline(improv_end, 'k', 'LineWidth',3);

legend([ssiplot pvalplot], 'SSI', 'p-values')

set(gca,'FontSize',20)

    


