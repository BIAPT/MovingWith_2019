% Dannie Fu 2020
% This script computes the maximum NSTE and then the feedforward, feedback,
% and asymmetry information transfer values. 

% Name of file
file_name = "S3_uncons";

% First compute max NSTE
f_FPM_maxNSTE_custom(file_name);

% Second compute the feedforward, feebback, asymmetry values
[FB, FF, asym] = FB_FF_average(file_name);