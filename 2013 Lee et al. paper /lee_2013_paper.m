% Dannie Fu July 1 2020

% Script to reproduce the ketamine FF,FB Asymmetry figures from the paper 
% 'Disruption of Frontal-Parietal Communication by Ketamine, Propofol, and
% Sevoflurane' (Lee et al, 2013)
%
% --------

% Load data
load('/Volumes/Seagate/Surgical Ketamine Data/S1_FF_FB_asym_Base');
S1_FF_Base = FF_winave; 
S1_FB_Base = FB_winave; 
S1_asym_Base = asym; 
clear('asym','FB_winave','FF_winave');

load('/Volumes/Seagate/Surgical Ketamine Data/S1_FF_FB_asym_Uncons');
S1_FF_Uncons = FF_winave; 
S1_FB_Uncons = FB_winave; 
S1_asym_Uncons = asym; 
clear('asym','FB_winave','FF_winave');

load('/Volumes/Seagate/Surgical Ketamine Data/S2_FF_FB_asym_Base');
S2_FF_Base = FF_winave; 
S2_FB_Base = FB_winave; 
S2_asym_Base = asym; 
clear('asym','FB_winave','FF_winave');

load('/Volumes/Seagate/Surgical Ketamine Data/S2_FF_FB_asym_Uncons');
S2_FF_Uncons = FF_winave; 
S2_FB_Uncons = FB_winave; 
S2_asym_Uncons = asym; 
clear('asym','FB_winave','FF_winave');

load('/Volumes/Seagate/Surgical Ketamine Data/S3_FF_FB_asym_Base');
S3_FF_Base = FF_winave; 
S3_FB_Base = FB_winave; 
S3_asym_Base = asym; 
clear('asym','FB_winave','FF_winave');

load('/Volumes/Seagate/Surgical Ketamine Data/S3_FF_FB_asym_Uncons');
S3_FF_Uncons = FF_winave; 
S3_FB_Uncons = FB_winave; 
S3_asym_Uncons = asym; 
clear('asym','FB_winave','FF_winave');

%% Average the subjects 

FF_Ave_Base = (S1_FF_Base + S2_FF_Base + S3_FF_Base)/3;
FF_Ave_Uncons = (S1_FF_Uncons + S2_FF_Uncons + S3_FF_Uncons)/3;

FB_Ave_Base = (S1_FB_Base + S2_FB_Base + S3_FB_Base)/3;
FB_Ave_Uncons = (S1_FB_Uncons + S2_FB_Uncons + S3_FB_Uncons)/3;

Asym_Ave_Base = (S1_asym_Base + S2_asym_Base + S3_asym_Base)/3;
Asym_Ave_Uncons = (S1_asym_Uncons + S2_asym_Uncons + S3_asym_Uncons)/3;

FF_full = [FF_Ave_Base FF_Ave_Uncons];
FB_full = [FB_Ave_Base FB_Ave_Uncons];
Asym_full = [Asym_Ave_Base Asym_Ave_Uncons];

% Each point is a 10s window
time = 1:60;
plot(time/6,FF_full, 'Marker', 'o')
hold on
plot(time/6,FB_full, 'Marker', 'o')
hold on
legend('FF', 'FB')

figure
plot(time/6,Asym_full, 'Marker', 'o')








