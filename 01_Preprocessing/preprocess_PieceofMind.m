% Dannie Fu June 2 2020
%
% This script preprocesses EDA, TEMP, HR, and HRV from the Moving With data
% (2019) and saves the cleaned signals in a struct called "clean.mat" in
% the same folder as the load folder. 
% 
% Must change the "LOAD_DIR" variable, which specifies the load directory
% of all the participants' data from a single Moving With Session.
% 
% ------------------

clear;

LOAD_DIR = "D:\Erica\PieceOfMind\June_01_data_raw\";

D = dir(LOAD_DIR);
subfolders = setdiff({D([D.isdir]).name},{'.','..'}); % list of subfolders of D
    
for s=1:length(subfolders)
    
    % Skipping the folder with the original raw data
    if subfolders(s) == "Setup"
        continue
    end 
    
    %Get folders of segments
    D_2 = dir(strcat(LOAD_DIR, subfolders(s)));
    seg_folders = setdiff({D_2([D_2.isdir]).name},{'.','..'}); 
    
    % no segments
    if isempty(seg_folders) 
        OUT_DIR = strcat(LOAD_DIR,subfolders(s),'/');
        files = dir(strcat(LOAD_DIR, subfolders(s),'/*.mat'));

        for j=1:length(files)
            filepath = strcat(LOAD_DIR,subfolders(s),'/',files(j).name);
            load(filepath);
        end 
        clean = preprocess(EDA,TEMP,HR,HRV); 
        
        save(strcat(OUT_DIR,"clean.mat"), "clean");
        
    else % data is segmented 
        for k = 1:length(seg_folders)
            OUT_DIR = strcat(LOAD_DIR,subfolders(s),'/',char(seg_folders(k)),'/');
                
            files = dir(strcat(LOAD_DIR, subfolders(s),'/', char(seg_folders(k)),'/*.mat'));
            
            for a=1:length(files)
                filepath = strcat(LOAD_DIR,subfolders(s),'/',char(seg_folders(k)),'/',files(a).name);
                load(filepath);
            end 
            clean = preprocess(EDA,TEMP,HR,HRV); 
            
            save(strcat(OUT_DIR,"clean.mat"), "clean");

        end         
    end
end