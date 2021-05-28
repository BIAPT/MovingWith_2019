% Dannie Fu June 29 2020
% 
% This script computes the observed NSTE and the shuffled NSTE.
%
% Need to specify:
%   LOAD_DIR, OUT_DIR
%   participants  - all participants in the Moving With session. Each participant is a folder.
%   dyads - the dyads you want to run SSI on. Each dyad is a row.
%   "NSTE Input params" section
%
% Note: Time shift test is not implemented. Only permutation test is
% implemented
% ------------------

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/data/5. Session_Dec_5/";
OUT_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/final/NSTE/noconnection/";

participants = {'P1','P2','P3','P4','P5','P6','P7','P8','P10','P11','P14'};
dyads = {'P3','P8';'P5', 'P10'; 'P11', 'P14'; 'P6','P14'; 'P4','P8';'P5','P6';'P4','P6'}; % each dyad is a row

% Permutation test iterations
num_iter = 100;

% NSTE input parameters 
fs = 15;        % Sampling frequency
win_size_sec = 60;  % Window size in seconds 
win_step_sec = 1;   % Window step size in seconds. For nonoverlapping window, set win_size_sec = win_size_sec
dim = 3;        % Embedding dimension
tau = 15:3:120;   % STE lag

% loop through dyads
for i=1:size(dyads,1)
    
    disp(strcat('Dyad: ',dyads(i,1),dyads(i,2)));
    
    SAVE_NAME = strcat('Dec5_',dyads(i,1),dyads(i,2),'_NSTE');
    
    % Load Data 
    A = load(strcat(LOAD_DIR, char(dyads(i,1)),'/clean_trimmed.mat'));
    B = load(strcat(LOAD_DIR, char(dyads(i,2)),'/clean_trimmed.mat'));

    % Make sure signals start and end at same time
    signal_1 = A.EDA;
    signal_2 = B.EDA;

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
    
    win_size = win_size_sec*fs; % Window size in samples 
    win_step = win_step_sec*fs;  % Step size in samples 
    win_overlap = win_size - win_step;  % Overlap size in samples 

    % Split up signals into windows. Columns of X, Y are the segmented data
    X_wins = buffer(x,win_size,win_overlap,'nodelay');
    Y_wins = buffer(y,win_size,win_overlap,'nodelay');
    
    %% Compute observed NSTE

    % Pre-allocate 
    total_win = size(X_wins,2)-1;  % Don't include the last window because it contains 0s 
    STE_YX = NaN(total_win,1);
    NSTE_YX = NaN(total_win,1);
    STE_XY = NaN(total_win,1);
    NSTE_XY = NaN(total_win,1);

    for m=1:total_win-1
        [STE_YX(m),NSTE_YX(m),STE_XY(m),NSTE_XY(m)]= calculate_STE(X_wins(:,m),Y_wins(:,m),dim,tau);
    end
    
    % Time
    time = signal_1(1:end-win_size,1); % subtracting 1 window size worth of samples because didn't take last window when computing STE/NSTE
    time_idx = 1:fs:length(time);
    nste_time = time(time_idx); % 1 sample per second
    
    save(strcat(OUT_DIR,SAVE_NAME,'.mat'),"NSTE_YX", "NSTE_XY","STE_YX", "STE_XY","nste_time");
     
    clear STE_YX STE_XY NSTE_YX NSTE_XY;
    
%     %% Compute shuffled NSTE
%     
%     % Pre-allocate 
%     STE_YX_shuffle = NaN(total_win,num_iter);
%     NSTE_YX_shuffle = NaN(total_win,num_iter);
%     STE_XY_shuffle = NaN(total_win,num_iter);
%     NSTE_XY_shuffle = NaN(total_win,num_iter);
%     
%     for k=1:num_iter
%         
%         disp(['Iteration ',num2str(k)]);
%         
%         % Get random window from second subject
%         Y_rand_wins = getRandWindows(y, size(X_wins));
%         
%         % Compute NSTE between signal 1 and random signal 2 windows
%         for m=1:total_win-1
%             [STE_YX_shuffle(m,k),NSTE_YX_shuffle(m,k),STE_XY_shuffle(m,k),NSTE_XY_shuffle(m,k)]= calculate_STE(X_wins(:,m),Y_rand_wins(:,m),dim,tau);
%         end
%         
%     end
%         
%     % Sort shuffled concordance in ascending order for each iteration 
%     NSTE_YX_shuffle_sorted = sort(NSTE_YX_shuffle,1);
%     NSTE_XY_shuffle_sorted = sort(NSTE_XY_shuffle,1);
%     
%     % Pre-allocate size
%     pval_XY = NaN(size(NSTE_YX_shuffle_sorted,2));
%     pval_YX = NaN(size(NSTE_YX_shuffle_sorted,2));
% 
%     for j = 1:size(NSTE_YX_shuffle_sorted,2)
% 
%         % From histogram of shuffled NSTE, compute the p-value as the fraction of the distribution that
%         % is more extreme than the observed ssi value.
%         % we use absolute value so that both positive and negative correlations
%         % count as "extreme". If pval is smaller than the critical value (0.05),
%         % then the two are significantly different 
%         pval_XY(j) = (sum(abs(NSTE_XY_shuffle_sorted(:,j)) > abs(NSTE_XY(j,2))))/ (size(NSTE_XY_shuffle_sorted,1));
%         pval_YX(j) = (sum(abs(NSTE_YX_shuffle_sorted(:,j)) > abs(NSTE_YX(j,2))))/ (size(NSTE_YX_shuffle_sorted,1));
%     end 
% 
%     save(strcat(OUT_DIR,SAVE_NAME,'.mat'),"NSTE_YX", "NSTE_XY","STE_YX", "STE_XY","nste_time", ...
%         "NSTE_YX_shuffle", "NSTE_XY_shuffle", "pval_XY", "pval_YX");
%     
%     clear STE_YX STE_XY NSTE_YX NSTE_XY STE_YX_shuffle NSTE_YX_shuffle STE_XY_shuffle NSTE_XY_shuffle pval_XY pval_YX;          
    
end 


