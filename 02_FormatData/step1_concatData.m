% Dannie Fu July 9 2020
% 
% This script concats two segments of a EDA, TEMP, HRVYZ, HR signal and fills in the missing
% chunk with nans. Saves the concat-ed data in the participants' folder as
% a struct called "clean.mat".
%
% LOAD_DIR needs to be specified for a single participant. OUT_DIR is the same as LOAD_DIR.
%
% Note: Script needs to be modified to handle data if it has more than 2
% segments.
% ------------------

%%
clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/data/5. Session_Dec_5/P8_TP001822_orange/";
OUT_DIR = LOAD_DIR;

% Load data
part1 = load(strcat(LOAD_DIR, "/part1/clean"));
part2 = load(strcat(LOAD_DIR, "/part2/clean"));

% Concat segments
[clean.TEMP, clean.EDA, clean.HRVZY, clean.HR] = concatSegs(part1.EDA,part2.EDA,part1.TEMP,part2.TEMP,part1.HRVZY,part2.HRVZY,part1.HR,part2.HR);


% Save data
save(strcat(OUT_DIR,'clean.mat'),'-struct','clean');

%% 

function [TEMP, EDA, HRVZY, HR] = concatSegs(EDA_part1,EDA_part2,TEMP_part1,TEMP_part2,HRVZY_part1,HRVZY_part2,HR_part1,HR_part2)

% EDA and TEMP have same missing samples - sampling rate is 15
EDA_part1_end = EDA_part1(length(EDA_part1),1);
EDA_part2_start = EDA_part2(1,1);

missing_time = (EDA_part2_start - EDA_part1_end)/1000; % time in seconds that is missing between part 1 and part 2 
num_missing_samples = floor(15*missing_time); % sampling rate 15
missing_samples = NaN(num_missing_samples,1);
time = linspace(EDA_part1_end,EDA_part2_start,num_missing_samples)';
missing = horzcat(time,missing_samples);

EDA = vertcat(EDA_part1,missing,EDA_part2);
TEMP = vertcat(TEMP_part1,missing,TEMP_part2);

% HRV has sampling rate 4Hz.
HRV_part1_end = HRVZY_part1(length(HRVZY_part1),1);
HRV_part2_start = HRVZY_part2(1,1);
missing_time = (HRV_part2_start - HRV_part1_end)/1000; % time in seconds that is missing between part 1 and part 2 
num_missing_samples = floor(4*missing_time); % sampling rate 4
missing_samples = NaN(num_missing_samples,1);
time = linspace(HRV_part1_end,HRV_part2_start,num_missing_samples)';
missing = horzcat(time,missing_samples);

HRVZY = vertcat(HRVZY_part1,missing,HRVZY_part2);

% For HR, since it has no sampling rate, just put NaN between 
nan = [NaN, NaN];
HR = vertcat(HR_part1, nan, HR_part2);

end 