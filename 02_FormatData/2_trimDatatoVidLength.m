% Dannie Fu July 9 2020
% This script cuts out the signal before the start of the moving with videos
%
% ------------------
%%

clear

% Params to change
LOAD_DIR = "/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P10_TP001354_green/";
OUT_DIR = LOAD_DIR;
video_start = importdata("/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/Original Data/start_recording_time.txt");

% Load data
load(strcat(LOAD_DIR, "clean"));

% Trim data
[clean_trimmed.TEMP, clean_trimmed.HR, clean_trimmed.EDA, clean_trimmed.HRVZY] = trimData(TEMP,HR,EDA,HRVZY,video_start);

% Save data
save(strcat(OUT_DIR,'clean_trimmed.mat'),'-struct','clean_trimmed');

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