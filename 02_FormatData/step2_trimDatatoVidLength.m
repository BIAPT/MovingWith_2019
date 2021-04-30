% Dannie Fu July 9 2020
%
% This script cuts out EDA, TEMP, HR, and HRVYZ signals before the start of the Moving With
% videos.
%
% Need to specify LOAD_DIR for a single participant and the VIDEO_START variable which is the directory of the "start_recording_time.txt" file. 
% Make sure VIDEO_START is for the session you are loading the data from. 
% 
% ** Note: participants with orange phones have a different
% start_recording_time.txt files than the other participants - see IDs document for phone colours and corresponding participant ids.
%
% ------------------

%%
clear;

% Params to change
LOAD_DIR = "/Volumes/Seagate/Moving With 2019/data/4. Session_Nov_21/P13/";
VIDEO_START = importdata("/Volumes/Seagate/Moving With 2019/data/4. Session_Nov_21/Original Data/start_recording_time.txt");

% Load data
load(strcat(LOAD_DIR,"/clean.mat"));

% Trim data
[clean_trimmed.TEMP, clean_trimmed.HR, clean_trimmed.EDA, clean_trimmed.HRVYZ] = ...
    trimData(clean.TEMP,clean.HR,clean.EDA,clean.HRVYZ,VIDEO_START);

% Save data
OUT_DIR = strcat(LOAD_DIR,'/');
save(strcat(OUT_DIR,'clean_trimmed.mat'),'-struct','clean_trimmed');
    
%% Function to trim the data 

function [TEMP_cut, HR_cut, EDA_cut, HRVYZ_cut] = trimData(TEMP,HR,EDA,HRVYZ,video_start)

% Cut out data before start of video
% Temp and EDA are same length because they both have 15Hz sampling rate
[~, idx_Start] = min(abs(EDA(:,1) - video_start));
EDA_cut = EDA(idx_Start:end,:);
TEMP_cut = TEMP(idx_Start:end,:);

% HRV has 4 HZ sampling rate 
[~, idx_Start] = min(abs(HR(:,1) - video_start));
HR_cut = HR(idx_Start:end,:);

[~, idx_Start] = min(abs(HRVYZ(:,1) - video_start));
HRVYZ_cut = HRVYZ(idx_Start:end,:);

end 