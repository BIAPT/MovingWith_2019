% Dannie Fu March 12 2021
% This script computes asymmetry from NSTE XY and NSTE YX
%
% ------------------------

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/final/0_preprocessed/NSTE/asym_15/connection/";
LOAD_NAME = "Dec5_P8P14_NSTE";
SAVE_DIR = LOAD_DIR;
SAVE_NAME = strcat(LOAD_NAME,"_asym_15.mat");

asym_win_size = 15;

load(strcat(LOAD_DIR, LOAD_NAME));

% set all negative values of nste to 0
NSTE_XY(NSTE_XY < 0) = 0;
NSTE_YX(NSTE_YX < 0) = 0;

asym_XY = (NSTE_XY - NSTE_YX)./(NSTE_XY + NSTE_YX);
asym_XY(isnan(asym_XY)) = 0;

% try taking average asymmetry across sliding windows of 5 seconds no
% overlap
asym_wins = buffer(asym_XY,asym_win_size,0,'nodelay');

asym_ave = mean(asym_wins,1,'omitnan');

save(strcat(SAVE_DIR,SAVE_NAME),"asym_XY","asym_ave");


