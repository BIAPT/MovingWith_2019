figure
subplot(5,1,1)
plot(unix_to_datetime(EDA(:,1)),EDA(:,2),'LineWidth',1)
ylabel("EDA (us)")
set(gca,'FontSize',14)

subplot(5,1,2)
plot(unix_to_datetime(TEMP(:,1)),TEMP(:,2),'LineWidth',1)
ylabel("Temperature (C)")
set(gca,'FontSize',14)

subplot(5,1,3)
plot(unix_to_datetime(HR(:,1)), HR(:,2),'LineWidth',1)
ylabel("Heart rate")
set(gca,'FontSize',14)

subplot(5,1,4) 
plot(unix_to_datetime(HRVYZ(:,1)), HRVYZ(:,2),'LineWidth',1)
ylabel("HRV Y/Z")
set(gca,'FontSize',14)

subplot(5,1,5)
plot(unix_to_datetime(HRVZ(:,1)), HRVZ(:,2),'LineWidth',1)
ylabel("HRV Z")
xlabel("Time (seconds)")
set(gca,'FontSize',14)

%% Plot window

figure
subplot(5,1,1)
plot(unix_to_datetime(EDA_window(:,1)),EDA_window(:,2),'LineWidth',1, 'Color', '#f6a753')
ylabel("EDA (us)")
set(gca,'FontSize',14)
%set(gcf, 'color', 'none'); 
%set(gca, 'color', 'none'); 

subplot(5,1,2)  

plot(unix_to_datetime(TEMP_window(:,1)),TEMP_window(:,2),'LineWidth',1,'Color', '#699bdd')
ylabel("Temperature (C)")
set(gca,'FontSize',14)
%set(gcf, 'color', 'none'); 
%set(gca, 'color', 'none'); 

subplot(5,1,3)
plot(unix_to_datetime(HR_window(:,1)), HR_window(:,2),'LineWidth',1, 'Color', '#94d169')
ylabel("Heart rate")
set(gca,'FontSize',14)
%set(gcf, 'color', 'none'); 
%set(gca, 'color', 'none'); 

subplot(5,1,4)
plot(unix_to_datetime(HRVYZ_window(:,1)), HRVYZ_window(:,2),'LineWidth',1, 'Color', '#94d169')
ylabel("HRV Z/Y")
set(gca,'FontSize',14)
%set(gcf, 'color', 'none'); 
%set(gca, 'color', 'none'); 

subplot(5,1,5)
plot(unix_to_datetime(HRVZ_window(:,1)), HRVZ_window(:,2),'LineWidth',1, 'Color', '#94d169')
ylabel("HRV Z")
xlabel("Time (seconds)")
set(gca,'FontSize',14)
%set(gcf, 'color', 'none'); 
%set(gca, 'color', 'none'); 



