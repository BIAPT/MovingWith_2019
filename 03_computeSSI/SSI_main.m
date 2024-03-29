% Dannie Fu October 28 2020
%
% This script calls rolling_SSI function (observed ssi) and
% monteCarloShuffling_SSI (shuffled ssi) function and determines whether
% the observed is statistically significant.
%
% Need to specify:
%   LOAD_DIR, OUT_DIR
%   participants  - all participants in the Moving With session. Each participant is a folder.
%   dyads - the dyads you want to run SSI on. Each dyad is a row.
% ------------------

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/data/5. Session_Dec_5/";
OUT_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/abstract_fixed_SSI_slopes/rerun_clean_trimmed/";

participants = {'P1','P2','P3','P4','P5','P6','P7','P8','P10','P11','P14'};
dyads = {'P1','P7'}; % each dyad is a row

% loop through dyads
for i=1:size(dyads,1)
    
    disp(strcat('Dyad: ',dyads(i,1),dyads(i,2)));
    
    savename = strcat('Dec5_',dyads(i,1),dyads(i,2),'_SSI');
    
    A = load(strcat(LOAD_DIR, char(dyads(i,1)),'/clean_trimmed.mat'));
    B = load(strcat(LOAD_DIR, char(dyads(i,2)),'/clean_trimmed.mat'));
    
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

    % Params in seconds
    corr_win_size = 15;
    corr_win_step = 1;
    ssi_win_size = 30;
    ssi_win_step = 1;
    fs = 15;

    % Compute actual concordance 
    [ssi, corrs, Z_1, Z_2] = rolling_SSI(signal_1, signal_2, fs, corr_win_size, corr_win_step, ssi_win_size, ssi_win_step);

    % Compute shuffled concordance 
    num_iter = 1000;
    [ssi_shuffle, corrs_shuffle] = monteCarloShuffling_SSI(signal_1, signal_2, fs, num_iter, corr_win_size, corr_win_step, ssi_win_size, ssi_win_step);

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

    save(strcat(OUT_DIR,savename),'signal_1','signal_2','Z_1','Z_2','corrs','corrs_shuffle','ssi','ssi_shuffle','pval');
    
    clear signal_1 signal_2 Z_1 Z_2 corrs corrs_shuffle ssi ssi_shuffle pval;

end 

