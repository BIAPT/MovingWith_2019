% Dannie Fu August 5 2020
% This function preprocess HR and HRV data:
%
% Moving average filter 
% Cubic spline filter 
%
% ---------------------

function [HR_avefilt, HR_cubic, HRV_ZY_avefilt, HRV_ZY_interp, HRV_ZY_cubic] = preprocessHR(HR_data, HR_time, HRV_ZY, HRV_time)


% Moving average filter 
HR_avefilt = movmean(HR_data,5);
HRV_ZY_avefilt = movmean(HRV_ZY,5);

% If HRV is NaN shorter than 30 seconds interpolate with cubic spline 
HRV_ZY_interp = interp1gap(HRV_ZY_avefilt,450,'pchip');

% IF HRV is NaN longer than 30 seconds, interpolate with previous non NaN value value 
HRV_ZY_interp = fillmissing(HRV_ZY_interp,'previous');

% Cubic splining function 
HR_cubic = csaps(HR_time,HR_avefilt',0.001,HR_time); 
HRV_ZY_cubic = csaps(HRV_time,HRV_ZY_interp',0.001,HRV_time);

end 