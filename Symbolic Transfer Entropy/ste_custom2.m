% Dannie Fu June 29 2020
% This script compute STE and NSTE values over a sliding window.
%
% Variables computed are STE[Y->X, X->Y], NSTE[Y->X, X->Y] 
% ------------------

%% Load Data 

load("/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P4_TP001491_orange/EDA_clean_cut")
load("/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P10_TP001354_green/EDA_clean_cut")

%% Make data same length - just cut the longer one to the size of the shorter one 
x = P4_EDA_cut(1:11720,2); 
y = P10_EDA_cut(1:11720,2); 
time = (P10_EDA_cut(1:11720,1) - P10_EDA_cut(1,1))/1000; % Convert time to seconds 

%% 

% STE Input Parameters 
fs = 15;        % Sampling frequency
win_size_sec = 10;  % Window size in seconds 
win_step_sec = 1;   % Window step size in seconds. For nonoverlapping window, set win_size_sec = win_size_sec
dim = 3;        % Embedding dimension
tau = 1:2:30;   % STE lag
 
win_size = win_size_sec*fs; % Window size in samples 
win_step = win_step_sec*fs;  % Step size in samples 
win_overlap = win_size - win_step;  % Overlap size in samples 

% Split up signals into windows. Columns of X, Y are the segmented data
X = buffer(x,win_size,win_overlap,'nodelay');
Y = buffer(y,win_size,win_overlap,'nodelay');

size_X = size(X);
total_win = size_X(2)-1;  % Don't include the last window because it contains 0s 
STE = NaN(total_win,2);
NSTE = NaN(total_win,2);
STE1 = NaN(total_win,1);
NSTE1 = NaN(total_win,1);
STE2 = NaN(total_win,1);
NSTE2 = NaN(total_win,1);

for m=1:total_win-1
    [STE1(m),NSTE1(m),STE2(m),NSTE2(m)]= calculate_STE(X(:,m),Y(:,m),dim,tau);
end

for m=1:total_win
    STE(m,1)=STE1(m);    % Target to Source Y->X
    NSTE(m,1)=NSTE1(m);

    STE(m,2)=STE2(m);    % Source to Target X->Y
    NSTE(m,2)=NSTE2(m);                    
end

% Asymmetry
%asym = (NSTE1 - NSTE2) ./(NSTE1 + NSTE2);

% Plot NSTE X-Y and Y-X
plt_time = time(1:win_step:end);
plot(plt_time(1:length(NSTE))/60, NSTE);
title('NSTE');
ylabel('NSTE');
xlabel('Time (minutes)');
legend('NSTE Y->X','NSTE X->Y');

% Plot STE X-Y and Y-X
figure
plot(plt_time(1:length(STE))/60, STE);
title('STE');
ylabel('STE');
xlabel('Time (minutes)');
legend('STE Y->X','STE X->Y');
      
%% 
function [STE1,NSTE1,STE2,NSTE2]= calculate_STE(X,Y,dim,tau)

    STE = NaN(length(tau),2); % size is 15x2 because of tau
    NSTE = NaN(length(tau),2);

    delta=f_predictiontime(X,Y,50);

     % Looping through tau
    for L=1:length(tau)
        % Passing in [X Y], returns: [STE_YX STE_XY], [NSTE_YX NSTE_XY]
        [STE(L,1:2), NSTE(L,1:2)] = f_nste([X Y], dim, tau(L), delta);
    end
    
    [mxNSTE, ~]=max(NSTE); %mxNSTE and mxNTau
    [mxSTE, ~]=max(STE); 
   
    % Target to Source Y->X
    STE1 =mxSTE(1);    
    NSTE1 =mxNSTE(1);

    % Source to Target X->Y
    STE2=mxSTE(2);    
    NSTE2=mxNSTE(2);
end

