% Dannie Fu December 17 2020
% Edited by Erica Flaten May 2021
%
% This script scans the parameters needed for NSTE and computes the total NSTE sum in a session.
% Note, input parameters commented in or out for MoveWith vs. PieceofMind data
%
% Change appropriate save name, A/B signal directories, physiological mode, and
% tau range. Note that resampling section is only for HR.
%
% Params:
%   Window size: 60 second window (since this is what was used for EDA)
%   Embedding dimension (m): 3 (from previous param sweep for 3, 4 or 5)
%   Lag (tau): 1-10 seconds (for EDA); 5-20.6 seconds (for TEMP)
% ------------------

%% Input params - MoveWith Project
clear;

% Save params
OUT_DIR = 'D:\Erica\MovingWith_2019-master\data\param_scanning\STE\';

% Change this as appropriate
SAVE_NAME = 'Dec5_P5P11_NSTE_HR';

% Load Data
% Dyads will be P1P7, P3P6, P3P11, P4P10, P8P14, P5P7, P5P11 (note, all except P5P11 showed recipricol interactions but at different times)
A = load("D:\Erica\MovingWith_2019-master\data\dec5_analysis\all_participants\P5\clean_trimmed.mat");
B = load("D:\Erica\MovingWith_2019-master\data\dec5_analysis\all_participants\P11\clean_trimmed.mat");

% signal_1 = A.EDA;
% signal_2 = B.EDA;
% signal_1 = A.TEMP; % temperature
% signal_2 = B.TEMP;
% For HR, see below, need to resample.

% NSTE Input Parameters
fs = 15;        % Sampling frequency, 15 for TEMP, 4 for HRV, ??? for HR
win_size_sec = 60;  % Window size in seconds
win_step_sec = 1;   % Window step size in seconds. For nonoverlapping window, set win_size_sec = win_size_sec
dim = 3;        % Embedding dimension
% tau = [[75:9:111];[93:9:129];[111:9:147];[129:9:165];[147:9:183];[165:9:201];
%     [183:9:219];[201:9:237];[219:9:255];[237:9:273];[255:9:291];[273:9:309]]; % STE lag in samples for Temp
tau = [[15:3:45];[30:3:60];[45:3:75];[60:3:90];[75:3:105];[90:3:120];[105:3:135];[120:3:150]]; % STE lag in samples for EDA & HR

%% Input Params - Piece of Mind project
% clear;
% 
% % Save params
% OUT_DIR = 'D:\Erica\PieceOfMind\param_scanning\NSTE\';
% 
% % Change this as appropriate
% SAVE_NAME = 'Dec5_P1P2_NSTE_HR';
% 
% % Load Data
% A = load("D:\Erica\PieceOfMind\June_01_data_raw\P1\clean.mat"); % P1 = tap dancer
% B = load("D:\Erica\PieceOfMind\June_01_data_raw\P2\clean.mat"); % P2 = person with PD
% 
% % signal_1 = A.clean.EDA;
% % signal_2 = B.clean.EDA;
% % signal_1 = A.clean.TEMP; % temperature
% % signal_2 = B.clean.TEMP;
% % See below for HR
% 
% % NSTE Input Parameters
% fs = 15;        % Sampling frequency, 15 for TEMP, 4 for HRV, ??? for HR
% win_size_sec = 60;  % Window size in seconds
% win_step_sec = 1;   % Window step size in seconds. For nonoverlapping window, set win_size_sec = win_size_sec
% dim = 3;        % Embedding dimension
% % tau = [[75:9:111];[93:9:129];[111:9:147];[129:9:165];[147:9:183];[165:9:201];[183:9:219];[201:9:237];[219:9:255];[237:9:273];[255:9:291];[273:9:309]]; % STE lag in samples for Temp,
% tau = [[15:3:45];[30:3:60];[45:3:75];[60:3:90];[75:3:105];[90:3:120];[105:3:135];[120:3:150]]; % STE lag in samples for EDA

%% Heart Rate Only - Resample to 15 Hz - Probably a more efficient way to code this...

%  A/signal_1
A_length = length(A.EDA); % EDA is sampled at 15 Hz, so should be same length
A_nan_index = find(isnan(A.HR));
if A_nan_index > 0
    nan_row = A_nan_index(1,1);
    nan_time1 = A.HR(nan_row - 1,1);
    nan_time2 = A.HR(nan_row + 1,1);
    A.HR = A.HR(any(~isnan(A.HR),2),:);
end
signal_1(:,2) = interp1(A.HR(:,1),A.HR(:,2),linspace(A.HR(1,1),A.HR(end,1),A_length))';
signal_1(:,1) = linspace(A.HR(1,1),A.HR(end,1),A_length);
figure;
plot(A.HR(:,1),A.HR(:,2),'.-',linspace(A.HR(1,1),A.HR(end,1),A_length),signal_1(:,2),'o-');

%put NaNs back in? Get the index for the time where the NaNs should be...
if A_nan_index >0
    for n = 1:length(signal_1)
        if round(signal_1(n,1),-2) == round(nan_time1,-2) %round to the nearest 100 ms since interpolation changed time variable slightly.
            A_nan_back1 = n + 1;
        end
        if round(signal_1(n,1),-2) == round(nan_time2,-2)
            A_nan_back2 = n - 1;
        end
    end
    signal_1([A_nan_back1:A_nan_back2],2)=nan;
    figure;
    plot(linspace(A.HR(1,1),A.HR(end,1),A_length),signal_1(:,2),'o-');
end

%  B/signal_2
B_length = length(B.EDA); % EDA is sampled at 15 Hz, so should be same length
B_nan_index = find(isnan(B.HR));
if B_nan_index > 0
    nan_row = B_nan_index(1,1);
    nan_time1 = B.HR(nan_row - 1,1);
    nan_time2 = B.HR(nan_row + 1,1);
    B.HR = B.HR(any(~isnan(B.HR),2),:);
end
signal_2(:,2) = interp1(B.HR(:,1),B.HR(:,2),linspace(B.HR(1,1),B.HR(end,1),B_length))';
signal_2(:,1) = linspace(B.HR(1,1),B.HR(end,1),B_length);
figure;
plot(B.HR(:,1),B.HR(:,2),'.-',linspace(B.HR(1,1),B.HR(end,1),B_length),signal_2(:,2),'o-');

%put NaNs back in? Get the index for the time where the NaNs should be...
if B_nan_index > 0
    for n = 1:length(signal_2)
        if round(signal_2(n,1),-2) == round(nan_time1,-2) %round to the nearest 100 ms since interpolation changed time variable slightly.
            B_nan_back1 = n + 1;
        end
        if round(signal_2(n,1),-2) == round(nan_time2,-2)
            B_nan_back2 = n - 1;
        end
    end
    signal_2([B_nan_back1:B_nan_back2],2)=nan;
    figure;
    plot(linspace(B.HR(1,1),B.HR(end,1),B_length),signal_2(:,2),'o-');
end

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
            
            % Set NSTE < 0 to 0
            for c = 1:length(NSTE_XY)
                if NSTE_XY(c) < 0
                    NSTE_XY(c) = 0;
                end
                if NSTE_YX(c) < 0
                    NSTE_YX(c) = 0;
                end
                
            end
            
            % Compute sum of NSTE
            sum_NSTE_XY = sum(NSTE_XY > 0);
            sum_NSTE_YX = sum(NSTE_YX > 0);
            
            save(strcat(OUT_DIR,SAVE_NAME,'_',num2str(win_size_sec(i)),'_',num2str(dim(j)),'_',num2str(tau(k,1)),'.mat'),"NSTE_YX", "NSTE_XY","plt_time","sum_NSTE_XY","sum_NSTE_YX");
            
        end
    end
end
