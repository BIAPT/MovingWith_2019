function EEG = t_scores_p_by_p(EEG1, EEG2)

EEG = EEG1;

EEG.trials = 1;

[~, p, ~, ~] = ttest2(EEG1.data(:,:,1:size(EEG2.data,3)), EEG2.data, [], [], 'unequal', 3);
EEG.data = p; %stats.tstat;

EEG.epoch(2:end) = [];
EEG.event(2:end) = [];

return;