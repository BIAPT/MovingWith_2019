ALLEEG(1).data = ALLEEG(1).data(:,:,:);
ALLEEG(2).data = ALLEEG(2).data(:,:,:);


numEEGs = length(ALLEEG);
numPairsEEGs = numEEGs/2;

dims = size(ALLEEG(1).data);

% ALLEEG contains multiple pairs of true/false conditioned EEGs
tscore = t_scores_p_by_p(ALLEEG(1), ALLEEG(2));
tscore.data = cumsum(tscore.data, 2);



%%%%%%%%%%%%%%%%%%%PRE%%%%%%%%%%%%%%%%%%%%%%%
%FOR MMN
chans = {'Fz','Cz','F3','F4','F5','F6','C3','C4'};
chaninds = [36,46,5,38,6,39,12,48];

%FOR THE REST
chans = {'Fz','Cz','POz','P3','P4'};
chaninds = [36,46,29,20,56];

chans = {'E64'}
chaninds = [47]
%ALL
chans = {'Fz','Cz','C4'};
chaninds = [36,46,48];

chans = {'Fz','Cz','Pz'};
chaninds = [36,46,31];

chans = {'Cz'}
chaninds = [46]
%%%%%%%%%%%%%%%%%%%SED%%%%%%%%%%%%%%%%%%%%%%%%
%FOR MMN
chans = {'Fz','Cz','F3','F4','F5','F6','C3','C4'};
chaninds = [34,44,4,36,5,37,11,46];

%FOR THE REST
chans = {'Fz','Cz','POz','P3','P4'};
chaninds = [34,44,27,18,53];

%ALL
chans = {'Cz'};
chaninds = [1];

for sz = 20  % loop over size
    interval = ceil(sz*0.001 * ALLEEG(1).srate);
    t = [];
    time = linspace(-100,800-sz,dims(2)-interval-1);
    time2 = linspace(-100,800-sz,dims(2));
    for c = 1:size(chans,2)
        for j = 1:(dims(2)-interval-1)   % loop over points
            t(j) = (tscore.data(chaninds(c), j+interval) - tscore.data(chaninds(c), j)) / interval;
        end;
        figure;subplot(1,2,1);plot(time,t,'k');hold on;plot([-100,800-sz],[0.05 0.05],'r:')
        title(sprintf('P Values using window of %d ms, on Electrode %s',...
            sz,char(chans(c))));
        ylim([0 1]);
        ylabel('P Value');
        xlabel('Time (ms)');
        subplot(1,2,2);
        plot(time2,squeeze(mean(ALLEEG(1).data(chaninds(c),:,:),3)));
        hold;plot(time2,squeeze(mean(ALLEEG(2).data(chaninds(c),:,:),3)),'r');
        plot(time2,squeeze(mean(ALLEEG(2).data(chaninds(c),:,:),3))-squeeze(mean(ALLEEG(1).data(chaninds(c),:,:),3)),'m');
        legend(ALLEEG(1).setname,ALLEEG(2).setname,'difference (2-1)');
        ylim([-20 20]);
        set(gca,'Ydir','reverse')
        ylabel('Electric potential');
        xlabel('Time (ms)');
        %saveas(gcf,sprintf('%s_%s_%s.fig','STDvsDEV','NSOW',char(chans(c))));
    end
end;
