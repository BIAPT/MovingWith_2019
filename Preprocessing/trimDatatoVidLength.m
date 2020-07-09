% Dannie Fu July 9 2020
% This script cuts out the signal before the start of the moving with videos
%
% ------------------
%%

% Params to change
LOAD_DIR = "/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P4_TP001491_orange/part1/";
SAVE_DIR = "/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P4_TP001491_orange/part1/";
video_start = importdata("/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/Original Data/start_recording_time.txt");

% Load data
load(strcat(LOAD_DIR, "EDA_clean"));
load(strcat(LOAD_DIR, "TEMP_clean"));
load(strcat(LOAD_DIR, "HR_clean"));
load(strcat(LOAD_DIR, "HRV_ZY_clean"));

% Trim data
[TEMP_clean_cut, HR_clean_cut, EDA_clean_cut, HRVZY_clean_cut] = trimData(TEMP_clean,HR_clean,EDA_clean,HRV_ZY_clean,video_start);

% Save data
save(strcat(SAVE_DIR,"TEMP_clean_cut.mat"),"TEMP_clean_cut");
save(strcat(SAVE_DIR,"EDA_clean_cut.mat"),"EDA_clean_cut");
save(strcat(SAVE_DIR,"HR_clean_cut.mat"),"HR_clean_cut");
save(strcat(SAVE_DIR,"HRVZY_clean_cut.mat"),"HRVZY_clean_cut");

%% Function to trim the data 

function [TEMP_cut, HR_cut, EDA_cut, HRVZY_cut] = trimData(TEMP,HR,EDA,HRVZY,video_start)

% Cut out data before start of video
% Temp and EDA are same length because they both have 15Hz sampling rate
[~, idx_Start] = min(abs(EDA(:,1) - video_start));
EDA_cut = EDA(idx_Start:end,:);
TEMP_cut = TEMP(idx_Start:end,:);

% HRV has 4 HZ sampling rate 
[~, idx_Start] = min(abs(HR(:,1) - video_start));
HR_cut = HR(idx_Start:end,:);

[~, idx_Start] = min(abs(HRVZY(:,1) - video_start));
HRVZY_cut = HRVZY(idx_Start:end,:);

end 