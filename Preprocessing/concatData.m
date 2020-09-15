% Dannie Fu July 9 2020
% This script concats two segments of a signal and fills in the missing
% chunk with zeros. 
%
% ------------------

%% 

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/1. Session_Oct_31/P2_TP001491_orange/";
OUT_DIR = LOAD_DIR;
video_start = importdata("/Volumes/Seagate/Moving With 2019/1. Session_Oct_31/Original Data/start_recording_time.txt");
video_length = 16.26*60*1000; % length to millisecond. Can use mmfileinfo if download the right codec


% Load data
part1 = load(strcat(LOAD_DIR, "/part1/clean"));
part2 = load(strcat(LOAD_DIR, "/part2/clean_trimmed"));

% Concat segments
[clean.TEMP, clean.EDA, clean.HRVZY] = concatSegs(part1.EDA,part2.EDA,part1.TEMP,part2.TEMP,part1.HRVZY,part2.HRVZY);

clean.TEMP(isnan(clean.TEMP))=0;
clean.EDA(isnan(clean.EDA))=0;
clean.HRVZY(isnan(clean.HRVZY))=0;

% Save data
save(strcat(OUT_DIR,'clean.mat'),'-struct','clean');

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