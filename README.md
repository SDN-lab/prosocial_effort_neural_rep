### This folder contains the scripts and functions to run:

- #### i) effort-discounting models (with maximum likelihood estimation; mle) on participant data [subfolder Model_real_data]
- #### ii) model identifiability and parameter recovery [subfolder Model_simulated_data]
- #### iii) analysis on the model parameters, trial by trial behavioural data, and MRI data with plots [subfolder PM_R_code]

[Click here to view plots and main results](https://github.com/SDN-lab/prosocial_effort_neural_rep/blob/main/PM_R_code/Prosocial_effort_analysis.md)

### For analysis of the real participant data (i & iii):

#### Step 0 (if data not already in MATLAB structure) - Convert data to the required format from Presentation .log / .csv / .xlsx formats

#### Step 1 - Run_mle_model.m 
Script to run and compare models using maximum likelihood estimation fit

##### Output from script
   - matlab variables
   	- 's.PL.ml'  - contains model results including the model parameters for each participant
	- 'output.winModel7' - compares two main models (7 & 10), used in model_comp_7_10_relative_BIC.csv
   - datafiles in specified output directory:
       - K_values_PM_fmri_two_k_one_beta.csv - estimated parameters for each participant
     
#### Step 2 - create datafile
Match parameters from K_values_PM_fmri_two_k_one_beta with other behavioural and MRI data in a wide data format for analysis (see PM_fmri_questionnaire_wo_excluded_totals_share.csv)

#### Step 3 - Create data files of trial by trial behavioural data (see lme4_PM_data_6_21.csv)

#### Step 4 - Prosocial_effort_analysis.Rmd
Run analysis using R project, script, and files from above output (note sections of this script also plot results from simulation experiments - model identifiability and parameter recovery - see below and use results from RSA analysis).

### For simulation experiments (ii):

#### Step 1 - Simulate_PR_MI_data_PM.m 
Script to run model identifiability and / or parameter recovery

#### Step 2 - Prosocial_effort_analysis.Rmd 
Plot results using R script

### Prosocial effort discounting models 
Based on [Lockwood et al. (2017), *Nature Human Behaviour*](https://doi.org/10.1038/s41562-017-0131) - test different variations of k and beta parameters

#### Models compared combine all combinations of single or separate k and single or separate beta parameters:
##### - one_k_one_beta
##### - two_k_one_beta
##### - one_k_two_beta
##### - two_k_two_beta
#### and different shapes for the discounting (k) parameter:
##### - parabolic 
##### - linear
##### - hyperbolic  

### Developed using:

MATLAB 2019b - requires Econometrics and Bioinformatics toolboxes

macOS 10.15 Catalina / 11.1 Big Sur

R version 3.6.2 (2019-12-12)