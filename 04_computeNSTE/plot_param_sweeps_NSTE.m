% Erica Flaten July 2021
% Use this script to plot figures for the NSTE parameter sweeps
% Change loading directory name for physiological mode of interest (i.e., HR,
% EDA, TEMP)

cd 'D:\Erica\MovingWith_2019-master\04_computeNSTE'
dyads = ["P1P7" "P3P6" "P3P11" "P4P10" "P8P14" "P5P7" "P5P11"];
% dyads = ["P1P2"];
% taus = [75,93,111,129,147,165,183,201,219,237,255,273]; %starting tau value for each swept window for TEMP
taus = [15,30,45,60,75,90,105,120]; %starting tau value for each swept window for EDA/HR
sumNSTE = zeros(length(dyads),length(taus));

for n1 = 1:length(dyads)
    for t = 1:length(taus)
%         load(strcat('D:\Erica\MovingWith_2019-master\data\param_scanning\STE\Dec5_',dyads(n1),'_NSTE_HR_60_3_',num2str(taus(t))))
        load(strcat('D:\Erica\PieceOfMind\param_scanning\NSTE\Dec5_',dyads(n1),'_NSTE_HR_60_3_',num2str(taus(t))))
        sumNSTE(n1,t) = sum_NSTE_XY+sum_NSTE_YX;
        
        figure;
        plot(plt_time(1:length(NSTE_YX))/60, NSTE_YX);
        hold on
        plot(plt_time(1:length(NSTE_XY))/60, NSTE_XY);
        ylim([0 0.6])
        ylabel('NSTE');
        xlabel('Time (minutes)');
        legend('NSTE Y->X','NSTE X->Y');
        title(strcat(dyads(n1),'tau window starts at ',num2str(taus(t)),'samples'))
    end
end
