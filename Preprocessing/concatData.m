% Dannie Fu July 9 2020
% This script concats two segments of a signal and fills in the missing
% chunk with zeros. 
%
% ------------------

%% 

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/6. Session_Dec_12/P14_TP001822_orange/";
SAVE_DIR = "/Volumes/Seagate/Moving With 2019/6. Session_Dec_12/P14_TP001822_orange/";
video_start = importdata("/Volumes/Seagate/Moving With 2019/6. Session_Dec_12/Original Data/start_recording_time.txt");
video_length = 44.24*60*1000; % length to millisecond

% Load data
load(strcat(LOAD_DIR, "/part1/EDA_clean_cut"));
load(strcat(LOAD_DIR, "/part1/TEMP_clean_cut"));
load(strcat(LOAD_DIR, "/part1/HR_clean_cut"));
load(strcat(LOAD_DIR, "/part1/HRVZY_clean_cut"));
EDA_part1 = EDA_clean_cut;
TEMP_part1 = TEMP_clean_cut;
HR_part1 = HR_clean_cut;
HRVZY_part1 = HRVZY_clean_cut; 
clear('EDA_clean_cut');
clear('HR_clean_cut');
clear('TEMP_clean_cut');
clear('HRVZY_clean_cut');

load(strcat(LOAD_DIR, "/part2/EDA_clean"));
load(strcat(LOAD_DIR, "/part2/TEMP_clean"));
load(strcat(LOAD_DIR, "/part2/HR_clean"));
load(strcat(LOAD_DIR, "/part2/HRV_ZY_clean"));
EDA_part2 = EDA_clean;
TEMP_part2 = TEMP_clean;
HR_part2 = HR_clean;
HRVZY_part2 = HRV_ZY_clean; 
clear('EDA_clean');
clear('HR_clean');
clear('TEMP_clean');
clear('HRV_ZY_clean');

% Concat segments
[TEMP_full, EDA_full, HRVZY_full] = concatSegs(EDA_part1,EDA_part2,TEMP_part1,TEMP_part2,HRVZY_part1,HRVZY_part2);

TEMP_full(isnan(TEMP_full))=0;
EDA_full(isnan(EDA_full))=0;
HRVZY_full(isnan(HRVZY_full))=0;

% Save data
save(strcat(SAVE_DIR,"TEMP_full.mat"), "TEMP_full");
save(strcat(SAVE_DIR,"EDA_full.mat"),"EDA_full");
save(strcat(SAVE_DIR,"HRVZY_full.mat"),"HRVZY_full");

%% 

function [TEMP, EDA, HRVZY] = concatSegs(EDA_part1,EDA_part2,TEMP_part1,TEMP_part2,HRVZY_part1,HRVZY_part2)

% EDA and TEMP have same missing samples - sampling rate is 15
EDA_part1_end = EDA_part1(length(EDA_part1),1);
EDA_part2_start = EDA_part2(1,1);

missing_time = (EDA_part2_start - EDA_part1_end)/1000; % time in seconds that is missing between part 1 and part 2 
num_missing_samples = floor(15*missing_time); % sampling rate 15
missing_samples = zeros(num_missing_samples,1);
time = linspace(EDA_part1_end,EDA_part2_start,num_missing_samples)';
missing = horzcat(time,missing_samples);

EDA = vertcat(EDA_part1,missing,EDA_part2);
TEMP = vertcat(TEMP_part1,missing,TEMP_part2);

% HRV has sampling rate 4Hz.
% Don't know what to do about HR??
HRV_part1_end = HRVZY_part1(length(HRVZY_part1),1);
HRV_part2_start = HRVZY_part2(1,1);
missing_time = (HRV_part2_start - HRV_part1_end)/1000;% time in seconds that is missing between part 1 and part 2 
num_missing_samples = floor(4*missing_time); % sampling rate 4
missing_samples = zeros(num_missing_samples,1);
time = linspace(HRV_part1_end,HRV_part2_start,num_missing_samples)';
missing = horzcat(time,missing_samples);

HRVZY = vertcat(HRVZY_part1,missing,HRVZY_part2);

end 