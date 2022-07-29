
function [rootfile] = balancedAccuracy(rootfile,modelID,EM)

% Function to calculate balanced accuracy of a model based on the choice
% probabilities
%
%   Written by Jo Cutler February 2022 based on code from Arkady Konovalov

% INPUT:       - rootfile: file with all behavioural information necessary for fitting + outputroot
%              - modelID: ID of model to fit
%              - EM: binary flag to indicate whether the model was fit by
%                expectation maximisation (EM = 1) or
%                maximum likelihood (ML; EM = 0)
% OUTPUT:      - balanced accuracy of the model

if nargin<3 % if whether the model was fit by EM or LM is not specified, check in model data
    EM = NaN;
    while isnan(EM)
        if isfield(rootfile, 'em') && ~isfield(rootfile, 'ml')
            EM = 1;
        end
        if ~isfield(rootfile, 'em') && isfield(rootfile, 'ml')
            EM = 0;
        end
        if isfield(rootfile, 'em') && isfield(rootfile, 'ml')
            if ~isempty(rootfile.em) && isempty(rootfile.ml)
                EM = 1;
            end
            if isempty(rootfile.em) && ~isempty(rootfile.ml)
                EM = 0;
            end
        end
        if isnan(EM)
            error('Cannot find em or ml model details in the model structure')
        end
    end
end

fitops = {'ml', 'em'};

nr_trials_raw = size(rootfile.beh{1,1}.agent,1); % get number of trials
n_subj      = length(rootfile.beh); % get number of participants

if EM == 0
%     try
        for is = 1:n_subj
            eachSubChoices = rootfile.beh{1, is}.choice(rootfile.beh{1, is}.choice ~=2);
            eachSubTrialAcc = 1 - (abs(eachSubChoices - double(rootfile.(fitops{EM+1}).(modelID){1, is}.info.probOption > 0.5)));
            eachSubAcc0 = mean(eachSubTrialAcc(eachSubChoices == 0));
            eachSubAcc1 = mean(eachSubTrialAcc(eachSubChoices == 1));
            rootfile.(fitops{EM+1}).fit.(modelID).allSubAcc0(is,1) = eachSubAcc0;
            rootfile.(fitops{EM+1}).fit.(modelID).allSubAcc1(is,1) = eachSubAcc1;
            rootfile.(fitops{EM+1}).fit.(modelID).allSubAcc(is,1) = mean([eachSubAcc0, eachSubAcc1]);
            code = char(rootfile.ID{1,is}.ID);
%             disp([code, ' ', num2str(size(eachSubChoices,1)), ' ', num2str(eachSubAcc0), ' ', num2str(eachSubAcc1)])
        end
%     catch
    
    rootfile.(fitops{EM+1}).fit.(modelID).BalAcc0Mean = nanmean(rootfile.(fitops{EM+1}).fit.(modelID).allSubAcc0);
    rootfile.(fitops{EM+1}).fit.(modelID).BalAcc1Mean = nanmean(rootfile.(fitops{EM+1}).fit.(modelID).allSubAcc1);
    rootfile.(fitops{EM+1}).fit.(modelID).BalAccMean = nanmean(rootfile.(fitops{EM+1}).fit.(modelID).allSubAcc);
    rootfile.(fitops{EM+1}).fit.(modelID).BalAccSd = nanstd(rootfile.(fitops{EM+1}).fit.(modelID).allSubAcc);

%     end
% elseif EM == 1
%     try
%         for is = 1:n_subj
%             rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMean(is,1) = nanmean(nanmean(rootfile.(fitops{EM+1}).(modelID).sub{1,is}.choiceprob));
%             rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMedian(is,1) = nanmean(nanmedian(rootfile.(fitops{EM+1}).(modelID).sub{1,is}.choiceprob));
%             code = char(rootfile.ID{1,is}.ID);
%         end
%     catch
%     end
%     
%     rootfile.(fitops{EM+1}).(modelID).fit.allSubProbMedian  = nanmedian(rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMedian);
%     rootfile.(fitops{EM+1}).(modelID).fit.allSubProbMean = nanmean(rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMean);
%     rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMedianR2  = (rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMedian).^2;
%     rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMeanR2 = (rootfile.(fitops{EM+1}).(modelID).fit.eachSubProbMean).^2;
%     rootfile.(fitops{EM+1}).(modelID).fit.choiceProbMedianR2  = rootfile.(fitops{EM+1}).(modelID).fit.allSubProbMedian^2;
%     rootfile.(fitops{EM+1}).(modelID).fit.choiceProbMeanR2 = rootfile.(fitops{EM+1}).(modelID).fit.allSubProbMean^2;

end


