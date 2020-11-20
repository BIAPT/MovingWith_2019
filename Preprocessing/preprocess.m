% Dannie Fu June 2 2020
%
% This script preprocesses EDA, TEMP, HR, HRVZ/Y
% Saves the cleaned data in a struct called "clean", with EDA, HR, HRVZY,
% TEMP
% ------------------

%clear;

%% This section is for running on one folder - comment out if running on many folders 

% Input params 
LOAD_DIR = "/Volumes/Seagate/Moving With 2019/data/6. Session_Dec_12/P3_TP001353_blue/";
OUT_DIR = LOAD_DIR;

%Load all the mat files (but will only preprocess temp, eda, hr, hrv)
files = dir(strcat(LOAD_DIR,'*.mat'));
for i=1:length(files)
    filepath = strcat(LOAD_DIR,files(i).name);
    load(filepath);
end

%%
% Sometimes the headers in the tables are capitalized so can change the names here instead of all over the script
EDA_time = EDA.EDA_time;
TEMP_time = TEMP.TEMP_time;
HR_time = HR.HR_time;
HRV_time = HRV.HRV_time;

EDA_data = EDA.EDA_data;
TEMP_data = TEMP.TEMP_data;
HR_data = HR.HR_data;
HRV_ZY = HRV.HRV_z ./ HRV.HRV_y;

% Cut beginning if data starts with 0s 
% Find index where EDA is larger than 0.05 (smaller is invalid data). Finds the first 10 indices because sometimes
% theres will be a non zero value for 1 or 2 points and then go back to 0.
start_idxs = find(EDA_data >= 0.05, 10, 'first'); 
diff_idxs = diff(start_idxs);
i=find(diff(diff_idxs)~=0,1,'last');

if isempty(i)
    t_start = EDA_time(start_idxs(1),1);
else 
    t_start = EDA_time(start_idxs(i+1),1);
end 

% Cut end if data ends in 0 
end_idxs = find(EDA_data >= 0.05, 1, 'last'); 

if ~isempty(end_idxs)
    t_end = EDA_time(end_idxs,1);
end

[EDA_data, EDA_time] = unpad(EDA_data,EDA_time, t_start,t_end);
[TEMP_data, TEMP_time] = unpad(TEMP_data, TEMP_time, t_start,t_end);
[HR_data, HR_time] = unpad(HR_data, HR_time, t_start,t_end);
[HRV_ZY, HRV_time] = unpad(HRV_ZY,HRV_time, t_start,t_end);

% Call preprocessing scripts
[EDA_medfilt, EDA_avefilt,EDA_interp, EDA_eurofilt] = preprocessEDA(EDA_data);
[TEMP_medfilt, TEMP_avefilt, TEMP_interp, TEMP_expfilt] = preprocessTEMP(TEMP_data);
[HR_avefilt, HR_cubic, HRV_ZY_avefilt, HRV_ZY_interp, HRV_ZY_cubic] = preprocessHR(HR_data, HR_time, HRV_ZY, HRV_time);

clean.EDA = horzcat(EDA_time,EDA_eurofilt);
clean.TEMP = horzcat(TEMP_time,TEMP_expfilt);
clean.HR = horzcat(HR_time,HR_cubic);
clean.HRVZY = horzcat(HRV_time,HRV_ZY_cubic); 

% Save cleaned data
save(strcat(OUT_DIR,'clean.mat'),'-struct','clean');

%% Plot  
figure
subplot(4,1,1)
plot(unix_to_datetime(EDA_time),EDA_data(1:length(EDA_time)),'LineWidth',1)
hold on;
plot(unix_to_datetime(EDA_time),EDA_medfilt(1:length(EDA_time)),'LineWidth',1)
hold on;
plot(unix_to_datetime(EDA_time),EDA_avefilt(1:length(EDA_time)),'LineWidth',1)
hold on;
plot(unix_to_datetime(EDA_time),EDA_interp(1:length(EDA_time)),'LineWidth',1)
hold on;
plot(unix_to_datetime(EDA_time), EDA_eurofilt(1:length(EDA_time)),'LineWidth',2)
legend('raw','medfilt','avefilt','interp','eurofilt');
ylabel("EDA (us)")

subplot(4,1,2)
plot(unix_to_datetime(TEMP_time),TEMP_data(1:length(TEMP_time)),'LineWidth',1)
hold on
plot(unix_to_datetime(TEMP_time),TEMP_medfilt(1:length(TEMP_time)),'LineWidth',1)
hold on 
plot(unix_to_datetime(TEMP_time),TEMP_avefilt(1:length(TEMP_time)),'LineWidth',1)
hold on
plot(unix_to_datetime(TEMP_time),TEMP_expfilt(1:length(TEMP_time)),'LineWidth',2)
ylabel("Temperature (C)")
legend("raw", "medfilt", "avefilt", "expfilt")

subplot(4,1,3)
plot(unix_to_datetime(HR_time), HR_data(1:length(HR_time)),'LineWidth',1)
hold on 
plot(unix_to_datetime(HR_time), HR_avefilt(1:length(HR_time)),'LineWidth',1)
hold on
plot(unix_to_datetime(HR_time), HR_cubic(1:length(HR_time)),'LineWidth',2)
legend("raw", "avefilt","cubic")
ylabel("Heart rate")

subplot(4,1,4)
plot(unix_to_datetime(HRV_time), HRV_ZY(1:length(HRV_time)),'LineWidth',1)
hold on 
plot(unix_to_datetime(HRV_time), HRV_ZY_avefilt(1:length(HRV_time)),'LineWidth',1)
hold on 
plot(unix_to_datetime(HRV_time), HRV_ZY_interp(1:length(HRV_time)),'LineWidth',1)
hold on
plot(unix_to_datetime(HRV_time), HRV_ZY_cubic(1:length(HRV_time)),'LineWidth',2)
legend("raw", "avefilt", "interp","cubicspline")
ylabel("HRV Z/Y")
xlabel("Time (seconds)")