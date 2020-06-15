% Dannie Fu June 15 2020
% This script compute STE and NSTE values over a sliding window.
%
% Variables are STE[Y->X, X->Y], NSTE[Y->X, X->Y] 
% ------------------

% Load the data
target_signal = EDA_clean_P1(:,2); % target and source signal have to be same length
source_signal = EDA_clean_P3(1:26022,2);

% Params 
samp_freq = 15;
win_size = 10; % window size in seconds 
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

% Calculate STE using a sliding window 
for m=1:TotalWin
    [STE1(m),NSTE1(m),STE2(m),NSTE2(m)]= calculate_STE(m,win_size,target_signal,source_signal,dim,tau);
end

for m=1:TotalWin
    STE(m,1)=STE1(m);    % Target to Source Y->X
    NSTE(m,1)=NSTE1(m);

    STE(m,2)=STE2(m);    % Source to Target X->Y
    NSTE(m,2)=NSTE2(m);                    
end
       
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