%%%%%%%%%
%% Modelling for prosocial motivation task using maximum likelihood estimation
%%%%%%%%%

% Fits models using maximum likelihood estimation (mle) approach and does model comparison
% Written by Patricia Lockwood
% Based on code by Marco Wittmann, September 2016
% Edited by Jo Cutler, August 2020
% Models with reward sensitivity (rew) parameters added by PL and JC, February 2022
% Models with just rew (no k) or difference added by JC, June 2022

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

clearvars -except
addpath('models');
addpath('tools');
setFigDefaults; % custom function - make sure it is in the folder

rng default % resets the randomisation seed to ensure results are reproducible (MATLAB 2019b)

output_dir = '../PM_R_code/'; % enter path to save output in **

%== 0) Load and organise data: ==========================================================================================
% load data:
file_name = 'all_data_fmri_wo_110_125_132'; % specify data **
load([file_name, '.mat']); % .mat file saved from the behavioural script that contains all participants data in 's'

% the names of the different models you want to try
% MODELS = {'one_k_one_beta', 'one_k_one_beta_linear', 'one_k_one_beta_hyperbolic'...
%     'one_k_two_beta', 'one_k_two_beta_linear', 'one_k_two_beta_hyperbolic'...
%     'two_k_one_beta', 'two_k_one_beta_linear', 'two_k_one_beta_hyperbolic'...
%     'two_k_two_beta', 'two_k_two_beta_linear', 'two_k_two_beta_hyperbolic'};

MODELS = {'one_k_one_beta', 'one_k_one_beta_linear', 'one_k_one_beta_hyperbolic',...
    'one_k_two_beta', 'one_k_two_beta_linear', 'one_k_two_beta_hyperbolic',...
    'two_k_one_beta', 'two_k_one_beta_linear', 'two_k_one_beta_hyperbolic',...
    'two_k_two_beta', 'two_k_two_beta_linear', 'two_k_two_beta_hyperbolic',...
    'one_rew_one_beta', 'one_rew_one_beta_linear', 'one_rew_one_beta_hyperbolic',...
    'one_rew_two_beta', 'one_rew_two_beta_linear', 'one_rew_two_beta_hyperbolic',...
    'two_rew_one_beta', 'two_rew_one_beta_linear', 'two_rew_one_beta_hyperbolic',...
    'two_rew_two_beta', 'two_rew_two_beta_linear', 'two_rew_two_beta_hyperbolic',...
    'one_k_one_beta_linear_diff', 'one_k_two_beta_linear_diff',...
    'two_k_one_beta_linear_diff', 'two_k_two_beta_linear_diff',...
    'one_k_one_beta_one_rew', 'one_k_one_beta_linear_one_rew', 'one_k_one_beta_hyperbolic_one_rew',...
    'one_k_two_beta_one_rew', 'one_k_two_beta_linear_one_rew', 'one_k_two_beta_hyperbolic_one_rew',...
    'two_k_one_beta_two_rew', 'two_k_one_beta_linear_two_rew', 'two_k_one_beta_hyperbolic_two_rew',...
    'two_k_two_beta_two_rew', 'two_k_two_beta_linear_two_rew', 'two_k_two_beta_hyperbolic_two_rew'};

aicorbic       = 'bic'; % criteria used for model selection - 'aic' or 'bic'
nrep           = 1; % how many iterations of mle fit to run (so parameters don't get stuck in local minima)
% can be 1 for decision-making tasks as unlikely to make a difference
% but more important to be >1 for learning tasks

nSubs          = max(size(s.PM.beh)); % number of ppts
nTrials        = length(s.PM.beh{1,1}.choice);
doFigure       = 0;

minEffort = min(s.PM.beh{1, 1}.effort); % minimum effort level
maxReward = max(s.PM.beh{1, 1}.reward); % maximum reward level

% maxK = maxValue(s,'k',MODELS); % calculate maximum k
maxK = 1.5; % if k and reward need to limit one
if any(contains(MODELS, 'rew'))
    maxrew = maxValue(s,'rew',MODELS); % calculate maximum rewsen parameter
    rewbounds = [0, maxrew]; % enter bounds on reward sensitivity values here **
else
    rewbounds = [];
end
kbounds = [0, maxK]; % enter bounds on k values here **
betabounds = [0, 10]; % enter bounds on beta values here **

for sub=1:length(s.PM.ID)
    
    ID_all(sub, :)=s.PM.ID{1,sub}.ID;
    
end

%% 1. Run models for first time

if 1
    for imod = 1:length(MODELS)
        modelID=MODELS{imod};
        for i=1:nrep
            s.PM.ml.(modelID) = fit_PM_model(s, modelID, kbounds, rewbounds, betabounds, i);
        end
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
        s.PM.ml.fit.(modelID).allsubprobmedian(sub) = median(median(s.PM.ml.(modelID){1, sub}.info.prob),'omitnan');
        s.PM.ml.fit.(modelID).allsubproboptionmean(sub) = nanmean(nanmean(s.PM.ml.(modelID){1, sub}.info.probOption));
        s.PM.ml.fit.(modelID).allsubproboptionmedian(sub) = median(median(s.PM.ml.(modelID){1, sub}.info.probOption),'omitnan');
        
    end
    
    s.PM = balancedAccuracy(s.PM,modelID,0);
    %     s.PM.ml.fit.(modelID).pseudoR2 = pseudoR2(s.PM,modelID,2,0);
    s.PM = choiceProbR2(s.PM,modelID,0);
    
    fits(imod,1) = output.sum_all_aic(imod);
    fits(imod,2) = output.sum_all_bic(imod);
    fits(imod,3) = s.PM.ml.fit.(modelID).choiceProbMedianR2;
    fits(imod,4) = s.PM.ml.fit.(modelID).BalAccMean;
    fitnames = {'AIC', 'BIC', 'R2', 'BA'};
    
end

fitstab = cell2table(num2cell(fits), "VariableNames", fitnames, "RowNames", MODELS);
fitstab.Properties.DimensionNames{1} = 'Model';
% writetable(fitstab,[output_dir, 'data/model_R2_BA.csv'],'WriteRowNames',true)

lowaicid = find(output.sum_all_aic == min(output.sum_all_aic)); % find the model number with the lowest aic
lowbicid = find(output.sum_all_bic == min(output.sum_all_bic)); % find the model number with the lowest bic
if lowaicid ~= lowbicid
    if strcmp(aicorbic,'aic')
        lowid = lowaicid;
    elseif strcmp(aicorbic,'bic')
        lowid = lowbicid;
    else
        error('Please specify at start whether to use aic or bic for model comparison')
    end
    disp('Model with best overall fit stat depends on whether use AIC or BIC')
    disp(['Model with lowest AIC is ',MODELS{1,lowaicid}])
    disp(['Model with lowest BIC is ',MODELS{1,lowbicid}])
    disp(['User specified to use ',upper(aicorbic),' for model comparison so selecting model ',MODELS{1,lowid}])
elseif lowaicid == lowbicid
    lowid = lowaicid;
    disp(['Model with best overall fit stat is ', MODELS{1,lowid}, ' regardless of whether use AIC or BIC'])
end

%% 3. check if model 7 or another model wins in most people

compmod = lowid;

bestFit=[output.all_bic_all(:,7),output.all_bic_all(:,compmod)];

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
    lowid = 7;
    disp(['Model 7, ', MODELS{1,7}, ' is better than model ', num2str(compmod), ', ', MODELS{1,compmod}, ' for ', num2str(round(output.winModel7percent)),'% of people - using model 7'])
else
    lowid = compmod;
    disp(['Model ', num2str(compmod), ', ', MODELS{1,compmod}, ' is better than model 7, ', MODELS{1,7}, ' for ', num2str(round(100 - output.winModel7percent)),'% of people - using model ', num2str(lowaicid)])
end

output.RsquaredMed     = (median(s.PM.ml.fit.(MODELS{lowid}).allsubprobmedian)).^2;
output.RsquaredMean    = (mean(s.PM.ml.fit.(MODELS{lowid}).allsubprobmean)).^2;
output.RsquaredMedstd  = std(s.PM.ml.fit.(MODELS{lowid}).allsubprobmedian);
output.RsquaredMeanstd = (mean(s.PM.ml.fit.(MODELS{lowid}).allsubprobmean));

%% 4. store a new variables with the model parameters
% you might need to update this if adding new models

for sub=1:nSubs
    
    params(sub,:) = s.PM.ml.(MODELS{lowid}){1,sub}.x;
    selfchoices = s.PM.beh{1,sub}.choice(s.PM.beh{1,sub}.agent == 1);
    selfmean = nanmean(selfchoices(selfchoices == 0 | selfchoices == 1));
    otherchoices = s.PM.beh{1,sub}.choice(s.PM.beh{1,sub}.agent == 2);
    othermean = nanmean(otherchoices(otherchoices == 0 | otherchoices == 1));
    choices(sub,1:2) = [selfmean, othermean];
    
end

params(:,end+1) = params(:,2) - params(:,1);

toSave = [params, choices];
names = getparnames(MODELS{lowid});
names = ['ID', names, 'other_k_minus_self_k', 'self_choice', 'other_choice'];

toSave = cell2table([ID_all,num2cell(toSave)],'VariableNames', names);
% writetable(toSave,[output_dir, 'data/K_values_choices_PM_fmri_', MODELS{lowid}, '.csv'])

%% 5. compare SV with rewsen
if any(contains(MODELS, 'two_k_one_beta_two_rew'))
    
    for sub=1:nSubs
        svCorr(sub) = corr(s.PM.ml.two_k_one_beta{1, sub}.info.all_V, s.PM.ml.two_k_one_beta_two_rew{1, sub}.info.all_V);
    end
    
    svCorrAv = mean(svCorr);
    svCorrSD = std(svCorr);
    svCorrSE = std(svCorr) / sqrt(length(svCorr));
    
end

save(['workspaces/MLE_fit_results_k_',num2str(maxK),'_',date,'.mat'])