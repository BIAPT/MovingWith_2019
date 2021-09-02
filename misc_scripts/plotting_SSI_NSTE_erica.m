% Erica July 2021
%
% This script does some random plotting. Each section should be run
% separately.
% ------------------
%% Set-up for loading the data
clear;
% SSI
% LOAD_DIR_SSI = "C:\Users\erica\Documents\PNB\NSERC_Create\Internship\MovingWith_2019-master\data\dec5_analysis\Optimal_params_final_EDA_TEMP_HR\SSI\TEMP\";
LOAD_DIR_SSI = "C:\Users\erica\Documents\PNB\NSERC_Create\Internship\Piece_of_Mind\optimal_params\SSI\HR\";

D = struct2cell(dir(LOAD_DIR_SSI));
LOAD_NAME_SSI = strings();
k = 0;

for file = 1:length(D(1,:))
    str_cell = strfind(D(1,file),'.mat');
    if str_cell{1} > 0
        k = k+1;
        LOAD_NAME_SSI(1,k) = D{1,file};
    end
end

%NSTE
% LOAD_DIR_NSTE = "C:\Users\erica\Documents\PNB\NSERC_Create\Internship\MovingWith_2019-master\data\dec5_analysis\Optimal_params_final_EDA_TEMP_HR\NSTE\TEMP\";
LOAD_DIR_NSTE = "C:\Users\erica\Documents\PNB\NSERC_Create\Internship\Piece_of_Mind\optimal_params\NSTE\HR\";
D = struct2cell(dir(LOAD_DIR_NSTE));
LOAD_NAME_NSTE = strings();
k = 0;

for file = 1:length(D(1,:))
    str_cell = strfind(D(1,file),'.mat');
    if str_cell{1} > 0
        k = k+1;
        LOAD_NAME_NSTE(1,k) = D{1,file};
    end
end

%% Plot SSI vs p values, and NSTE both directions
for file = 1:length(LOAD_NAME_SSI)
    
    load(strcat(LOAD_DIR_SSI,LOAD_NAME_SSI(file))); % load one of the dyads' SSI
    load(strcat(LOAD_DIR_NSTE,LOAD_NAME_NSTE(file))); % load the same dyads' NSTE
    
    
    %plot SSI vs p values
    figure;
    subplot(2,1,1)
    yyaxis left
    plot(plt_time(1:length(ssi))/60, ssi(:,2),'LineWidth',3);
    ylabel('SSI');
    ylim([-12 12]);
    yline(0,'b-')
    set(gca,'ycolor','k')
    yyaxis right
    plot(plt_time(1:length(ssi))/60, pval,'--','LineWidth',1, 'Color', '#808080')
    title(strcat('P',extract(LOAD_NAME_SSI(file),7),'P',strcat(extract(LOAD_NAME_SSI(file),9),' Rolling SSI and Significance')));
    ylabel('p-values');
    set(gca,'FontSize',20)
    set(gca,'ycolor','k')
    
    %plot NSTE
    subplot(2,1,2)
    plot(plt_time(1:length(NSTE_XY))/60, NSTE_XY, 'LineWidth',2);
    hold on
    plot(plt_time(1:length(NSTE_YX))/60, NSTE_YX, 'LineWidth',2);
    ylim([0, 0.65])
    title('NSTE');
    ylabel('NSTE');
    xlabel('Time (minutes)');
    legend('NSTE X->Y', 'NSTE Y->X');
    set(gca,'FontSize',20)
    
    
end
