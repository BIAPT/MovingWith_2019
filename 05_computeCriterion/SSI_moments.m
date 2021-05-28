% Dannie Fu May 27 2021
% This script loads an SSI file and finds all segments of SSI higher than 0
% for at least 30 seconds 

clear;

% Load file
load("/Volumes/Seagate/Moving With 2019/dec5_analysis/final/SSI/noconnection/Dec5_P4P6_SSI.mat");

% Start and end time of moment of connection in video (see
% MW2019_200516_moments.xls file for reference)
%connect_start = duration("00:26:45");
%connect_end = duration("00:27:15");
%connect_start1 = duration("00:20:06");
%connect_end1 = duration("00:22:44");

% Params 
min_time = 30;
min_amp = 0;

% Find sustained moments of high/low SSI (minimum 30 seconds) using image
% processing toolbox to compute 3) and 4). 

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
SSI_pos_times = SSI_pos_times(any(SSI_pos_times,2),:);
SSI_neg_times = SSI_neg_times(any(SSI_neg_times,2),:);

%% Plot sustained moments of SSI from above

t = unix_to_datetime(ssi(:,1));
xaxis = t(:) - t(1);

pos_times = unix_to_datetime(SSI_pos_times) - t(1); 
neg_times = unix_to_datetime(SSI_neg_times) - t(1); 

yyaxis left
plot(xaxis, ssi(:,2),'LineWidth',3);
yline(0,'b-')
hold on
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
for k=1:size(neg_times,1)
    y = get(gca,'ylim'); % current y-axis limits
    start2 = neg_times(k,1);
    endtime2 = neg_times(k,2);
    plot([start2 start2], [y(1), y(2)], "w",'Marker', 'none');
    hold on;
    plot([endtime2 endtime2], [y(1), y(2)], "w",'Marker', 'none');
    x2 = [xaxis, fliplr(xaxis)];
    inbetween = [start2, fliplr(endtime2)];
    f2 = fill([start2 start2 endtime2 endtime2], [y fliplr(y)],[0.8500, 0.3250, 0.0980],'EdgeColor','none');
    alpha(f2,.2)
end
%xline(connect_start, 'r', 'LineWidth',3);
%xline(connect_end, 'r', 'LineWidth',3);
%xline(connect_start1, 'b', 'LineWidth',3);
%xline(connect_end1, 'b', 'LineWidth',3);

yyaxis right
plot(xaxis,pval,"k",'LineWidth',0.5);
yline(0.05,"r",'LineWidth',1)
title('SSI and P vals');
    


