% Dannie Fu June 2 2020
%
% This script preprocesses the moving with data
%
% ------------------

clear;

LOAD_DIR = "/Volumes/Seagate/Moving With 2019/7. Session_Dec_19/";

D = dir(LOAD_DIR);
subfolders = setdiff({D([D.isdir]).name},{'.','..'}); % list of subfolders of D
    
for s=1:length(subfolders)
    
    if subfolders(s) == "Original Data"
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
        preprocess;        
    else % data is segmented 
        for k = 1:length(seg_folders)
            OUT_DIR = strcat(LOAD_DIR,subfolders(s),'/',char(seg_folders(k)),'/');
                
            files = dir(strcat(LOAD_DIR, subfolders(s),'/', char(seg_folders(k)),'/*.mat'));
            
             for a=1:length(files)
                filepath = strcat(LOAD_DIR,subfolders(s),'/',char(seg_folders(k)),'/',files(a).name);
                load(filepath);
             end 
             preprocess;
        end         
    end   
end 