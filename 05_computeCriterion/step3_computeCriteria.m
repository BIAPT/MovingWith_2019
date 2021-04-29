% Dannie Fu March 17 2021
%
% TODO: optimize code
%
% SSI
% 1) Compute average SSI
% 2) Compute sum of magnitudes of positive and negative SSI 
% 3) Compute sum of lengths of time for sustained moments of positive/ negative SSI
% 4) Compute sum of the magnitudes of sustained SSI (minimum 30 seconds)
%
% Asymmetry
% 1) Compute average asymmetry 
% 2) Compute sum of positive and negative asymmetry values
% 3) Compute sum of lengths of time for sustained moments of positive/ negative
% asymmetry
% 4) Compute sum of the magnitudes of sustained asymmetry (minimum 30 seconds)
% ---------------------------------------------

%% 

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/abstract_participants/03_segmented/";
SAVE_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/abstract_participants/04_computedmeasures/min30seconds_0.3asym_3ssi/";

% params 
min_time = 30;
min_asym = 0.3;
min_ssi = 3;

files = dir(fullfile(LOAD_DIR,'*.mat'));

for j = 1:length(files)
    
    load(strcat(LOAD_DIR,files(j).name));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   SSI
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 1) Compute average SSI 
    meanSSI = mean(ssi_segment(:,2),'omitnan');

    % 2) Compute sum of positive and negative SSI regardless of amplitude
    pos_SSI_idx = find(ssi_segment(:,2) > 0);
    neg_SSI_idx = find(ssi_segment(:,2) < 0);

    sum_pos_SSI = sum(ssi_segment(pos_SSI_idx,2));
    sum_neg_SSI = sum(ssi_segment(neg_SSI_idx,2));

    % Find sustained moments of high/low SSI (minimum 30 seconds) using image
    % processing toolbox to compute 3) and 4). 

    % Find consecutive abs(values) that are greater than a threshold of 1 (1 is arbitrary right
    % now). "area" = # of samples, "PixelValues" = ssi value
    SSI_measurements = regionprops(abs(ssi_segment(:,2))> min_ssi, ssi_segment(:,2), 'area', 'PixelValues');

    % 3) Compute sum of times where abs(SSI) is at least 1 for at least 30
    % seconds
    allSSIAreasTimes = [SSI_measurements.Area];
    sum_sustainTimes_SSI = sum(allSSIAreasTimes(allSSIAreasTimes> min_time));

    % 4) Compute sum of SSI values where abs(SSI)>1 and for at least 30 seconds
    % long (30 samples)
    minLengthTime_idx = find(allSSIAreasTimes> min_time);
    sum_posSustainVals_SSI = 0;
    sum_negSustainVals_SSI = 0;

    for i = 1:length(minLengthTime_idx)

        % Compute the sum of the SSI vals where abs(SSI)>1 for at least 30
        % seconds
        minLengthTime_vals = sum(SSI_measurements(minLengthTime_idx(i)).PixelValues);

        if minLengthTime_vals > 0
            sum_posSustainVals_SSI = sum_posSustainVals_SSI + minLengthTime_vals;
        else 
            sum_negSustainVals_SSI = sum_negSustainVals_SSI + minLengthTime_vals;
        end 
    end 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                 Asymmetry                     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 1) Compute average asymmetry
    meanAsymXY = mean(asym_XY_segment,'omitnan');

    % 2) Compute sum of positive and negative asymmetry
    pos_asym_idx = find(asym_XY_segment > 0);
    neg_asym_idx = find(asym_XY_segment < 0);

    sum_pos_asym = sum(asym_XY_segment(pos_asym_idx));
    sum_neg_asym = sum(asym_XY_segment(neg_asym_idx));

    % Find consecutive abs(values) that are greater than a threshold of 0.2 (0.2 is arbitrary right
    % now). "area" = # of samples, "PixelValues" = asymXY value
    asym_measurements = regionprops(abs(asym_XY_segment)> min_asym, asym_XY_segment, 'area', 'PixelValues');

    % 3) Compute sum of times where abs(asymXY) is at least 0.2 for at least 30
    % seconds (30 samples)
    allAsymAreasTimes = [asym_measurements.Area];
    sum_sustainTimes_Asym = sum(allAsymAreasTimes(allAsymAreasTimes> min_time));

    % 4) Compute sum of asym values where abs(asymXY)>0.2 and for at least 30 seconds
    % long (30 samples)
    minLengthTime_idx = find(allAsymAreasTimes> min_time);
    sum_posSustainVals_Asym = 0;
    sum_negSustainVals_Asym = 0;

    for i = 1:length(minLengthTime_idx)

        % Compute the sum of the SSI vals where abs(SSI)>1 for at least 30
        % seconds
        minLengthTime_vals = sum(asym_measurements(minLengthTime_idx(i)).PixelValues);

        if minLengthTime_vals > 0
            sum_posSustainVals_Asym = sum_posSustainVals_Asym + minLengthTime_vals;
        else 
            sum_negSustainVals_Asym = sum_negSustainVals_Asym + minLengthTime_vals;
        end 
    end 

    file_name = split(files(j).name,'.');
    save_name = strcat(char(file_name(1)),"_measures",".mat");
    
    save(strcat(SAVE_DIR, save_name), ...
        "meanSSI", "sum_pos_SSI","sum_neg_SSI","sum_sustainTimes_SSI",...
        "sum_posSustainVals_SSI","sum_negSustainVals_SSI", ...
        "meanAsymXY","sum_pos_asym", "sum_neg_asym", ...
        "sum_sustainTimes_Asym","sum_posSustainVals_Asym", "sum_negSustainVals_Asym");
end 










