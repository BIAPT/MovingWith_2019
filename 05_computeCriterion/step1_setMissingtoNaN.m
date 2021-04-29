% Dannie Fu March 16 2021 
% This script loads preprocessed EDA signal, locates if there are any
% missing data (NaNs) and sets the values at those times (plus and minus 10 seconds) in the SSI and NSTE
% variables to NaN

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/analysis/Dec5_analysis/abstract_participants/01_preprocessed/";
LOAD_DIR_SSI = strcat(LOAD_DIR, "SSI/noconnection/");
LOAD_DIR_NSTE = strcat(LOAD_DIR, "NSTE/noconnection/");

SAVE_DIR =  "/Volumes/Seagate/Moving With 2019/analysis/Dec5_analysis/abstract_participants/02_trimmed/";

ssi_files = dir(fullfile(LOAD_DIR_SSI,'*.mat'));
nste_files = dir(fullfile(LOAD_DIR_NSTE,'*.mat'));

for i = 1:length(ssi_files)
    file_name = split(ssi_files(i).name, ".");
    save_name = strcat(char(file_name(1)),"_NSTE_trim.mat");
    
    load(strcat(LOAD_DIR_SSI, ssi_files(i).name)); % loading ssi
    load(strcat(LOAD_DIR_NSTE, nste_files(2*i-1).name)); % loading nste file
    load(strcat(LOAD_DIR_NSTE, nste_files(2*i).name)); % loading asymmetry nste 
    
    % Get idx of first and last nan of signal 1 
    nan_idx_first_1 = find(isnan(signal_1(:,2)),1,'first');
    nan_idx_last_1 = find(isnan(signal_1(:,2)),1,'last');

    nan_begintime_1 = signal_1(nan_idx_first_1,1);
    nan_endtime_1 = signal_1(nan_idx_last_1,1);

    % Get idx of first and last nan of signal 2 
    nan_idx_first_2 = find(isnan(signal_2(:,2)),1,'first');
    nan_idx_last_2 = find(isnan(signal_2(:,2)),1,'last');

    nan_begintime_2 = signal_2(nan_idx_first_2,1);
    nan_endtime_2 = signal_2(nan_idx_last_2,1);


    if ~isempty(nan_begintime_1) && ~isempty(nan_begintime_2)  % Use the earlier nan start time and later nan end time 
        nan_start = min(nan_begintime_1, nan_begintime_2);
        nan_end = max(nan_endtime_1,nan_endtime_2);

    elseif isempty(nan_begintime_1) && isempty(nan_begintime_2) %If both signals dont have nan, save continue to next dyad
        
        save(strcat(SAVE_DIR,save_name), "asym_ave","asym_XY","corrs","corrs_shuffle", ...
        "signal_1","signal_2","NSTE_XY","NSTE_YX","pval","Z_1","Z_2",...
        "STE_XY", "STE_YX", "ssi");
    
        clear asym_ave asym_XY corrs corrs_shuffle  ...
        signal_1 signal_2 NSTE_XY NSTE_YX pval Z_1 Z_2 ...
        STE_XY STE_YX ssi;
    
        continue;   

    elseif isempty(nan_begintime_1) % If signal 1 does not have nan but signal 2 does, use signal 2 start and end nan times 
        nan_start = nan_begintime_2;
        nan_end = nan_endtime_2;

    elseif isempty(nan_begintime_2) % If signal 2 does not have nan but signal 1 does, use signal 1 start and end nan times 
        nan_start = nan_begintime_1;
        nan_end = nan_endtime_1;
    end

    % Find indices where nan begin and ends. NSTE has same sampling rate as
    % SSI. Asym 
    [~, idx_Start] = min(abs(ssi(:,1) - nan_start));
    [~, idx_End] = min(abs(ssi(:,1) - nan_end));
    [~, idx_Start_asym] = min(abs(ssi(1:5:end,1) - nan_start));
    [~, idx_End_asym] = min(abs(ssi(1:5:end,1) - nan_end));

    % Set ssi and nste to nan when the original signal is nan (set values 60
    % second starting 60 seconds before to nan too). Note : NSTE, SSI,
    % asym_XY have fs of 1Hz,  but asym_ave averages NSTE over 5
    % seconds.
    ssi(idx_Start-60:idx_End,2) = nan;
    pval(idx_Start-60:idx_End) = nan;
    NSTE_XY(idx_Start-60:idx_End) = nan;
    NSTE_YX(idx_Start-60:idx_End) = nan;
    asym_XY(idx_Start-60:idx_End) = nan;
    asym_ave(idx_Start_asym-12:idx_End_asym) = nan; % asym takes the ave nste over 5 sec windows so 60 samples NSTE = 12 samples asym = 60 sec
    
    save(strcat(SAVE_DIR,save_name), "asym_ave","asym_XY","corrs","corrs_shuffle", ...
        "signal_1","signal_2","NSTE_XY","NSTE_YX","pval","Z_1","Z_2",...
        "STE_XY", "STE_YX", "ssi");
    
     clear asym_ave asym_XY corrs corrs_shuffle  ...
        signal_1 signal_2 NSTE_XY NSTE_YX pval Z_1 Z_2 ...
        STE_XY STE_YX ssi;
end 


%% Plot 
tiledlayout(6,1);

t = unix_to_datetime(signal_1(:,1));
t1 = t(:) - t(1);

ax1 = nexttile;
plot(ax1, t1,signal_1(:,2),'LineWidth',1);
hold(ax1,'on')
plot(ax1, t1,signal_2(:,2),'LineWidth',1);
legend('X', 'Y');
title("EDA Signal");

ax2 = nexttile;
plot(ax2, t1,Z_1,'LineWidth',1);
hold(ax2,'on')
plot(ax2, t1,Z_2,'LineWidth',1);
legend('X', 'Y');
title('Z score standardized EDA Signal');

t = unix_to_datetime(corrs(:,1));
t2 = t(:) - t(1);

ax3 = nexttile;
plot(ax3, t2,corrs(:,2),'LineWidth',1);
title('Pearson Corrs');
yline(0,'b-')

t = unix_to_datetime(ssi(:,1));
t3 = t(:) - t(1);

ax4 = nexttile;
plot(ax4, t3, ssi(:,2),'LineWidth',1);
yline(0,'b-')

% NSTE should be using same time as ssi because there should be 1 sample
% per second.
t = unix_to_datetime(ssi(:,1));
t4 = t(:) - t(1);

NSTE = [NSTE_XY;NSTE_YX];

ax5 = nexttile;
plot(ax5,t4(1:length(NSTE_XY)), NSTE_XY,'LineWidth',1);
hold on;
plot(ax5,t4(1:length(NSTE_XY)), NSTE_YX,'LineWidth',1);
legend('NSTE X->Y', 'NSTE Y->X');
title('NSTE');
ylim([0, max(NSTE)])
ylabel('NSTE');
xlabel('Time (minutes)');

t = unix_to_datetime(ssi(1:5:end,1));
t5 = t(:) - t(1);

ax6 = nexttile;
plot(ax6,t5(1:length(asym_ave)), asym_ave,'LineWidth',1);
title('Ave Asymmetry X-Y Over 5 sec windows');
ylabel('asym');
xlabel('Time (minutes)');
yline(0);

