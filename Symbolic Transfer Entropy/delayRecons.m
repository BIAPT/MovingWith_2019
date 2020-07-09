% This function splits the data up based on the specified embedding dimension and
% lag. 
%
% Input Params:
%       data: should be 2-d matrix, where each row is a data point and each
%             column is a signal e.g. 10x2 matrix
%       v:  lag - the time delay 
%       m:  embedding dimension (the number of ranks that will be
%           used when symbolizing the data) e.g. m = 3 means three data
%           points will be ranked from 0 to 2 based on their amplitude. 
%       output: is 3-d matrix
%
% Example: 
%
% Input = [ 1    11
%           2    12
%           3    13
%           4    14
%           5    15 ]
% Output(:,:,1) = [1     2     3 
%                  2     3     4
%                  3     4     5] 
% Output (:,:,2) = [11    12    13
%                   12    13    14
%                   13    14    15]

function y=delayRecons(data, v, m)

MaxEpoch=length(data);
ch=size(data,2);

y=zeros(MaxEpoch-v*(m-1),m,ch);
for c=1:ch
    for j=1:m
        y(:, j, c)=data(1+(j-1)*v:end-(m-j)*v, c);
    end
end

