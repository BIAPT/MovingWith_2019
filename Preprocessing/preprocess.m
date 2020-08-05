% Dannie Fu June 2 2020
%
% This script preprocesses EDA, TEMP, HR, HRVZ/Y
% Saves the cleaned data as EDA_clean, TEMP_clean, HR_clean in the format [time, data]
% ------------------

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/2. Session_Nov_7/P12_TP001884_yellow/";
OUT_DIR = LOAD_DIR;
PLT_TITLE = "";

% Load all the mat files (but will only preprocess temp, eda, hr, hrv)
files = dir(strcat(LOAD_DIR,'*.mat'));
for i=1:length(files)
    filepath = strcat(LOAD_DIR,files(i).name);
    load(filepath);
end

% Sometimes the headers in the tables are capitalized so can change the names here instead of all over the script
EDA_time = EDA.EDA_time;
TEMP_time = TEMP.TEMP_time;
HR_time = HR.HR_time;
HRV_time = HRV.HRV_time;

EDA_data = EDA.EDA_data;
TEMP_data = TEMP.TEMP_data;
HR_data = HR.HR_data;
HRV_ZY = HRV.HRV_z ./ HRV.HRV_y;

%% Call preprocessing scripts

preprocessEDA;
preprocessTEMP;
preprocessHR;

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
plot((EDA_time-EDA_time(1))/1000,EDA_data,'LineWidth',1);
hold on;
plot((EDA_time-EDA_time(1))/1000,EDA_medfilt,'LineWidth',1);
hold on;
plot((EDA_time-EDA_time(1))/1000,EDA_avefilt,'LineWidth',1);
hold on;
plot((EDA_time-EDA_time(1))/1000, EDA_eurofilt,'LineWidth',2);
legend('raw','medfilt','avefilt','eurofilt');
ylabel("EDA (us)")
title(PLT_TITLE)

subplot(4,1,2)
plot((TEMP_time-TEMP_time(1))/1000,TEMP_data,'LineWidth',1)
hold on
plot((TEMP_time-TEMP_time(1))/1000,TEMP_medfilt,'LineWidth',1)
hold on 
plot((TEMP_time-TEMP_time(1))/1000,TEMP_avefilt,'LineWidth',1)
hold on
plot((TEMP_time-TEMP_time(1))/1000,TEMP_expfilt,'LineWidth',2)
ylabel("Temperature (C)")
legend("raw", "medfilt", "avefilt", "expfilt")

subplot(4,1,3)
plot((HR_time-HR_time(1))/1000, HR_data,'LineWidth',1)
hold on 
plot((HR_time-HR_time(1))/1000, HR_avefilt,'LineWidth',1)
hold on 
plot((HR_time-HR_time(1))/1000, HR_cubic,'LineWidth',2)
legend("raw", "avefilt", "cubic")
ylabel("Heart rate")

subplot(4,1,4)
plot((HRV_time-HRV_time(1))/1000, HRV_ZY,'LineWidth',1)
hold on 
plot((HRV_time-HRV_time(1))/1000, HRV_ZY_avefilt,'LineWidth',1)
hold on 
plot((HRV_time-HRV_time(1))/1000, HRV_ZY_cubic,'LineWidth',2)
legend("raw", "avefilt", "cubicspline")
ylabel("HRV Z/Y")
xlabel("Time (seconds)")