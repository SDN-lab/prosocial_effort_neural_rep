function [output] = visualize_model_PM(allmodels, data)
% Analyses visualise results
% trials
% INPUT:    - allmodels: struct with all model parameters in it
%           - modelID: string if you want to pick one specific model
%           - doanalyse: vector indicating which analyses to run
% OPTIONS:  - doanalyse:    1. Plot AIC/BIC/NNL for all models
% OUPUT:    - variable called output that contains the summed AIC, BIC and
%             negative log likelihood as well as the values for each individual subject

%%

figpath='figs';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 1. Plot AIC/BIC/NNL for all models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
allmodel_IDs={ 'onekonebeta'      'onekonebetamodellinear' 'onekonebetamodelhyperbolic' ...
               'onektwobetamodel' 'onektwobetamodellinear' 'onektwobetamodelhyperbolic'...
               'twokonebetamodel' 'twokonebetamodellinear' 'twokonebetamodelhyperbolic' ...
               'twoktwobetamodel' 'twoktwobetamodellinear' 'twoktwobetamodelhyperbolic' };

allmodel_IDs=strrep(allmodels,'_','');

figure;

no_o_models=numel(allmodel_IDs);
   
for imodel=1:no_o_models
      
    modelID=allmodels{imodel};

    %pick model:
    
    mod=data.(modelID);
      
    
    % information you want to have:
    
    all_nnl=[];
    all_aic=[];
    all_bic=[];
    all_param=[];
    
    % loop over subjects
    for is=1:numel(mod)
        nr_trials = size((mod{is}.info.prob),1);   %%%% determine number of trials, missed have been removed
        all_param=[all_param; mod{is}.x];
        param_names= mod{1}.xnames;
        nr_free_p=length(mod{is}.x);
        all_nnl=[all_nnl; mod{is}.fval];
        [aic, bic]=aicbic(-mod{is}.fval, nr_free_p, nr_trials);
        all_aic=[all_aic; aic];
        all_bic=[all_bic; bic];     
    end
    
    
    output.all_aic_all(:,imodel)=all_aic;      % all subjects indidiuval aic values
    output.all_bic_all(:,imodel)=all_bic;      % all subjects indidiuval bic values
    output.all_nnl_all(:,imodel)=all_nnl;      % all subjects indidiuval nll values
    output.sum_all_aic(:,imodel)=sum(all_aic); % summed value
    output.sum_all_bic(:,imodel)=sum(all_bic);
    output.sum_all_nnl(:,imodel)=sum(all_nnl);
    

    bar(mean(all_param));
    
    set(gca, 'xtick',1:numel(param_names),'xticklabel',param_names)
    
    %errorbar(std(all_param),'k.')
    
%    figname=(modelID);
%    full_figname=[figpath '/' figname  ];
%    savefig(gcf,[full_figname '.fig']);
   close all; 
 
end

%%plot AIC, BIC and NLL

subplot(3,1,1)
plot(output.all_aic_all)
legend(allmodel_IDs); title('AIC');

 
hold on;

subplot(3,1,2)
plot(output.all_bic_all)
legend(allmodel_IDs); title('BIC');
hold on;

subplot(3,1,3)
plot(output.all_nnl_all)
 legend(allmodel_IDs); title('NLL');
% figname=('modelfit_aic_bic_nll');
% full_figname=[figpath '/' figname  ];
% savefig(gcf,[full_figname '.fig']);

close all

subplot(3,1,1)
bar(output.sum_all_aic)

hold on;

subplot(3,1,2)
bar(output.sum_all_bic)

hold on;

subplot(3,1,3)
bar(output.sum_all_nnl)

% figname=('modelfit_aic_bic_nll_bar');
% full_figname=[figpath '/' figname  ];
% savefig(gcf,[full_figname '.fig']);

close all




