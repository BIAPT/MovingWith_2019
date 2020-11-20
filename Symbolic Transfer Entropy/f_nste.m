function [STE, NSTE] = f_nste(data, dim, lag, delta)
% only applied for bivariate data
% (c1,c2): c2 -> c0
% That is, Column to Row
ch=size(data,2); % For 2 signals, ch=2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Part 1. STE of original data %%%%%%%%%%%%%%%%%%

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
STE(1) = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) ); % P1 = P(XF,XP,YP) => target is X, source is Y => STE_YX
[P1, P2, P3, P4] = f_Integer2prob(Int_future(:,2), Int_past(:,2), Int_past(:,1)); %(YF, YP, XP)
STE(2) = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) ); % P1 = P(YF,YP,YP) => target is Y, source is X => STE_XY

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Part 2. STE of shuffled data  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Computing STE_YX and NSTE_YX %%%%%%%%%%%%%%%%%

% first data X = target 
% second data Y = source 

% second data is shuffled because it is source 
data2=data(:,2); 
len=length(data2);
halflen=floor(len/2);
shuffled_data2 = [data2(halflen+1:end); data2(1:halflen)]; % shuffle Y

Ddata=delayRecons([data(:,1) shuffled_data2], lag, dim);
clear INT;
for c=1:ch
    INT(:,c)=F_Int2Symb(Ddata(:,:,c));
end
Int_future=INT(1+delta:end,:);
Int_past=INT(1:end-delta,:);

[P1, P2, P3, P4] = f_Integer2prob(Int_future(:,1), Int_past(:,1), Int_past(:,2));
STE_shuffled = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) );
H_XY = -sum ( P3 .* (log2(P3) - log2(P4)));

NSTE_numerator = STE(1) - STE_shuffled; %STE(1) is STE_YX

if NSTE_numerator < 0
    NSTE(1) = 0; % set NSTE to 0 if shuffled STE is greater than normal STE 
else
    NSTE(1) = NSTE_numerator/H_XY;  
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Part 3. STE of shuffled data  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Computing STE_XY and NSTE_XY %%%%%%%%%%%%%%%%%

% first data X = source 
% second data Y = target 

% first data is shuffled because it is source 
data1=data(:,1); % source data
len=length(data1);
halflen=floor(len/2);
shuffled_data1 = [data1(halflen+1:end); data1(1:halflen)];

Ddata=delayRecons([shuffled_data1 data(:,2)], lag, dim);
clear INT;
for c=1:ch
    INT(:,c)=F_Int2Symb(Ddata(:,:,c));
end
Int_future=INT(1+delta:end,:);
Int_past=INT(1:end-delta,:);

[P1, P2, P3, P4] = f_Integer2prob(Int_future(:,2), Int_past(:,2), Int_past(:,1));
STE_shuffled = sum( P1 .* (log2( P1.*P4 ) - log2(P2.*P3)) );
H_XY = -sum ( P3 .* (log2(P3) - log2(P4)));

STE_numerator = STE(2) - STE_shuffled;

if STE_numerator < 0
    NSTE(2) = 0; % set NSTE to 0 if shuffled STE is greater than normal STE 
else
    NSTE(2) = STE_numerator/H_XY; % STE(2) is STE_XY => NSTE(2) is NSTE_XY
end 
















