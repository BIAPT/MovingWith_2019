function [shuffled_wins] = getRandWindows(subj2, size_wins)
% input - signal 2, size of matrix [length of window, number of windows]
% output - randomly selected windows [length of window, number of windows]  

shuffled_wins = zeros(size_wins);
length_win = size_wins(1);

% vector of indices randomly picked 
start_idxs = randperm(length(subj2)-length_win);

for i=1:length(start_idxs)
    shuffled_wins(:,i) = subj2(start_idxs(i):start_idxs(i)+length_win-1);
end 

end 

