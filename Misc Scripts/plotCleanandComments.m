EDA_time = EDA(:,1);
EDA_data = EDA(:,2);

TEMP_time = TEMP(:,1);
TEMP_data = TEMP(:,2);

HR_time = HR(:,1);
HR_data = HR(:,2);

HRVZY_time = HRVZY(:,1);
HRVZY_data = HRVZY(:,2);

figure
tiledlayout(4,1)

ax1 = nexttile;
plot(ax1, (EDA_time-EDA_time(1))/1000, EDA_data,'LineWidth',2);
ylabel("EDA (us)")
%title('2020-09-09')

ax2 = nexttile;
plot(ax2,(TEMP_time-TEMP_time(1))/1000,TEMP_data,'LineWidth',2)
ylabel("Temperature (C)")

ax3 = nexttile;
plot(ax3,(HR_time-HR_time(1))/1000, HR_data,'LineWidth',2)
ylabel("Heart rate")

ax4 = nexttile;
plot(ax4,(HRVZY_time-HRVZY_time(1))/1000, HRVZY_data,'LineWidth',2)
ylabel("HRV Z/Y")
xlabel("Time (seconds)")

%% Load and display comments as vertical lines 

comments = readtable('/Volumes/Seagate/Codesign/cdnc005/2020-10-30/10h17m41/2020-10-30_10h17m41_comments.csv');

for i=1:height(comments)
    startTime = (comments.startTime(i)-EDA_time(1))/1000;
    xline(ax1,startTime,'-',comments.description(i),'LineWidth',2);
    
    endTime = (comments.endTime(i)-EDA_time(1))/1000;
    xline(ax1,endTime,'Color','r','LineWidth',2);
end 



