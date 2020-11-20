% Dannie Fu June 29 2020
% This script computes STE and NSTE values over a sliding window.
%
% Variables computed are STE[Y->X, X->Y], NSTE[Y->X, X->Y] 
% ------------------

clear 

% Save params
OUT_DIR = '/Volumes/Seagate/Moving With 2019/analysis/NSTE/';
SAVE_NAME = 'Nov7_P3P12_NSTE';

% Load Data 
signal1 = load("/Volumes/Seagate/Moving With 2019/data/2. Session_Nov_7/P3_TP001353_blue/clean");
signal2 = load("/Volumes/Seagate/Moving With 2019/data/2. Session_Nov_7/P12_TP001884_yellow/clean");

% Make data same length - just cut the longer one to the size of the shorter one 
length1 = length(signal1.EDA);
length2 = length(signal2.EDA);

A = 1;
if length1 > length2   
    B = length2;
else
    B = length1;
end

x = signal1.EDA(A:B,2); 
y = signal2.EDA(A:B,2); 
time = (signal1.EDA(A:B,1) - signal1.EDA(1,1))/1000; % Convert time to seconds 

%% 

% STE Input Parameters 
fs = 15;        % Sampling frequency
win_size_sec = 10;  % Window size in seconds 
win_step_sec = 1;   % Window step size in seconds. For nonoverlapping window, set win_size_sec = win_size_sec
dim = 4;        % Embedding dimension
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
ylim([0, 1])
ylabel('NSTE');
xlabel('Time (minutes)');
legend('NSTE Y->X','NSTE X->Y');
%saveas(gcf,strcat(OUT_DIR,SAVE_NAME))


% Plot STE X-Y and Y-X
figure
plot(plt_time(1:length(STE))/60, STE);
title('STE');
ylabel('STE');
xlabel('Time (minutes)');
legend('STE Y->X','STE X->Y');


%save(strcat(OUT_DIR,SAVE_NAME,'.mat'),"NSTE","plt_time","STE");
      
%% 
function [STE,NSTE,STE1,NSTE1,STE2,NSTE2]= calculate_STE(X,Y,dim,tau)

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

