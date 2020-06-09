% Dannie Fu June 1 2020
% This script loops through all the exported csv files from a biomusic
% sesion and saves as a variable (e.g. EDA, TEMP)

IN_DIR = "/Volumes/FUD/Moving With 2019/Session_Nov_7/P1_TP001689_green/";
OUT_DIR = "/Volumes/FUD/Moving With 2019/Session_Nov_7/P1_TP001689_green/";

% Loop through each csv file
files = dir(fullfile(IN_DIR,'*.csv'));
for k = 1:length(files)
    
    filename = files(k).name;
    filename_split = split(filename,'.');
    loadfilename = strcat(IN_DIR,filename);

    % Name variable based on the filename. There is probably a better way to do
    % this...
    if (contains(loadfilename,"ACC"))
        ACC = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'ACC');

    elseif (contains(loadfilename,"BVP"))
        BVP = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'BVP')

    elseif (contains(loadfilename,"EDA"))
        EDA = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'EDA')

    elseif (contains(loadfilename,"EDR"))
        EDR = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'EDR')

    elseif (contains(loadfilename,"HRV"))
        HRV = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'HRV')
        
    elseif (contains(loadfilename,"HR"))
        HR = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'HR')

    elseif (contains(loadfilename,"STR"))
        STR = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'STR')
        
    elseif (contains(loadfilename,"TEMPR"))
        TEMPR = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'TEMPR')

    elseif (contains(loadfilename,"TEMP"))
        TEMP = readtable(loadfilename);
        savefilename = strcat(OUT_DIR,filename_split(1),'.mat');
        save(savefilename, 'TEMP')

    end 

end 

 
