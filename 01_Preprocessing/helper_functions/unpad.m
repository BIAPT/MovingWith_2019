function [unpadded_data,unpadded_time] = unpad(data,time,timeStart,timeEnd)
% Inputs: 
% data - input signal
% time - input signal time
% timeStart - starting time 
% timeEnd - ending time
% 
% Outputs:
% unpadded_data - signal with the start and end trimmed off
% unpadded_time - signal's time with the start and end trimmed off

% Find closest value in signal's time to the specified timeStart and
% timeEnd.
[~, idxStart] = min(abs(time - timeStart));
[~, idxEnd] = min(abs(time - timeEnd));


unpadded_data = data(idxStart:idxEnd);
unpadded_time = time(idxStart:idxEnd);

end