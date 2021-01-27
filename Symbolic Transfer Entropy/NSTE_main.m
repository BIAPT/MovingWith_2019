% Dannie Fu June 29 2020
% 
% This script computes the observed NSTE and the shuffled NSTE.
% Before running script, make sure to modify the "Input params" section
% with the appropriate parameters.
%
% ------------------

clear;

%% Input params 

% Save params
OUT_DIR = '/Volumes/Seagate/Moving With 2019/analysis/NSTE/test/';
SAVE_NAME = 'Nov7_P6P8_NSTE';

% Load Data 
signal1 = load("/Volumes/Seagate/Moving With 2019/data/2. Session_Nov_7/P6_TP001376_blue/clean");
signal2 = load("/Volumes/Seagate/Moving With 2019/data/2. Session_Nov_7/P8_TP001822_red/clean");

% NSTE Input Parameters 
fs = 15;        % Sampling frequency
win_size_sec = 10;  % Window size in seconds 
win_step_sec = 1;   % Window step size in seconds. For nonoverlapping window, set win_size_sec = win_size_sec
dim = 4;        % Embedding dimension
tau = 1:2:30;   % STE lag%% Make signals start and end at same time

%% Make sure signals start and end at same time

signal_1 = signal1.EDA;
signal_2 = signal2.EDA;

% Get start time 
start_time = max(signal_1(1,1),signal_2(1,1));
[~, idx_start_1] = min(abs(signal_1(:,1)-start_time)); 
[~, idx_start_2] = min(abs(signal_2(:,1)-start_time)); 

signal_1 = signal_1(idx_start_1:end,:);
signal_2 = signal_2(idx_start_2:end,:);

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
end_idx = min(idx_end_1,idx_end_2);

signal_1 = signal_1(idx_start_1:end_idx,:);
signal_2 = signal_2(idx_start_1:end_idx,:);

x = signal_1(:,2); 
y = signal_2(:,2); 
time = (signal_1(:,1) - signal_1(1,1))/1000; % Convert time to seconds 

%% Compute observed NSTE

win_size = win_size_sec*fs; % Window size in samples 
win_step = win_step_sec*fs;  % Step size in samples 
win_overlap = win_size - win_step;  % Overlap size in samples 

% Split up signals into windows. Columns of X, Y are the segmented data
X_wins = buffer(x,win_size,win_overlap,'nodelay');
Y_wins = buffer(y,win_size,win_overlap,'nodelay');

total_win = size(X_wins,2)-1;  % Don't include the last window because it contains 0s 
STE_YX = NaN(total_win,1);
NSTE_YX = NaN(total_win,1);
STE_XY = NaN(total_win,1);
NSTE_XY = NaN(total_win,1);

for m=1:total_win-1
    
    [STE_YX(m),NSTE_YX(m),STE_XY(m),NSTE_XY(m)]= calculate_STE(X_wins(:,m),Y_wins(:,m),dim,tau);
    
end

save(strcat(OUT_DIR,SAVE_NAME,'.mat'),"NSTE_YX", "NSTE_XY","plt_time","STE_YX", "STE_XY","win_size_sec","dim","tau");

%% Compute shuffled NSTE

for k=1:num_iter
    
    disp(['Iteration ',num2str(k)]);
    
    % Get random window from second subject
    Y_rand_wins = getRandWindows(y, size(X_wins));
    
    % Pre-allocate 
    STE_YX_shuffle = NaN(total_win,num_iter);
    NSTE_YX_shuffle = NaN(total_win,num_iter);
    STE_XY_shuffle = NaN(total_win,num_iter);
    NSTE_XY_shuffle = NaN(total_win,num_iter);
    
    % Compute NSTE between signal 1 and random signal 2 windows
    for m=1:total_win-1
        [STE_YX_shuffle(m,k),NSTE_YX_shuffle(m,k),STE_XY_shuffle(m,k),NSTE_XY_shuffle(m,k)]= calculate_STE(X_wins(:,m),Y_rand_wins(:,m),dim,tau);
    end
     
end 
