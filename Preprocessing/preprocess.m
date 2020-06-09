% Dannie Fu June 2 2020
% This script preprocesses EDA, TEMP, HR:
%   1. All signals: 1D median filter 
%   2. All signals: moving average filter 
%   3. EDA: 1euro filter 
%      TEMP: exponential decay filter 
%      HR: cubic splining function
% Saves the cleaned data as EDA_clean, TEMP_clean, HR_clean in the format [time, data]
% ------------------

% Save directory
OUT_DIR = "/Volumes/FUD/Moving With 2019/Session_Nov_7/P1_TP001689_green/";

% Load TEMP, EDA, HR
load('/Volumes/FUD/Moving With 2019/Session_Nov_7/P1_TP001689_green/2019-11-07_10h54m43_EDA_1.mat');
load('/Volumes/FUD/Moving With 2019/Session_Nov_7/P1_TP001689_green/2019-11-07_10h54m43_TEMP_1.mat');
load('/Volumes/FUD/Moving With 2019/Session_Nov_7/P1_TP001689_green/2019-11-07_10h54m43_HR_1.mat');

% Calculate time in seconds
EDA_time = (EDA.EDA_time - EDA.EDA_time(1))/1000;
TEMP_time = (TEMP.TEMP_time - TEMP.TEMP_time(1))/1000;
HR_time = (HR.HR_time - HR.HR_time(1))/1000;

% 1D median filter
EDA_medfilt = medfilt1(EDA.EDA_data,75,'omitnan');  % Omitnan excludes the missing samples when computing the medians
EDA_medfilt_interp = fillmissing(EDA_medfilt,'movmedian',450); %Using a large windwo to compute the moving median window to account for the long sequence of NaNs

TEMP_medfilt = medfilt1(TEMP.TEMP_data,1,'omitnan');
TEMP_medfilt_interp = fillmissing(TEMP_medfilt,'movmedian',450);

% What about HR? Paper doesn't mention params for HR.\

% Moving Average (used overlapping windows instead of nonoverlapping)
EDA_avefilt = movmean(EDA_medfilt_interp,15); %Window size 15, arbitrarily chosen 
TEMP_avefilt = movmean(TEMP_medfilt_interp,15);
HR_avefilt = movmean(HR.HR_data,15);

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

%% Save cleaned data
EDA_clean = horzcat(EDA_time,EDA_eurofilt);
TEMP_clean = horzcat(TEMP_time,TEMP_expfilt);
HR_clean = horzcat(HR_time,HR_cubic);

save(strcat(OUT_DIR,"EDA_clean.mat"),"EDA_clean")
save(strcat(OUT_DIR,"TEMP_clean.mat"),"TEMP_clean")
save(strcat(OUT_DIR,"HR_clean.mat"),"HR_clean")

%% Plot  
subplot(3,1,1)
plot(EDA_time,EDA_avefilt,'LineWidth',1)
hold on 
plot(EDA_time,EDA_eurofilt,'LineWidth',1)
ylabel("EDA (us)")
legend("medfilt+movmean", "medfilt+movmean+euro")
title("P1 Nov 7 Session")

subplot(3,1,2)
plot(TEMP_time,TEMP_avefilt,'LineWidth',1)
hold on 
plot(TEMP_time,TEMP_expfilt,'LineWidth',1)
ylabel("Temperature (C)")
legend("medfilt+movmean", "medfilt+movmean+expdecay")

subplot(3,1,3)
plot(HR_time, HR_avefilt,'LineWidth',1)
hold on 
plot(HR_time, HR_cubic,'LineWidth',1)
legend("medfilt+movmean", "medfilt+movmean+cubicspline")
ylabel("Heart rate")
xlabel("Time (seconds)")