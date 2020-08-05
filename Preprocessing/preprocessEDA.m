% Dannie Fu August 4 2020
%
% This script preprocesses EDA based on procedure from Kleckner, et al.:
%   Rules for determining invalid data:
%   1. EDA is out of valid range (e.g., not within 0.05-60 uS)
%   2. EDA changes too quickly (e.g., faster than +-10 ?S/sec)
%   3. EDA data surrounding (e.g., within 4 sec of) invalid portions from rules 1-2 are also invalid
%
% Additional preprocessing:
%  1D median filter 
%  Moving average filter 
%  1euro filter 
% -----------------------

% 1D median filter
EDA_medfilt = medfilt1(EDA_data,75,'truncate'); 

% Moving average filter 
EDA_avefilt = movmean(EDA_medfilt,15); %Window size 15, arbitrarily chosen 

% Find outliers (3 Median Absolute Deviations away from median)
TF = isoutlier(EDA_avefilt, 'median');
outliers = find(TF); % Index of outliers 

% Calculate instantaneous slope 
slope = [0; diff(EDA_avefilt) ./ 15];

% Find idx of all points that are out of range and where the slope changes too
% rapidly
EDA_invalid = find(EDA_avefilt < 0.05 | EDA_avefilt > 60 | abs(slope) > 10);
EDA_invalid = [EDA_invalid; outliers];

% Data within 4 seconds (60 samples) of invalid EDA is also set to NaN.
radius = 30;
for d = 1:length(EDA_invalid)
    
    if ( EDA_invalid(d) - radius < 1 ) 
        idx_bad = 1:EDA_invalid(d) + radius;
    elseif ( EDA_invalid(d) + radius > length(EDA_avefilt) ) 
        idx_bad = EDA_invalid(d) - radius:EDA_invalid(end);
    else
        idx_bad = EDA_invalid(d) - radius:EDA_invalid(d) + radius;
    end 
    
    EDA_avefilt(idx_bad) = NaN;
end

% If EDA is NaN longer than 30 seconds (450 samples), replace with 0s, otherwise,
% interpolate with cubic spline
EDA_avefilt = interp1gap(EDA_avefilt,450,'spline','interpval',0);

% Apply 1 euro filter 
a = oneEuro; % Declare oneEuro object
a.mincutoff = 50.0; % Decrease this to get rid of slow speed jitter
a.beta = 4.0; % Increase this to get rid of high speed lag

EDA_eurofilt = zeros(size(EDA_avefilt'));
for i = 1:length(EDA_avefilt)
    EDA_eurofilt(i) = a.filter(EDA_avefilt(i),i);
end
        
%% Plot 
% 
% plot((EDA_time-EDA_time(1))/1000,EDA_data,'LineWidth',1);
% hold on;
% plot((EDA_time-EDA_time(1))/1000,EDA_medfilt,'LineWidth',1);
% hold on;
% plot((EDA_time-EDA_time(1))/1000,EDA_avefilt,'LineWidth',1);
% hold on;
% plot((EDA_time-EDA_time(1))/1000, EDA_eurofilt,'LineWidth',2);
% 
% legend('EDA raw','EDA medfilt','EDA avefilt','EDA eurofilt');
