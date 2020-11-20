function [ssi_final, corrs, Z_1, Z_2] = rolling_SSI(subj1, subj2, fs,corr_win_size, corr_win_step, ssi_win_size, ssi_win_step)
% This function computes the rolling Single Session Index based on the
% paper Marci and Orr 
%   input - signal 1, signal 2, sampling frequency 
%   output - ssi, pearson correlations


% Time
time = subj1(:,1);
time_idx = 1:fs:length(time);

% Z Score Standardization
zscor_xnan = @(x) bsxfun(@rdivide, bsxfun(@minus, x, mean(x,'omitnan')), std(x, 'omitnan'));
Z_1 = zscor_xnan(subj1(:,2));
Z_2 = zscor_xnan(subj2(:,2));

% Average slope over 5s sliding window with 1s step size -> results in data that has 1HZ fs
win_size =  fs*5; % Window size in samples 
win_step = fs*1;  % Increment size in samples
win_overlap = win_size - win_step; % Overlap 

S_1 = buffer(Z_1,win_size,win_overlap,'nodelay');
S_2 = buffer(Z_2,win_size,win_overlap,'nodelay');

slopes_1 = diff(S_1);
slopes_2 = diff(S_2);

ave_slopes_1 = mean(slopes_1);
ave_slopes_2 = mean(slopes_2);

%% Params for computing correlation and SSI

% Pearson Correlation params
corr_win_overlap = corr_win_size - corr_win_step;

% SSI params 
ssi_win_overlap = ssi_win_size - ssi_win_step;

% Segment slopes into windows to compute actual correlations
corr_wins_1 = buffer(ave_slopes_1,corr_win_size,corr_win_overlap,'nodelay');
corr_wins_2 = buffer(ave_slopes_2,corr_win_size,corr_win_overlap,'nodelay');

% Pre-allocate the correlation matrix 
R = zeros(1,length(corr_wins_1));

% Compute actual correlation between signal 1 and signal 2 
for i=1:length(corr_wins_1)
    
    R(i) = xcorr(corr_wins_1(:,i),corr_wins_2(:,i),0,"coeff");
    
    % Using the 'coeff' option will give you NaNs bc its normalizing by the
    % product of the input norms. The norm of the zero vector is 0, so you have a vector of 0
    if isnan(R(i))
        R(i) = 0;
    end 
end 

% Segment actual correlations in windows to compute SSI
ssi_wins = buffer(R, ssi_win_size, ssi_win_overlap, 'nodelay');

% Pre-allocate the ssi matrix
ssi = zeros(1,length(ssi_wins));

% Compute SSI
for j=1:length(ssi_wins)
    
    % Ratio of sum of positive corrs over sum of negative corrs
    ssi(j) = sum(ssi_wins(:,j).*(ssi_wins(:,j)>0))./abs(sum(ssi_wins(:,j).*(ssi_wins(:,j)<0)));

    % SSI returns Inf when there are no negative correlations (similar case when no positive correlations) in a
    % window. For now just making it the same value as previous.
    if(sum(ssi_wins(:,j).*(ssi_wins(:,j)<0)) == 0 || sum(ssi_wins(:,j).*(ssi_wins(:,j)>0)) == 0 )
        if j==1
            ssi(j) = 1; % set to 1 because then ssi = log 1 = 0
        else 
            ssi(j) = ssi(j-1);
        end 
    end 

    if(sum(ssi_wins(:,j)) == 0)
        ssi(j) = 1;
    end 
end 

% Natural log of SSI to account for skew
ssi = log(ssi);


R_time = time(time_idx(1:length(R)));
corrs(:,1) = R_time;
corrs(:,2) = R;

ssi_time = time(time_idx(1:length(ssi)));
ssi_final(:,1) = ssi_time;
ssi_final(:,2) = ssi;

end 