function f_FPM_maxNSTE_custom(fname)
% This function computes the maximum NSTE between frontal and parietal EEG
% channels.
%
% This function is based on the f_FPM_maxNSTE.m file, but includes modifications:
% - includes all frequency bands in BP filter
% - calls the modified f_nste.m function with our fixes 
%
% Input: filename without load directory 

addpath '/Users/biomusic/Documents/MovingWith_2019/Symbolic Transfer Entropy';
samp_freq = 256;
nbchan = 8;
    
% BP filter
lp = 0.1;
hp=50;
bpname = 'all';

dim = 3;        % Embedding dimension
tau = 1:2:30;   % STE lag

data = load(['/Volumes/Seagate/Surgical Ketamine Data/' fname '.txt']);
data = data(:,2:9); % Select only the channel data (exclude the time column)

winsize=(10)*samp_freq;% 10 seconds
NumWin=30; % Fix the number of windows
TotalWin=floor(length(data)/winsize); % Total number of windows
RanWin=randperm(TotalWin); % Randomize the order
UsedWin=RanWin(1:NumWin); % Randomly pick-up the windows
UsedWin=sort(UsedWin);

STE = NaN(NumWin,nbchan,nbchan);
NSTE = NaN(NumWin,nbchan,nbchan);

frontal_chans = [1,2,3,4];
parietal_chans = [7,8];

for ch1=1:nbchan        % Frontal channels
    
    %If ch1 is in frontal_chans then do this loop
    if(any(ch1==frontal_chans))
        display(['From Channel: ', num2str(ch1)])
        
        for ch2=1:nbchan                % Parietal Channels
            
            %if ch2 is in parietal_chans then do this loop
            if(any(ch2==parietal_chans))
                display(['To Channel: ', num2str(ch2)])

                STE1 = NaN(NumWin);
                NSTE1 = NaN(NumWin);
                STE2 = NaN(NumWin);
                NSTE2 = NaN(NumWin);

                for m=1:NumWin
                    [STE1(m),NSTE1(m),STE2(m),NSTE2(m)]= calculate_STE(m,winsize,ch1,ch2,lp,hp,samp_freq,dim,tau,data);

                    fprintf([fname '_ch' num2str(ch1) '_ch' num2str(ch2) '_win' num2str(m) '/' num2str(NumWin) '\n']);
                end

                for m=1:NumWin
                    STE(m,ch2,ch1)=STE1(m);    % Sink to Source
                    NSTE(m,ch2,ch1)=NSTE1(m);

                    STE(m,ch1,ch2)=STE2(m);    % Source to Sink
                    NSTE(m,ch1,ch2)=NSTE2(m);                    
                end
            end 
        end
    end 
end

save(['/Volumes/Seagate/Surgical Ketamine Data/' fname ' ' bpname '_maxNSTE.mat'],'NSTE');

