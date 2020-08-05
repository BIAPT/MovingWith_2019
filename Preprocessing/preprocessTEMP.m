% Dannie Fu August 5 2020
% This script preprocess TEMP data:
%
% 1D median filter 
% Moving average filter 
% Exponential decay filter 
%
% ---------------------

% Median filter
TEMP_medfilt = medfilt1(TEMP_data,1,'truncate');

% Moving average 
TEMP_avefilt = movmean(TEMP_medfilt,15);

% If TEMP is NaN longer than 30 seconds (450 samples), replace with 0s,
% otherwise interpolate with nearest neighbour 
TEMP_avefilt2 = interp1gap(TEMP_avefilt,450,'previous','interpval',0);

% Exponential decay filter
TEMP_expfilt = exp_decay(TEMP_avefilt2',0.95);


%%
% plot((TEMP_time-TEMP_time(1))/1000,TEMP_data,'LineWidth',1)
% hold on
% plot((TEMP_time-TEMP_time(1))/1000,TEMP_medfilt,'LineWidth',1)
% hold on 
% plot((TEMP_time-TEMP_time(1))/1000,TEMP_avefilt,'LineWidth',1)
% hold on
% plot((TEMP_time-TEMP_time(1))/1000,TEMP_expfilt,'LineWidth',1)
% ylabel("Temperature (C)")
% legend("raw", "medfilt", "medfilt+avefilt", "expfilt")
% 
