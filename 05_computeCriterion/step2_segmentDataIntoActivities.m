% Dannie Fu March 16 2021 
%
% This script segments the SSI and NSTE data into specific portions of the
% Moving With session.
% ----------------------------------------
clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/final/1_missingtoNaN/asym_15/";
SAVE_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/final/2_segmented/asym_15/";

asym_win_size = 15;

% Uncomment depending on which one you want to segment

% activity = "musicaltextures";
% start_dur = duration(0,0,0);
% end_dur = duration(0,7,0);

% activity = "resistance_sit";
% start_dur = duration(0,11,0);
% end_dur = duration(0,17,15);
% 
% activity = "resistance_stand";
% start_dur = duration(0,20,0);
% end_dur = duration(0,22,30);
% 
% activity = "improv";
% start_dur = duration(0,24,50);
% end_dur = duration(0,26,55);


files = dir(fullfile(LOAD_DIR,'*.mat'));

for i=1:length(files)
    
    load(strcat(LOAD_DIR,files(i).name));
 
    % Segment preprocessed signal (signal_1, signal_2), and zscore st
    % andardized signals (Z_1, Z_2)
    t = unix_to_datetime(signal_1(:,1));
    t2 = t(:) - t(1);
    start_idx = find(t2(:) >= start_dur,1,'first');
    end_idx = find(t2(:) <= end_dur,1,'last');

    signal_1_segment = signal_1(start_idx:end_idx,:);
    signal_2_segment = signal_2(start_idx:end_idx,:);
    Z_1_segment = Z_1(start_idx:end_idx,:);
    Z_2_segment = Z_2(start_idx:end_idx,:);

    % Segment pearson correlation variable (corrs)
    t = unix_to_datetime(corrs(:,1));
    t1 = t(:) - t(1);
    start_idx = find(t1(:) >= start_dur,1,'first');
    end_idx = find(t1(:) <= end_dur,1,'last');

    corrs_segment = corrs(start_idx:end_idx,:);

    % Segment ssi and ssi pvals (ssi, pval)
    t = unix_to_datetime(ssi(:,1));
    t1 = t(:) - t(1);
    start_idx = find(t1(:) >= start_dur,1,'first');
    end_idx = find(t1(:) <= end_dur,1,'last');

    ssi_segment = ssi(start_idx:end_idx,:);
    pval_segment = pval(start_idx:end_idx);
    
    % Segment NSTE and asym (NSTE_XY, NSTE_YX, asym_XY)
    t = unix_to_datetime(nste_time);
    t1 = t(:) - t(1);
    start_idx = find(t1(:) >= start_dur,1,'first');
    end_idx = find(t1(:) <= end_dur,1,'last');
    
    NSTE_XY_segment = NSTE_XY(start_idx:end_idx);
    NSTE_YX_segment = NSTE_YX(start_idx:end_idx);
    asym_XY_segment = asym_XY(start_idx:end_idx);
    nste_time_segment = nste_time(start_idx:end_idx);

    % Segment average asym (asym_ave)
    t = unix_to_datetime(nste_time(1:asym_win_size:end));
    t1 = t(:) - t(1);
    start_idx = find(t1(:) >= start_dur,1,'first');
    end_idx = find(t1(:) <= end_dur,1,'last');

    asym_ave_segment = asym_ave(start_idx:end_idx);
    
    file_name = split(files(i).name,'.');
    save_name = strcat(char(file_name(1)),"_",activity,".mat");

    save(strcat(SAVE_DIR,save_name),"asym_ave_segment","asym_XY_segment","corrs_segment", ...
        "signal_1_segment","signal_2_segment","NSTE_XY_segment","NSTE_YX_segment",...
        "pval_segment","Z_1_segment","Z_2_segment", "ssi_segment", "nste_time_segment");
end 
