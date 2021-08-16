# Interpersonal Physiological Synchrony (Moving With 2019)

About this project:

This repository is for the interpersonal physiological synchrony project which is part of the larger Moving With 2019 study. In this project we compute physiological synchrony in electrodermal activity signals from participants of the Mouvement en Passage program, which includes individuals with dementia, staff, researchers, two dancers, and a musician. In this repository, you will find code for computing two measures of synchrony: Single session index (SSI), and Normalized symbolic transfer entropy (NSTE).

Code Structure:

- 01_Preprocessing: preprocessing_movingwith.m is the main preprocessing script that calls functions in the helper_functions folder. Loads all participants in a single movement session; need to specify which session to load.
- 02_FormatData: step1_concatData.m is a script that concatonates two segments of data together. This needs to be done if a participant's data is in two parts if their sensor disconnected during the middles of the session. step2_trimDatatoVidLength.m trims the physiological signals to start and end at the same time of the video recording othe movement session. The correct file for the start time of the video recording needs to be loaded.
- 03_computeSSI: SSI_main.m is the main script for computing the SSI measure. This script calls the functions in helper_functions folder.
- 04_computeNSTE: NSTE_main.m is the main script for computing NSTE. It calls functions in helper_functions folder. computeAsymmetry.m can be run after NSTE_main.m is run; this script computes the asymmetry from NSTE. paramScanning.m runs a parameter sweep over the param ranges specified; this script can be run before NSTE_main.m to determine which param values to use. plot_NSTE_figure.m plots the NSTE and asymmetry values.
- 05_computeCriterion: step1_setMissintoNaN.m is a script that sets NaN values in the SSI and NSTE variables whereever there is a NaN in the preprocessed signal; this is so that we don't interpret these values when visually anlayzing SSI and NSTE. step2_segmentDataIntoActivities.m is a script that segments the entire movement session into the four different subactivities; before running, you will need to change the start and end times of the activity, and the name of the activity depending on which session you're analyzing. step3_computeCriteria.m computes different criteria to perform statistical analysis on later. Note, we did not include any statistical analysis for this project as we didn't find anything significant. step4_formatDataTableWide.m formats the computed criteria into a table (wide).
- 2013_Lee_Reproduction: This folder contains code to reproduce the asymmetry figures from Lee et al., 2013.
- misc_scripts: This folder contains miscellaneous scripts (e.g. for plotting, rough work)
