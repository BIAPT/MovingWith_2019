% Dannie Fu September 11 2020
% This script compute the Single Session Index based on the paper Marci and Orr
% (2006) with modifications based on other papers
%
% ------------------

% Load Data
A = load("/Volumes/Seagate/Moving With 2019/1. Session_Oct_31/P1_TP001689_green/EDA_clean_cut.mat");
B = load("/Volumes/Seagate/Moving With 2019/1. Session_Oct_31/P3_TP001353_blue/EDA_clean_cut.mat");

% Z Score Standardization
Z_A = zscore(A.EDA_clean_cut(:,2));
Z_B = zscore(B.EDA_clean_cut(:,2));

% Average slope over 5s sliding window with 1s step size 
fs = 15; % Sampling frequency 
win_size =  fs*5; % Window size in samples 
win_step = fs*1;  % Increment size in samples
win_overlap = win_size - win_step; % Overlap 

S_A = buffer(Z_A,win_size,win_overlap,'nodelay');
S_B = buffer(Z_B,win_size,win_overlap,'nodelay');

slopes_A = diff(S_A);
slopes_B = diff(S_B);

ave_slopes_A = mean(slopes_A);
ave_slopes_B = mean(slopes_B);

% Pearson Correlation over sliding 15s window, 1s step size
corr_win_size = 15;
corr_win_step = 1;
corr_win_overlap = corr_win_size - corr_win_step;

corr_wins_A = buffer(ave_slopes_A,corr_win_size,corr_win_overlap,'nodelay');
corr_wins_B = buffer(ave_slopes_B,corr_win_size,corr_win_overlap,'nodelay');

for i=1:length(corr_wins_A)
    %  R is a 2-by-2 matrix with ones along the diagonal and the correlation coefficients along the off-diagonal.
    R(i) = xcorr(corr_wins_A(:,i),corr_wins_B(:,i),0,"coeff");
end 

% Rolling window Single Session Index over 60s window
ssi_win_size = 60;
ssi_win_step = 1;
ssi_win_overlap = ssi_win_size - ssi_win_step;

ssi_wins = buffer(R,ssi_win_size,ssi_win_overlap,'nodelay');

for j=1:length(ssi_wins)
    ssi(j) = sum(ssi_wins(:,j).*(ssi_wins(:,j)>0))./abs(sum(ssi_wins(:,j).*(ssi_wins(:,j)<0)));
end 

ssi_ln = log(ssi);




