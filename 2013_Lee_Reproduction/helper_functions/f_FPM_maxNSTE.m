function f_FPM_maxNSTE(fname)

samp_freq = 500;

for bp=1:6 
    switch bp
        case 1  % all 1
            bpname='all'
            lp=1;
            hp=30;
        case 2 %delta
            bpname='delta'
            lp=1;
            hp=4;
        case 3  %theta
            bpname='theta'
            lp=4;
            hp=8;
        case 4 %alpha
            bpname='alpha'
            lp=8;
            hp=13;
        case 5 %beta
            bpname='beta'
            lp=13;
            hp=30;
        case 6 % low gamma
            bpname='gamma'
            lp=30;
            hp=50;
    end
    
        data = load(['/Volumes/Seagate/Surgical Ketamine Data/' fname '.txt']);
        data = data';
        
        [m, num_comp] = size(data);
                    
        winsize=(10)*samp_freq;% 10 seconds
        NumWin=20; % Fix the number of windows
        TotalWin=floor(length(data)/winsize); % Total number of windows
        RanWin=randperm(TotalWin); % Randomize the order
        UsedWin=RanWin(1:NumWin); % Randomly pick-up the windows
        UsedWin=sort(UsedWin);
      
        
        for ch1=1:num_comp        % Frontal channels
            for ch2=1:num_comp                % Parietal Channels
                for m=1:NumWin
                    win=UsedWin(m);
                    ini_point=(win-1)*winsize+1;
                    final_point=ini_point+winsize-1;
                    
                    x=data(ini_point:final_point,ch1);
                    y=data(ini_point:final_point,ch2);
                    
                    fdata1=bpfilter(lp,hp,samp_freq,x);
                    fdata2=bpfilter(lp,hp,samp_freq,y);
                    
                    delta=f_predictiontime(fdata1,fdata2,100);

                    dim=3;
                    tau = 1:2:30;
                    for L=1:15
                        [STE(L,1:2), NSTE(L,1:2)] = f_nste([fdata1 fdata2], dim, tau(L), delta);
                    end
                                       
                    [mxNSTE, mxNTau]=max(NSTE);
                    [mxSTE, mxTau]=max(STE);
                    
                    ste.STE(m,ch2,ch1)=mxSTE(1);    % Y to X
                    ste.NSTE(m,ch2,ch1)=mxNSTE(1);
                    
                    ste.STE(m,ch1,ch2)=mxSTE(2);    % X to Y
                    ste.NSTE(m,ch1,ch2)=mxNSTE(2);
             
              
                    fprintf([fname '_ch' num2str(ch1) '_ch' num2str(ch2) '_win' num2str(m) '/' num2str(NumWin) '\n']);
                end
            end
        end
        
        save(['F:\McDonnell Foundation study\University of Michigan\Anesthesia\' sname '\Resting state analysis\' sname ' ' fname ' ' bpname '_maxNSTE.mat'],'ste');
           
end % bp





