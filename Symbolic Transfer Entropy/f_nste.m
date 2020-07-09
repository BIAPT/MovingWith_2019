function [T, T_s] = f_nste(data, dim, lag, delta)
% only applied for bivrate data
% (c1,c2): c2 -> c0
% That is, Column to Row
ch=size(data,2); % For 2 signals, ch=2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Part1. STE of original data %%%%%%%%%%%%%%%%%%

Ddata=delayRecons(data, lag, dim); % embedding 
for c=1:ch
    INT(:,c)=F_Int2Symb(Ddata(:,:,c)); % transform to symbol
end
Int_future=INT(1+delta:end,:);
Int_past=INT(1:end-delta,:);

% compute probability
% P1 = P[X(n+1),X(n),Y(n)]
% P2 = P[X(n),Y(n)]
% P3 = P[X(n+1),X(n),???]
% P4 = P[X(n)]
%[P1, P2, P3, P4] = f_Integer2prob(Integer1, Integer2, Integer3)
% Integer1: Target Future: X(n+1)
% Integer2: Target Present: X(n)
% Integer3: Source Present: Y(n)
[P1, P2, P3, P4] = f_Integer2prob(Int_future(:,1), Int_past(:,1), Int_past(:,2)); %(XF, XP, YP)
T(1) = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) ); % P1 = P(XF,XP,YP) => target is X, source is Y => STE_YX
[P1, P2, P3, P4] = f_Integer2prob(Int_future(:,2), Int_past(:,2), Int_past(:,1)); %(YF, YP, XP)
T(2) = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) ); % P1 = P(YF,YP,YP) => target is Y, source is X => STE_XY

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Part2. STE of shuffled data %%%%%%%%%%%%%%%%%%
% second data is shuffled
data2=data(:,2); % target data
len=length(data2);
halflen=floor(len/2);
shuffled_data2 = [data2(halflen+1:end,1); data2(1:halflen)]; % shuffle Y

Ddata=delayRecons([data(:,1) shuffled_data2], lag, dim);
clear INT;
for c=1:ch
    INT(:,c)=F_Int2Symb(Ddata(:,:,c));
end
Int_future=INT(1+delta:end,:);
Int_past=INT(1:end-delta,:);

[P1, P2, P3, P4] = f_Integer2prob(Int_future(:,1), Int_past(:,1), Int_past(:,2));
sft_T = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) );
%H_XY =  sum ( P1.*(log2(P2) - log2(P1.*P2))); *** SEE BOTTOM OF CODE
%H_XY = -sum ( P3./P4.*(log2(P3) - log2(P4)));
%H_XY = -sum ( P1.*(log2(P3) - log2(P4))); % Fix from pullrequest - not
%sure if works 

H_XY = -sum ( P3 .* (log2(P3) - log2(P4)));

T_s_num = T(1) - sft_T;

if T_s_num < 0
    T_s(1) = 0; % set NSTE to 0 if shuffled STE is greater than normal STE 
else
    T_s(1) = (T(1) - sft_T)/H_XY;  %T(1) is STE_YX
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Part3. STE of shuffled data %%%%%%%%%%%%%%%%%%
% first data is shuffled
data1=data(:,1); % source data
len=length(data2);halflen=floor(len/2);
shuffled_data1 = [data1(halflen+1:end,1); data1(1:halflen)];

Ddata=delayRecons([shuffled_data1 data(:,2)], lag, dim);
clear INT;
for c=1:ch
    INT(:,c)=F_Int2Symb(Ddata(:,:,c));
end
Int_future=INT(1+delta:end,:);
Int_past=INT(1:end-delta,:);

[P1, P2, P3, P4] = f_Integer2prob(Int_future(:,2), Int_past(:,2), Int_past(:,1));
sft_T = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) );
%H_XY =  sum ( P1.*(log2(P2) - log2(P1.*P2))); *** SEE BOTTOM OF CODE
%H_XY = -sum ( P3./P4.*(log2(P3) - log2(P4)));
%H_XY = -sum ( P1.*(log2(P3) - log2(P4)));

H_XY = -sum ( P3 .* (log2(P3) - log2(P4)));

T_s_num = T(2) - sft_T;

if T_s_num < 0
    T_s(2) = 0; % set NSTE to 0 if shuffled STE is greater than normal STE 
else
    T_s(2) = (T(2) - sft_T)/H_XY; %T(2) is STE_XY => T_s(2) is NSTE_XY
end 
%*** NSTE didn't give the right output with this line of code
% we redid the derivation and we found out that this line should be
% replaced by the one below (as suggested by Dr. Chang)
%display('new version running!');


















