% Dannie Fu December 17 2020
% 
% This script scans the parameters needed for NSTE and computes the total NSTE sum in a session.
%
% Params: 
%   Window size: 20, 30, 60 second windows 
%   Embedding dimension (m): 3,4,5
%   Lag (tau): 1-10 seconds 
% ------------------

%% Input params
clear;

% Save params
OUT_DIR = '/Volumes/Seagate/Moving With 2019/analysis/NSTE/parameter_scanning/Session5_Dec5/P4P10/';
SAVE_NAME = 'Dec5_P4P10_NSTE';

% Load Data 
A = load("/Volumes/Seagate/Moving With 2019/data/5. Session_Dec_5/P4_TP001491_orange/clean");
B = load("/Volumes/Seagate/Moving With 2019/data/5. Session_Dec_5/P10_TP001354_green/clean");
signal_1 = A.EDA;
signal_2 = B.EDA;

% NSTE Input Parameters 
fs = 15;        % Sampling frequency
win_size_sec = [20,30,60];  % Window size in seconds 
win_step_sec = 1;   % Window step size in seconds. For nonoverlapping window, set win_size_sec = win_size_sec
dim = [3,4,5];        % Embedding dimension
tau = [[15:3:45];[30:3:60];[45:3:75];[60:3:90];[75:3:105];[90:3:120];[105:3:135];[120:3:150]];   % STE lag

%% Make signals start and end at same time

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

%% Loop through params 

for i=1:length(win_size_sec)
    for j = 1:length(dim)
        for k = 1:size(tau,1)
            
            win_size = win_size_sec(i)*fs; % Window size in samples 
            win_step = win_step_sec*fs;  % Step size in samples 
            plt_time = time(1:win_step:end);
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

                [STE_YX(m),NSTE_YX(m),STE_XY(m),NSTE_XY(m)]= calculate_STE(X_wins(:,m),Y_wins(:,m),dim(j),tau(k,:));

            end
            
            % Compute sum of NSTE over 0 for entire session
            sum_NSTE_XY = sum(NSTE_XY>0);
            sum_NSTE_YX = sum(NSTE_YX>0);

            save(strcat(OUT_DIR,SAVE_NAME,'_',num2str(win_size_sec(i)),'_',num2str(dim(j)),'_',num2str(tau(k,1)),'.mat'),"NSTE_YX", "NSTE_XY","plt_time","STE_YX", "STE_XY","sum_NSTE_XY","sum_NSTE_YX");
            
        end 
    end 
end 
