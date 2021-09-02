function [ssi_shuffle, R_shuffle] = monteCarloShuffling_SSI_sweep(subj1, subj2, fs, num_iter, corr_win_size, corr_win_step, ssi_win_size, ssi_win_step,slope_win_size)
% This function computes the rolling ssi for shuffled windows for 1000
% iterations

% A problem with Pearson correlation is that the data often shows sequential dependency 
% (autocorrelation) and is non stationary (changing mean and variance over
% time). We use Monte Carlo shuffling to test whether the concordances we
% compute are significant or are just spurious correlations due to
% autocorrelation.

% We pose the null hypothesis that the actual concordances do not differ from the shuffled 
% concordances. Under the null hypothesis, we should be able to shuffle the pearson correlation 
% windows and compute the concordances and it would be the same as the
% actual concordances.

% ----------------

% Z Score Standardization
zscor_xnan = @(x) bsxfun(@rdivide, bsxfun(@minus, x, mean(x,'omitnan')), std(x, 'omitnan'));
Z_1 = zscor_xnan(subj1(:,2));
Z_2 = zscor_xnan(subj2(:,2));

% Average slope over sliding window with 1s step size -> results in data that has 1HZ fs
win_size =  slope_win_size; % Window size in samples 
win_step = fs*1;  % Increment size in samples
win_overlap = win_size - win_step; % Overlap 

S_1 = buffer(Z_1,win_size,win_overlap,'nodelay');
S_2 = buffer(Z_2,win_size,win_overlap,'nodelay');

slopes_1 = diff(S_1).*fs; % Slope = dy/dx, where dx is 1/fs = 1/15. 
slopes_2 = diff(S_2).*fs;

ave_slopes_1 = mean(slopes_1);
ave_slopes_2 = mean(slopes_2);

corr_win_overlap = corr_win_size - corr_win_step;
ssi_win_overlap = ssi_win_size - ssi_win_step;

% Segment slopes for subject 1 into windows to compute correlations
corr_wins_1 = buffer(ave_slopes_1,corr_win_size,corr_win_overlap,'nodelay');

% Pre-allocate the correlation matrix [1000 x num_wins]
R_shuffle = zeros(num_iter,length(corr_wins_1));

% Pre-allocate the matrix with SSI for each iteration
% ssi_shuffle = zeros(num_iter,length(corr_wins_1));

% 1000 iterations for computing the shuffled correlations 
for k=1:num_iter
    %disp(['Iteration ',num2str(k)]);
    
    % Get random windows from second subject 
    rand_corr_wins_2 = getRandWindows(ave_slopes_2, size(corr_wins_1));
    
    % Compute correlations between signal 1 and random signal 2 windows
    for i=1:length(corr_wins_1)
        
        R_shuffle(k,i) = xcorr(corr_wins_1(:,i),rand_corr_wins_2(:,i),0,"coeff");

        % Using the 'coeff' option will give you NaNs bc its normalizing by the
        % product of the input norms. The norm of the zero vector is 0, so you have a vector of 0
        if isnan(R_shuffle(k,i))
            R_shuffle(k,i) = 0;
        end 
    end 
    
    % Segment actual correlations in windows to compute SSI
    ssi_wins = buffer(R_shuffle(k,:), ssi_win_size, ssi_win_overlap, 'nodelay');

    % Compute SSI
    for j=1:length(ssi_wins)

        % Ratio of sum of positive corrs over sum of negative corrs
        ssi_shuffle(k,j) = sum(ssi_wins(:,j).*(ssi_wins(:,j)>0))./abs(sum(ssi_wins(:,j).*(ssi_wins(:,j)<0)));
        
        % SSI returns Inf when there are no negative correlations (similar case when no positive correlations) in a
        % window. For now just making it the same value as previous.
        if(sum(ssi_wins(:,j).*(ssi_wins(:,j)<0)) == 0 || ...
           sum(ssi_wins(:,j).*(ssi_wins(:,j)>0)) == 0 || ...
           sum(ssi_wins(:,j)) == 0)
            if j==1
                ssi_shuffle(k,j) = 1; % set to 1 because then ssi = log 1 = 0
            else 
                ssi_shuffle(k,j) = ssi_shuffle(k,j-1);
            end 
        end 
        
        % Natural log of SSI to account for skew
        ssi_shuffle(k,j) = log(ssi_shuffle(k,j));
    end 

end 

end 