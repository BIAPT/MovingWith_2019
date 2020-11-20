figure
subplot(4,1,1)
plot(unix_to_datetime(EDA(:,1)),EDA(:,2),'LineWidth',1)
ylabel("EDA (us)")
set(gca,'FontSize',14)

subplot(4,1,2)
plot(unix_to_datetime(TEMP(:,1)),TEMP(:,2),'LineWidth',1)
ylabel("Temperature (C)")
set(gca,'FontSize',14)

subplot(4,1,3)
plot(unix_to_datetime(HR(:,1)), HR(:,2),'LineWidth',1)
ylabel("Heart rate")
set(gca,'FontSize',14)

subplot(4,1,4)
plot(unix_to_datetime(HRVZY(:,1)), HRVZY(:,2),'LineWidth',1)
ylabel("HRV Z/Y")
xlabel("Time (seconds)")
set(gca,'FontSize',14)

% %% Plot window
% 
% figure
% subplot(4,1,1)
% plot(unix_to_datetime(EDA_window(:,1)),EDA_window(:,2),'LineWidth',1)
% ylabel("EDA (us)")
% 
% subplot(4,1,2)
% plot(unix_to_datetime(TEMP_window(:,1)),TEMP_window(:,2),'LineWidth',1)
% ylabel("Temperature (C)")
% 
% subplot(4,1,3)
% plot(unix_to_datetime(HR_window(:,1)), HR_window(:,2),'LineWidth',1)
% ylabel("Heart rate")
% 
% subplot(4,1,4)
% plot(unix_to_datetime(HRVZY_window(:,1)), HRVZY_window(:,2),'LineWidth',1)
% ylabel("HRV Z/Y")
% xlabel("Time (seconds)")
% set(gca,'FontSize',14)



