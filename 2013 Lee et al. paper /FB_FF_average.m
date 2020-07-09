function[FB, FF, asym] = FB_FF_average(fname)

load([fname '_maxNSTE2.mat']);

data = NSTE;    % This is a 30 x 8 x 8 matrix
sz_data = size(data);

% Find feedforward results across windows 
num_windows = sz_data(1);

for k = 1:num_windows
    t = 1;
    for i = [7,8]        % Parietal channels
        for j = [1,2,3,4]            % Frontal channels
            FF(t) = data(k,i,j);
            t = t+1;
        end
    end
    
    FF_winave(k) = mean(FF);
end 

% Find feedback results across windows 

for k = 1:num_windows
    t = 1;
    for i = [1,2,3,4]                % Frontal channels
        for j = [7,8]           % Parietal channels
            FB(t) = data(k,i,j);
            t = t+1;
        end
    end
    
    FB_winave(k) = mean(FB);
end 


asym = (FB_winave - FF_winave) ./(FB_winave + FF_winave);
