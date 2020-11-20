% Dannie Fu August 4 2020
%
% This function preprocesses EDA.
%
% Preprocessing Steps :
%  1D median filter 
%  Moving average filter 
%  Cubic Spline Interpolation 
%  1euro filter 
% -----------------------

function [EDA_medfilt, EDA_avefilt, EDA_interp, EDA_eurofilt] = preprocessEDA(EDA_data)

% 1D median filter
EDA_medfilt = medfilt1(EDA_data,75,'truncate'); 

% Moving average filter 
EDA_avefilt = movmean(EDA_medfilt,10); %Window size 10, arbitrarily chosen 

EDA_interp = interpEDA(EDA_avefilt);

% Apply 1 euro filter 
a = oneEuro; % Declare oneEuro object
a.mincutoff = 50.0; % Decrease this to get rid of slow speed jitter
a.beta = 30.0; % Increase this to get rid of high speed lag

EDA_eurofilt = zeros(size(EDA_interp'));
for i = 1:length(EDA_interp)
    EDA_eurofilt(i) = a.filter(EDA_interp(i),i);      
end

% transpose so it's a column instead of row when returning value
EDA_interp = EDA_interp';
EDA_avefilt = EDA_avefilt';

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
