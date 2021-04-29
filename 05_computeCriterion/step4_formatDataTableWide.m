% Dannie Fu March 17 2021
%
% TODO: add description
% ------------------

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/abstract_participants/04_computedmeasures/min30seconds_0.3asym_3ssi/";
SAVE_DIR = "/Volumes/Seagate/Moving With 2019/dec5_analysis/abstract_participants/data_tables/";
SAVE_NAME = 'mw_dec5_wide_min30_0.3_3.csv';

files = dir(fullfile(LOAD_DIR,'*.mat'));

% group 1 dyads = have connections
group1_dyads = {'P1P7', 'P3P6', 'P3P11', 'P4P10', 'P8P14', 'P5P7', 'P5P11'};

% Columns of table
dyad = [];
group = [];
activity=[];
meanSSI = [];
sum_negSustainVals_SSI = [];
sum_posSustainVals_SSI = [];
sum_pos_SSI = [];
sum_neg_SSI = [];
sum_sustainTimes_SSI = [];
meanAsymXY = [];
sum_negSustainVals_Asym = [];
sum_posSustainVals_Asym = [];
sum_pos_asym = [];
sum_neg_asym = [];
sum_sustainTimes_Asym = [];

% Init table with empty columns
dataTable = table(dyad,group,activity,meanSSI,sum_negSustainVals_SSI,sum_posSustainVals_SSI,...
    sum_pos_SSI, sum_neg_SSI,sum_sustainTimes_SSI,meanAsymXY,...
    sum_negSustainVals_Asym,sum_pos_asym,sum_neg_asym,sum_sustainTimes_Asym);

tableRow = [];

for i = 1:length(files)
    
    load(strcat(LOAD_DIR,files(i).name));
    
    name_parts = split(files(i).name, '_');
    dyad = name_parts(2);
    
    activity = strcat(name_parts(6),name_parts(7));
    
    if ismember(char(dyad), group1_dyads)
        group = 1;
    else
        group = 2;
    end 
    
    tableRow = [dyad,group,activity,meanSSI,sum_negSustainVals_SSI,sum_posSustainVals_SSI,...
    sum_pos_SSI, sum_neg_SSI,sum_sustainTimes_SSI,meanAsymXY,...
    sum_negSustainVals_Asym,sum_pos_asym,sum_neg_asym,sum_sustainTimes_Asym];
    
    dataTable = [dataTable; tableRow];
    tableRow = [];
    
end 

% Save as csv file
writetable(dataTable,strcat(SAVE_DIR, SAVE_NAME));
