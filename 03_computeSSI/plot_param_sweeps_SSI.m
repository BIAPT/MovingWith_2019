% Erica Flaten July 2021
% Use this script to plot figures for the SSI parameter sweeps
% Change loading directory name for physiological mode of interest (i.e., HR,
% EDA, TEMP)


cd 'D:\Erica\MovingWith_2019-master\03_computeSSI'
dyads = ["P1P7" "P3P6" "P3P11" "P4P10" "P8P14" "P5P7" "P5P11"];
% dyads = ["P1P2"]; % Piece of Mind
slopes = [5:10];
% slopes = [5:2:25];
sumSSI = zeros(length(dyads),length(slopes));


for n1 = 1:length(dyads)
    for s = 1:length(slopes)
        load(strcat('D:\Erica\MovingWith_2019-master\data\param_scanning\SSI\Dec5_',dyads(n1),'_SSI_HR_',num2str(slopes(s)),'_15_30'))
%         load(strcat('D:\Erica\PieceOfMind\param_scanning\SSI\Dec5_',dyads(n1),'_SSI_HR_',num2str(slopes(s)),'_15_30') % Piece of Mind data
        sumSSI(n1,s) = sum_SSI;
        
        time = (signal_1(:,1) - signal_1(1,1))/1000; % Convert time to seconds
        plt_time = time(1:15:end);
        figure;
        plot(plt_time(1:length(ssi))/60, ssi(:,2));
        xlabel('Time (minutes)');
        ylabel('SSI');
        title(strcat(dyads(n1),' SSI, slope win = ',num2str(slopes(s))))
    end
end
