% Erica Flaten July 12, 2021
% Use this script to plot the musical textures portion of the Dec 5th data,
% either the less filtered data, clean_trimmed data, or the raw signals.
participants = ["P1" "P2" "P3" "P4" "P5" "P6" "P7" "P8" "P10" "P11" "P14"];
start_time = importdata("C:\Users\erica\Documents\PNB\NSERC_Create\Internship\MovingWith_2019-master\data\dec5_analysis\all_participants\Original Data\start_recording_time.txt");

%% Plot less filtered data
for p = 1:length(participants)
    load(strcat('C:\Users\erica\Documents\PNB\NSERC_Create\Internship\MovingWith_2019-master\data\dec5_analysis\all_participants_not_processed\',participants(p),'\clean_less_filtering.mat'))
    
    %Trim to video length
    EDA_start_index = find((round(clean.EDA(:,1),-2)==round(start_time,-2)),1);
    TEMP_start_index = find((round(clean.TEMP(:,1),-2)==round(start_time,-2)),1);
    if round(clean.HR(:,1),-2)==round(start_time,-2)
        HR_start_index = find((round(clean.HR(:,1),-2)==round(start_time,-2)),1);
    elseif round(clean.HR(:,1),-3)==round(start_time,-3)
        HR_start_index = find((round(clean.HR(:,1),-3)==round(start_time,-3)),1);
    else
        HR_start_index = find((round(clean.HR(:,1),-4)==round(start_time,-4)),1);
    end
    EDA = clean.EDA((EDA_start_index:end),:);
    TEMP = clean.TEMP((TEMP_start_index:end),:);
    HR = clean.HR((HR_start_index:end),:);
    
    figure
    
    subplot(3,1,1)
    t_eda = unix_to_datetime(EDA(:,1));
    t1 = t_eda(:) - t_eda(1);
    for time1 = 1:length(t1)
        if t1(time1) == '00:07:00'
            x_end_eda = t1(time1);
        end
    end
    plot(t1,EDA(:,2),'LineWidth',1)
    title(['Musical Textures for ',participants(p)]);
    xlim([0 x_end_eda])
    ylabel("EDA (us)")
    set(gca,'FontSize',14)
    
    subplot(3,1,2)
    t_temp = unix_to_datetime(TEMP(:,1));
    t2 = t_temp(:) - t_temp(1);
    for time2 = 1:length(t2)
        if t2(time2) == '00:07:00'
            x_end_temp = t2(time2);
        end
    end
    plot(t2,TEMP(:,2),'LineWidth',1)
    xlim([0 x_end_temp])
    ylabel("Temperature (C)")
    set(gca,'FontSize',14)
    
    subplot(3,1,3)
    t_hr = unix_to_datetime(HR(:,1));
    t3 = t_hr(:) - t_hr(1);
    for time3 = 1:length(t3)
        if round(t3(time3)) == '00:06:59'
            x_end_hr = t3(time3);
        end
    end
    plot(t3, HR(:,2),'LineWidth',1)
    xlim([0 x_end_hr])
    ylabel("Heart rate")
    set(gca,'FontSize',14)
    
end

%% Plot clean_trimmed data
for p = 1:length(participants)
    load(strcat('C:\Users\erica\Documents\PNB\NSERC_Create\Internship\MovingWith_2019-master\data\dec5_analysis\all_participants\',participants(p),'\clean_trimmed.mat'))
    figure
    
    subplot(3,1,1)
    t_eda = unix_to_datetime(EDA(:,1));
    t1 = t_eda(:) - t_eda(1);
    for time1 = 1:length(t1)
        if t1(time1) == '00:07:00'
            x_end_eda = t1(time1);
        end
    end
    plot(t1,EDA(:,2),'LineWidth',1)
    title(['Musical Textures for ',participants(p)]);
    xlim([0 x_end_eda])
    ylabel("EDA (us)")
    set(gca,'FontSize',14)
    
    subplot(3,1,2)
    t_temp = unix_to_datetime(TEMP(:,1));
    t2 = t_temp(:) - t_temp(1);
    for time2 = 1:length(t2)
        if t2(time2) == '00:07:00'
            x_end_temp = t2(time2);
        end
    end
    plot(t2,TEMP(:,2),'LineWidth',1)
    xlim([0 x_end_temp])
    ylabel("Temperature (C)")
    set(gca,'FontSize',14)
    
    subplot(3,1,3)
    t_hr = unix_to_datetime(HR(:,1));
    t3 = t_hr(:) - t_hr(1);
    for time3 = 1:length(t3)
        if round(t3(time3)) == '00:06:59'
            x_end_hr = t3(time3);
        end
    end
    plot(t3, HR(:,2),'LineWidth',1)
    xlim([0 x_end_hr])
    ylabel("Heart rate")
    set(gca,'FontSize',14)
    
end
%% Plot raw data
for p = 1:length(participants)
    LOAD_DIR = (strcat('C:\Users\erica\Documents\PNB\NSERC_Create\Internship\MovingWith_2019-master\data\dec5_analysis\all_participants_not_processed\',participants(p),'\'));
    
    %Get folders of segments
    D = dir(LOAD_DIR);
    seg_folders = setdiff({D([D.isdir]).name},{'.','..'});
    
    % no segments
    if isempty(seg_folders)
        files = dir(strcat(LOAD_DIR,'*.mat'));
        for j=1:length(files)
            filepath = strcat(LOAD_DIR,files(j).name);
            load(filepath);
        end
    % plot for first segment only    
    else
        files = dir(strcat(LOAD_DIR,char(seg_folders(1)),'\*.mat'));
        
        for a=1:length(files)
            filepath = strcat(LOAD_DIR,char(seg_folders(1)),'\',files(a).name);
            load(filepath);
        end
    end
    EDA = table2array(EDA);
    HR = table2array(HR);
    TEMP = table2array(TEMP);
    
    %Trim to video length
    EDA_start_index = find((round(EDA(:,1),-2)==round(start_time,-2)),1);
    TEMP_start_index = find((round(TEMP(:,1),-2)==round(start_time,-2)),1);
    if round(HR(:,1),-2)==round(start_time,-2)
        HR_start_index = find((round(HR(:,1),-2)==round(start_time,-2)),1);
    elseif round(HR(:,1),-3)==round(start_time,-3)
        HR_start_index = find((round(HR(:,1),-3)==round(start_time,-3)),1);
    else
        HR_start_index = find((round(HR(:,1),-4)==round(start_time,-4)),1);
    end
    EDA = EDA((EDA_start_index:end),:);
    TEMP = TEMP((TEMP_start_index:end),:);
    HR = HR((HR_start_index:end),:);
    
    %plot
    %or clean.mat
    figure;
    subplot(3,1,1)
    t_eda = unix_to_datetime(EDA(:,1));
    t1 = t_eda(:) - t_eda(1);
    for time1 = 1:length(t1)
        if t1(time1) == '00:07:00'
            x_end_eda = t1(time1);
        end
    end
    plot(t1,EDA(:,2),'LineWidth',1)
    title(['Musical Textures for ',participants(p)]);
    xlim([0 x_end_eda])
    ylabel("EDA (us)")
    set(gca,'FontSize',14)
    
    subplot(3,1,2)
    t_temp = unix_to_datetime(TEMP(:,1));
    t2 = t_temp(:) - t_temp(1);
    for time2 = 1:length(t2)
        if t2(time2) == '00:07:00'
            x_end_temp = t2(time2);
        end
    end
    plot(t2,TEMP(:,2),'LineWidth',1)
    xlim([0 x_end_temp])
    ylabel("Temperature (C)")
    set(gca,'FontSize',14)
    
    subplot(3,1,3)
    t_hr = unix_to_datetime(HR(:,1));
    t3 = t_hr(:) - t_hr(1);
    for time3 = 1:length(t3)
        if round(t3(time3)) == '00:06:59'
            x_end_hr = t3(time3);
        end
    end
    plot(t3, HR(:,2),'LineWidth',1)
    xlim([0 x_end_hr])
    ylabel("Heart rate")
    set(gca,'FontSize',14)
    
end