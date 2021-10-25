%%%%%%%%%
%% Modelling for prosocial motivation task using maximum likelihood estimation
%%%%%%%%%

% Fits models using maximum likelihood estimation (mle) approach and does model comparison
% Written by Patricia Lockwood 
% Based on code by Marco Wittmann, September 2016
% Edited by Jo Cutler, August 2020

%%%%%%%%%
% Step 1 - get data in the format of a varible 's' that contains a struct for each persons data
% Step 2 - run this script to fit models
% Dependencies: tools subfolder containing required functions e.g. fit_PM_model
%               models subfolder containing various comp models you have made 
% Step 3 - compare the AIC's and BIC's using the script visualize_model_PM
% (see below)
 
%% Input for script
%       - Participants data file format saved in 's':

%% Output from script
%       - 'output' contains the AIC/BIC for each model
%       - 's.PM.ml' contains model results from the maximum likelihood fit, including the model parameters per ppt  in 'modelparam' e.g. alpha, beta
      
%% Prosocial motivation models based Lockwood et al. (2017)
% test different variations of discount rate (k) and beta parameters:
%   - one_k_one_beta
%   - two_k_one_beta
%   - one_k_two_beta
%   - two_k_two_beta
% and shape of discounting:
%   - parabolic 
%   - linear
%   - hyperbolic                                        

%%

%== -I) Prepare workspace: ============================================================================================

clearvars
addpath('models');
addpath('tools');
setFigDefaults; % custom function - make sure it is in the folder

rng default % resets the randomisation seed to ensure results are reproducible (MATLAB 2019b)

output_dir = '../PM_R_code/'; % enter path to save output in **

%== 0) Load and organise data: ==========================================================================================
% load data:
file_name = 'all_data_fmri_wo_110_125_132'; % specify data **
load([file_name, '.mat']); % .mat file saved from the behavioural script that contains all participants data in 's'

% [~, ~, groups] = xlsread('Group_index.xlsx'); % specify file where rows have IDs and a column indicates groups

% the names of the different models you want to try 
MODELS = {'one_k_one_beta', 'one_k_one_beta_linear', 'one_k_one_beta_hyperbolic'...
    'one_k_two_beta', 'one_k_two_beta_linear', 'one_k_two_beta_hyperbolic'...
    'two_k_one_beta', 'two_k_one_beta_linear', 'two_k_one_beta_hyperbolic'...
    'two_k_two_beta', 'two_k_two_beta_linear', 'two_k_two_beta_hyperbolic'};

aicorbic       = 'aic'; % criteria used for model selection - 'aic' or 'bic'

nSubs          = max(size(s.PM.beh)); % number of ppts
nTrials        = length(s.PM.beh{1,1}.choice);
doFigure       = 0;

for sub=1:length(s.PM.ID)
    
ID_all(sub, :)=s.PM.ID{1,sub}.ID;

end

%% 1. Run models for first time

if 1
    for imod = 1:length(MODELS)
        modelID=MODELS{imod}; 
        s.PM.ml.(modelID) = fit_PM_model(s,modelID);   % one LR one beta
    end
end

%% 2. Visualize and compare models:
% 'visualize_model_PM' is a function that calculates AIC and BIC for model comparison 
% 'output' variable generated contains 'sum_all_aic' and 'sum_all_bic'
output=visualize_model_PM(MODELS, s.PM.ml);

for imod = 1:length(MODELS)
    modelID =  MODELS{imod};
    
    for sub=1:nSubs % loop through the number of ppts
        
        s.PM.ml.fit.(modelID).allsubprobmean(sub) = nanmean(nanmean(s.PM.ml.(modelID){1, sub}.info.prob));
        s.PM.ml.fit.(modelID).allsubprobmedian(sub) = median(median(s.PM.ml.(modelID){1, sub}.info.prob),'omitnan');% This will store the overall predictive probability of the model :-) add 'mean(allSubPRob)' to calculate group mean
        
    end
    
    s.PM.ml.fit.(modelID).pseudoR2 = pseudoR2(s.PM,modelID,2,0);
%     s.PM.ml.fit.(modelID).choiceProbR2 = choiceProbR2(s.PM,modelID,0);
    
end

lowaicid = find(output.sum_all_aic == min(output.sum_all_aic)); % find the model number with the lowest aic
lowbicid = find(output.sum_all_bic == min(output.sum_all_bic)); % find the model number with the lowest bic
if lowaicid ~= lowbicid
    if strcmp(aicorbic,'aic')
        bestmodel = lowaicid;
    elseif strcmp(aicorbic,'bic')
        bestmodel = lowbicid;
    else
        error('Please specify at start whether to use aic or bic for model comparison')
    end
    disp('Best model depends on whether use AIC or BIC')
    disp(['Model with lowest AIC is ',MODELS{1,lowaicid}])
    disp(['Model with lowest BIC is ',MODELS{1,lowbicid}])
    disp(['User specified to use ',upper(aicorbic),' for model comparison so selecting model ',MODELS{1,bestmodel}])
elseif lowaicid == lowbicid
    bestmodel = lowaicid;
    disp(['Best model is ', MODELS{1,bestmodel}, ' regardless of whether use AIC or BIC'])
end

%% 3. check if model 7 or 10 wins in most people

bestFit=[output.all_bic_all(:,7),output.all_bic_all(:,10)];

for i=1:length(bestFit)
    
    if bestFit(i,1)<bestFit(i,2)
        model(i)=1;
    else
        model(i)=0;
    end
end

output.winModel7=sum(model);
output.winModel7percent = (output.winModel7./nSubs)*100;

if output.winModel7percent > 50
    bestmodel = 7;
    disp(['Model 7, ', MODELS{1,7}, ' is best for most people - using model 7'])
else
    bestmodel = 10;
    disp(['Model 7, ', MODELS{1,10}, ' is best for most people - using model 10'])
end

output.RsquaredMed     = (median(s.PM.ml.fit.(MODELS{bestmodel}).allsubprobmedian)).^2;
output.RsquaredMean    = (mean(s.PM.ml.fit.(MODELS{bestmodel}).allsubprobmean)).^2;
output.RsquaredMedstd  = std(s.PM.ml.fit.(MODELS{bestmodel}).allsubprobmedian);
output.RsquaredMeanstd = (mean(s.PM.ml.fit.(MODELS{bestmodel}).allsubprobmean));

%% 3. store a new variables with the model parameters
% you need to update this wih all for the new models that you add, it
% saves the learning rate and beta parameters for each particiapnt
    
for sub=1:nSubs
    
    params(sub,:) = s.PM.ml.(MODELS{bestmodel}){1,sub}.x;
    
end

params(:,end+1) = params(:,2) - params(:,1);

toSave = params;
names = getparnames(MODELS{bestmodel});
names = ['ID', names, 'other_k_minus_self_k'];

toSave = cell2table([ID_all,num2cell(toSave)],'VariableNames', names);
writetable(toSave,[output_dir, 'data/K_values_PM_fmri_', MODELS{bestmodel}, '.csv'])