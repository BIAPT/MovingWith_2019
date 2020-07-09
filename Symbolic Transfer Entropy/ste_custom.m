% Dannie Fu June 15 2020
% This script compute STE and NSTE values over an NON overlapping sliding window.
%
% Variables computed are STE[Y->X, X->Y], NSTE[Y->X, X->Y] 
%
% ------------------

%% Load the data
load("/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P4_TP001491_orange/EDA_clean_cut")
load("/Volumes/Seagate/Moving With 2019/5. Session_Dec_5/P10_TP001354_green/EDA_clean_cut")

%% Make data same length - just cut the longer one to the size of the
% shorter one 
source_signal = P4_EDA_cut(1:length(P10_EDA_cut),2); % X
target_signal = P10_EDA_cut(:,2); % Y
time = (P10_EDA_cut(:,1) - P10_EDA_cut(1,1))/1000; % Convert time to seconds 

%% STE 

% Params 
samp_freq = 15;
win_size = 10; % sliding window size in seconds 
dim=3; % May need to change
tau=1:2:30; % May need to change

% Set up the variables needed for ste analysis
win_size=(win_size)*samp_freq;% 
TotalWin=floor(length(target_signal)/win_size); % Total number of windows

STE = NaN(TotalWin,2);
NSTE = NaN(TotalWin,2);

STE1 = NaN(TotalWin,1);
NSTE1 = NaN(TotalWin,1);
STE2 = NaN(TotalWin,1);
NSTE2 = NaN(TotalWin,1);

% Calculate STE using a nonoverlapping sliding window 
for m=1:TotalWin
    [STE1(m),NSTE1(m),STE2(m),NSTE2(m)]= calculate_STE(m,win_size,target_signal,source_signal,dim,tau);
end

for m=1:TotalWin
    STE(m,1)=STE1(m);    % Target to Source Y->X
    NSTE(m,1)=NSTE1(m);

    STE(m,2)=STE2(m);    % Source to Target X->Y
    NSTE(m,2)=NSTE2(m);                    
end

% Plot NSTE X-Y and Y-X
x = 1:win_size:length(target_signal);
plt_time = time(x)/60;
plot(plt_time(1:length(NSTE)), NSTE,'Marker','.');
title('NSTE');
ylabel('NSTE');
xlabel('Time (minutes)');
legend('NSTE Y->X','NSTE X->Y');

% Plot STE X-Y and Y-X
figure
plot(plt_time(1:length(STE)), STE,'Marker','.');
title('STE');
ylabel('STE');
xlabel('Time (minutes)');
legend('STE Y->X','STE X->Y');
      
%% 

function [STE1,NSTE1,STE2,NSTE2]= calculate_STE(m,win_size,target,source,dim,tau)

    STE = NaN(length(tau),2); % size is 15x2 because of tau
    NSTE = NaN(length(tau),2);

    ini_point=(m-1)*win_size+1;
    final_point=ini_point+win_size-1;

    x=source(ini_point:final_point);
    y=target(ini_point:final_point);

    delta=f_predictiontime(x,y,50);

    for L=1:length(tau) % Looping through tau. Tau increments by 2
        
        % Passing in [X Y], returns: [STE_YX STE_XY], [NSTE_YX NSTE_XY]
        [STE(L,1:2), NSTE(L,1:2)] = f_nste([x y], dim, tau(L), delta);
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