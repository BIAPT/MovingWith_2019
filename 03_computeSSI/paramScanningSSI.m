% Erica Flaten May 2021 
% 
% This script scans the slope window size needed for SSI and computes the total SSI sum in a session.
% Comment in/out appropriate save name, physiological mode, and
% slope_win_size range. Note that resampling section is only for HR.
%
% EDA, HR Params: 
%   Slope window size: 5:1:10 s 
%   Correlation window size: 15 s
%   SSI window size: 30 s
%   Step size for all windows: 1 s
%
% TEMP Params: 
%   Slope window size: 10:5:40 s originally, now 10-25 s
%   Correlation window size: 15 s
%   SSI window size: 30 s
%   Step size for all windows: 1 s
% ------------------
%% Set directory
clear;
cd('D:\Erica\MovingWith_2019-master\03_computeSSI')
addpath('helper_functions','D:\Erica\MovingWith_2019-master\data');
%% Input params

% Save params
OUT_DIR = 'D:\Erica\MovingWith_2019-master\data\param_scanning\SSI\';
% OUT_DIR = 'D:\Erica\PieceOfMind\param_scanning\SSI\';

SAVE_NAME = 'Dec5_P4P10_SSI_EDA'; 
% SAVE_NAME = 'Dec5_P1P2_SSI_HR';
% SAVE_NAME = 'Dec5_P1P2_SSI_TEMP';

% Load Data
% Dyads will be P1P7, P3P6, P3P11, P4P10, P8P14, P5P7, P5P11 (note, all except P5P11 showed recipricol interactions but at different times)
A = load("D:\Erica\MovingWith_2019-master\data\dec5_analysis\all_participants\P4\clean_trimmed.mat");
B = load("D:\Erica\MovingWith_2019-master\data\dec5_analysis\all_participants\P10\clean_trimmed.mat");

% A = load("D:\Erica\PieceOfMind\June_01_data_raw\P1\clean.mat");
% B = load("D:\Erica\PieceOfMind\June_01_data_raw\P2\clean.mat");

% % MAKE SURE RIGHT SIGNALS SELECTED... see below for HR
signal_1 = A.EDA;
signal_2 = B.EDA;
% signal_1 = A.TEMP; % temperature
% signal_2 = B.TEMP;

% signal_1 = A.clean.EDA;
% signal_2 = B.clean.EDA;
% signal_1 = A.clean.TEMP; % temperature
% signal_2 = B.clean.TEMP;
% for HR, see below

% % SSI Input Parameters MAKE SURE RIGHT SLOPE WIN SIZE
fs = 15;        % Sampling frequency 
corr_win_size = 15; % in seconds
corr_win_step = 1; 
ssi_win_size = 30; 
ssi_win_step = 1;
% slope_win_size = [(fs*5):30:(fs*25)]; % slope window size corresponding to 5-25 s for TEMP
slope_win_size = [(fs*5):15:(fs*10)]; % slope window size corresponding to 5-10 s for EDA and HR

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

for i = 1:length(slope_win_size)
    % Compute actual concordance 
    [ssi, corrs, Z_1, Z_2] = rolling_SSI_sweep(signal_1, signal_2, fs, corr_win_size, corr_win_step, ssi_win_size, ssi_win_step, slope_win_size(i));

    % Compute shuffled concordance 
    num_iter = 1000;
    [ssi_shuffle, corrs_shuffle] = monteCarloShuffling_SSI_sweep(signal_1, signal_2, fs, num_iter, corr_win_size, corr_win_step, ssi_win_size, ssi_win_step, slope_win_size(i));

    % Sort shuffled concordance in ascending order for each iteration 
    ssi_shuffle_sorted = sort(ssi_shuffle,1);

    for j = 1:size(ssi_shuffle_sorted,2)

        % From histogram of shuffled ssi, compute the p-value as the fraction of the distribution that
        % is more extreme than the observed ssi value.
        % we use absolute value so that both positive and negative correlations
        % count as "extreme". If pval is smaller than the critical value (0.05),
        % then the two are significantly different 
        pval(j) = (sum(abs(ssi_shuffle_sorted(:,j)) > abs(ssi(j,2))))/ (size(ssi_shuffle_sorted,1));
    end 
    
    sum_SSI = sum(abs(ssi(:,2)));
    avg_pval = mean(pval);
    slope_win = slope_win_size(i);
    
    save(strcat(OUT_DIR,SAVE_NAME,'_',num2str((slope_win_size(i)/fs)),'_',num2str(corr_win_size),'_',num2str(ssi_win_size)),'signal_1','signal_2','Z_1','Z_2','corrs','corrs_shuffle','ssi','ssi_shuffle','pval','sum_SSI','avg_pval','corr_win_size','ssi_win_size','slope_win');
    clear pval 

end
