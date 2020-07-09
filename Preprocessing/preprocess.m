% Dannie Fu June 2 2020
% This script preprocesses EDA, TEMP, HR:
%   1. All signals: 1D median filter 
%   2. All signals: moving average filter 
%   3. EDA: 1euro filter 
%      TEMP: exponential decay filter 
%      HR: cubic splining function
% Saves the cleaned data as EDA_clean, TEMP_clean, HR_clean in the format [time, data]
%
% ------------------

%% Save directory
clear
OUT_DIR = "/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P6_TP001689_orange/part2/";
PLT_TITLE = "P6 part2 ";

% Load TEMP, EDA, HR, HRV
LOAD_DIR = "/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P6_TP001689_orange/part2/";
load(strcat(LOAD_DIR,'2019-12-05_14h31m58_TEMP_1.mat'));
load(strcat(LOAD_DIR,'2019-12-05_14h31m58_EDA_1.mat'));
load(strcat(LOAD_DIR,'2019-12-05_14h31m58_HR_1.mat'));
load(strcat(LOAD_DIR,'2019-12-05_14h31m58_HRV_1.mat'));

%% Sometimes the headers in the tables are capitalized so can change the names here instead of all over the script

% Time
EDA_time = EDA.EDA_time;
TEMP_time = TEMP.TEMP_time;
HR_time = HR.HR_time;
HRV_time = HRV.HRV_time;

% Data 
EDA_data = EDA.EDA_data;
TEMP_data = TEMP.TEMP_data;
HR_data = HR.HR_data;
HRV_ZY = HRV.HRV_z ./ HRV.HRV_y;

%% Filtering 

% 1D median filter
EDA_medfilt = medfilt1(EDA_data,75,'omitnan');  % Omitnan excludes the missing samples when computing the medians
EDA_medfilt_interp = fillmissing(EDA_medfilt,'movmedian',450); %Using a large windwo to compute the moving median window to account for the long sequence of NaNs

TEMP_medfilt = medfilt1(TEMP_data,1,'omitnan');
TEMP_medfilt_interp = fillmissing(TEMP_medfilt,'movmedian',450);

% What about HR? Paper doesn't mention params for HR.\

% Moving Average (used overlapping windows instead of nonoverlapping)
EDA_avefilt = movmean(EDA_medfilt_interp,15); %Window size 15, arbitrarily chosen 
TEMP_avefilt = movmean(TEMP_medfilt_interp,15);
HR_avefilt = movmean(HR_data,15);
HRV_ZY_avefilt = movmean(HRV_ZY,15);

% EDA: Apply 1 euro filter 
a = oneEuro; % Declare oneEuro object
a.mincutoff = 50.0; % Decrease this to get rid of slow speed jitter
a.beta = 4.0; % Increase this to get rid of high speed lag

noisySignal = EDA_avefilt;
EDA_eurofilt = zeros(size(noisySignal));
for i = 1:length(noisySignal)
    EDA_eurofilt(i) = a.filter(noisySignal(i),i);
end

% TEMP: Apply exponential decay filter
TEMP_expfilt = exp_decay(TEMP_avefilt,0.95);

% HR: Apply cubic splining function 
HR_cubic = csaps(HR_time,HR_avefilt,0.001,HR_time); 
HRV_ZY_cubic = csaps(HRV_time,HRV_ZY_avefilt,0.001,HRV_time); 

%% Save cleaned data

EDA_clean = horzcat(EDA_time,EDA_eurofilt); % Saving original Java time so that later I can cut out the time before video started
TEMP_clean = horzcat(TEMP_time,TEMP_expfilt);
HR_clean = horzcat(HR_time,HR_cubic);
HRV_ZY_clean = horzcat(HRV_time,HRV_ZY_cubic);


save(strcat(OUT_DIR,"EDA_clean.mat"),"EDA_clean")
save(strcat(OUT_DIR,"TEMP_clean.mat"),"TEMP_clean")
save(strcat(OUT_DIR,"HR_clean.mat"),"HR_clean")
save(strcat(OUT_DIR,"HRV_ZY_clean.mat"),"HRV_ZY_clean")

%% Plot  
subplot(4,1,1)
plot((EDA_time-EDA_time(1))/60000,EDA_avefilt,'LineWidth',1)
hold on 
plot((EDA_time-EDA_time(1))/60000,EDA_eurofilt,'LineWidth',1)
ylabel("EDA (us)")
legend("medfilt+movmean", "medfilt+movmean+euro")
title(PLT_TITLE)

subplot(4,1,2)
plot((TEMP_time-TEMP_time(1))/60000,TEMP_avefilt,'LineWidth',1)
hold on 
plot((TEMP_time-TEMP_time(1))/60000,TEMP_expfilt,'LineWidth',1)
ylabel("Temperature (C)")
legend("medfilt+movmean", "medfilt+movmean+expdecay")

subplot(4,1,3)
plot((HR_time-HR_time(1))/60000, HR_avefilt,'LineWidth',1)
hold on 
plot((HR_time-HR_time(1))/60000, HR_cubic,'LineWidth',1)
legend("medfilt+movmean", "medfilt+movmean+cubicspline")
ylabel("Heart rate")

subplot(4,1,4)
plot((HRV_time-HRV_time(1))/60000, HRV_ZY_avefilt,'LineWidth',1)
hold on 
plot((HRV_time-HRV_time(1))/60000, HRV_ZY_cubic,'LineWidth',1)
legend("medfilt+movmean", "medfilt+movmean+cubicspline")
ylabel("HRV Z/Y")
xlabel("Time (minutes)")