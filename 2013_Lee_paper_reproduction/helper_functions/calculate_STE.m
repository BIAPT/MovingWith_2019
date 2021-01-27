function [STE1,NSTE1,STE2,NSTE2]= calculate_STE(m,winsize,ch1,ch2,lp,hp,samp_freq,dim,tau,data)
                
STE = NaN(15,2);
NSTE = NaN(15,2);

ini_point=(m-1)*winsize+1;
final_point=ini_point+winsize-1;

x=data(ini_point:final_point,ch1);
y=data(ini_point:final_point,ch2);

fdata1=bpfilter(lp,hp,samp_freq,x);
fdata2=bpfilter(lp,hp,samp_freq,y);

delta=f_predictiontime(fdata1,fdata2,50);%100); %Maybe something here

for L=1:15
    [STE(L,1:2), NSTE(L,1:2)] = f_nste([fdata1 fdata2], dim, tau(L), delta);
end

[mxNSTE, ~]=max(NSTE); %mxNSTE and mxNTau
[mxSTE, ~]=max(STE); 

STE1 =mxSTE(1);    % Sink to Source
NSTE1 =mxNSTE(1);

STE2=mxSTE(2);    % Source to Sink
NSTE2=mxNSTE(2);

 end