% Dannie Fu August 5 2020
% This script preprocess HR and HRV data:
%
% Moving average filter 
% Cubic spline filter 
%
% ---------------------

% Moving average filter 
HR_avefilt = movmean(HR_data,15);
HRV_ZY_avefilt = movmean(HRV_ZY,15);

% If HR and HRV is NaN longer than 30 seconds (450 samples), replace with 0s,
% otherwise interpolate with nearest neighbour 
HR_avefilt = interp1gap(HR_avefilt,450,'spline','interpval',0);
HRV_ZY_avefilt = interp1gap(HRV_ZY_avefilt,450,'spline','interpval',0);


% Cubic splining function 
HR_cubic = csaps(HR_time,HR_avefilt',0.001,HR_time); 
HRV_ZY_cubic = csaps(HRV_time,HRV_ZY_avefilt',0.001,HRV_time);