% Load Data
% Dyads will be P1P7, P3P6, P3P11, P4P10, P8P14, P5P7, P5P11 (note, all except P5P11 showed recipricol interactions but at different times)
clear;
A = load("D:\Erica\MovingWith_2019-master\data\dec5_analysis\all_participants\P5\clean_trimmed.mat");
B = load("D:\Erica\MovingWith_2019-master\data\dec5_analysis\all_participants\P11\clean_trimmed.mat");

signal_1 = A.TEMP; % temperature
signal_2 = B.TEMP;


%% Make signals start and end at same time

% Get start time
start_time = max(signal_1(1,1),signal_2(1,1));
[~, idx_start_1] = min(abs(signal_1(:,1)-start_time));
[~, idx_start_2] = min(abs(signal_2(:,1)-start_time));

% If signal starts with NaN, find next non Nan as start time
if(isnan(signal_1(idx_start_1,2)))
    idx_start_1 = find(~isnan(signal_1(:,2)), 1);
    start_time = signal_1(idx_start_1,1);
    
    [~, idx_start_2] = min(abs(signal_2(:,1)-start_time));
    
elseif(isnan(signal_2(idx_start_2,2)))
    idx_start_2 = find(~isnan(signal_2(:,2)), 1);
    start_time = signal_2(idx_start_2,1);
    
    [~, idx_start_1] = min(abs(signal_1(:,1)-start_time));
end

% Get end time
end_time = min(signal_1(end,1), signal_2(end,1));
[~, idx_end_1] = min(abs(signal_1(:,1)-end_time));
[~, idx_end_2] = min(abs(signal_2(:,1)-end_time));

% Trim data to start and end idxs
signal_1 = signal_1(idx_start_1:idx_end_1,:);
signal_2 = signal_2(idx_start_2:idx_end_2,:);

% Since signal_1 or signal_2 might be longer by 1 or 2 samples (milliseconds), take
% the length of the shorter one
signal_length = min(length(signal_1), length(signal_2));
signal_1 = signal_1(1:signal_length,:);
signal_2 = signal_2(1:signal_length,:);

x = signal_1(:,2); 
y = signal_2(:,2); 
time = (signal_1(:,1) - signal_1(1,1))/1000; % Convert time to seconds

figure;
subplot(2,1,1)
plot(signal_1(:,2))
xlabel('samples')
xlim([0 length(signal_1(:,1))])
title('participant 5 TEMP');

subplot(2,1,2)
plot(signal_2(:,2))
xlabel('samples')
xlim([0 length(signal_2(:,1))])
title('participant 11 TEMP');
