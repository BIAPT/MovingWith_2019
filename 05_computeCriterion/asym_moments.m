% Dannie Fu May 27 2021
% This script loads an asym_ave file and finds all segments of asym higher/lower than 0
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
min_time = 30; % in seconds
min_amp = 0;
asym_win_size = 5;

% Find consecutive abs(values) that are greater than or less than a threshold of 0 (0 is arbitrary right
% now). "area" = # of samples, "PixelValues" = asym value
asym_pos = regionprops(asym_ave > min_amp, asym_ave, 'area', 'PixelValues');
asym_pos_idx = regionprops(asym_ave > min_amp, asym_ave, 'area', 'PixelIdxList');

asym_neg = regionprops(asym_ave< min_amp, asym_ave, 'area', 'PixelValues');
asym_neg_idx = regionprops(asym_ave< min_amp, asym_ave, 'area', 'PixelIdxList');

% asym_time
asym_time = nste_time(1:asym_win_size:end);

% Get start and end times where asym is at greater than 0/ less than 0
for i=1:length(asym_pos)
    if asym_pos(i).Area <= (min_time/5)
        continue;
        
    else
        start_idx = asym_pos_idx(i).PixelIdxList(1);
        end_idx = asym_pos_idx(i).PixelIdxList(end);

        asym_pos_times(i,:) = [ asym_time(start_idx) asym_time(end_idx)] ;
    end 
end

for i=1:length(asym_neg)
    if asym_neg(i).Area <= (min_time/5)
        continue;
    else
        start_idx = asym_neg_idx(i).PixelIdxList(1);
        end_idx = asym_neg_idx(i).PixelIdxList(end);

        asym_neg_times(i,:) = [ asym_time(start_idx) asym_time(end_idx)] ;
    end 
end

% Remove 0s 
if exist('asym_pos_times', 'var')
    asym_pos_times = asym_pos_times(any(asym_pos_times,2),:);
end 
if exist('asym_neg_times', 'var')
    asym_neg_times = asym_neg_times(any(asym_neg_times,2),:);
end 

% Plot sustained moments of asym from above

ax5 = nexttile;

t = unix_to_datetime(asym_time);
xaxis = t(:) - t(1);

if exist('asym_pos_times', 'var')
    pos_times = unix_to_datetime(asym_pos_times) - t(1); 
end

if exist('asym_neg_times', 'var')
    neg_times = unix_to_datetime(asym_neg_times) - t(1); 
end

plot(ax5, xaxis, asym_ave,'LineWidth',3);
title("Average Asymmetry X-Y")
ylabel("Asymmetry")
yline(0,'b-')
hold on

if exist('asym_pos_times', 'var')
    for j=1:size(pos_times,1)
        y = get(gca,'ylim'); % current y-axis limits
        start = pos_times(j,1);
        endtime = pos_times(j,2);
        plot([start start], [y(1), y(2)], "w",'Marker', 'none');
        hold on;
        plot([endtime endtime], [y(1), y(2)], "w",'Marker', 'none');
        x2 = [xaxis, fliplr(xaxis)];
        inbetween = [start, fliplr(endtime)];
        f = fill([start start endtime endtime], [y fliplr(y)],[0 0.5 1],'EdgeColor','none');
        alpha(f,.2)
    end
end 

if exist('asym_neg_times', 'var')
    for k=1:size(neg_times,1)
        y = get(gca,'ylim'); % current y-axis limits
        start2 = neg_times(k,1);
        endtime2 = neg_times(k,2);
        plot([start2 start2], [y(1), y(2)], "w",'Marker', 'none');
        hold on;
        plot([endtime2 endtime2], [y(1), y(2)], "w",'Marker', 'none');
        x2 = [xaxis, fliplr(xaxis)];
        inbetween = [start2, fliplr(endtime2)];
        f2 = fill([start2 start2 endtime2 endtime2], [y fliplr(y)],[1 0.5 0],'EdgeColor','none');
        alpha(f2,.2)
    end
end 

% moments of connection
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


set(gca,'FontSize',20)


