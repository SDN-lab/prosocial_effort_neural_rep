function [f] = all_real(p, chosen, effort, reward, agent, modelID, outtype)% same as in models above in same order

%%%%% 1. Assign free parameters and other stuff:

if contains(modelID, 'one_k')
    discount = p(1);
    rew1 = 2;
elseif contains(modelID, 'two_k')
    discount = (agent==1).*p(1) + (agent==2).*p(2);
    rew1 = 3;
elseif ~contains(modelID, 'k')
    rew1 = 1;
else
    error(['Cant`t determine number of k parameters from model name: ', modelID])
end

if contains(modelID, 'one_rew')
    rew = p(rew1);
    beta1 = rew1 + 1;
elseif contains(modelID, 'two_rew')
    rew = (agent==1).*p(rew1) + (agent==2).*p(rew1+1);
    beta1 = rew1 + 2;
elseif ~contains(modelID, 'rew')
    beta1 = rew1;
else
    error(['Cant`t determine number of rew parameters from model name: ', modelID])
end

if contains(modelID, 'one_beta')
    beta = p(beta1);
elseif contains(modelID, 'two_beta')
    beta = (agent==1).*p(beta1) + (agent==2).*p(beta1+1);
else
    error(['Cant`t determine number of beta parameters from model name: ', modelID])
end

base = 1;

if contains(modelID, 'k') && contains(modelID, 'rew')
    
    %%%% Model - devalue reward by effort & include reward sensitivity
    
    if contains(modelID, 'linear')
        val = (rew.*(reward)) - (discount.*(effort));
    elseif contains(modelID, 'hyperbolic')
        val = (rew.*(reward)) ./ (1 + (discount.*(effort)));
    else
        val = (rew.*(reward)) - (discount.*(effort.^2));
    end
    
else
    
    if contains(modelID, 'diff')
        
        val = discount.* (reward - effort);
        
    elseif contains(modelID, 'rew')
        
        %%%% Model - reward sensitivity
        
        if contains(modelID, 'linear')
            val = (rew.*(reward)) - effort;
        elseif contains(modelID, 'hyperbolic')
            val = (rew.*(reward)) ./ (1 + effort);
        else
            val = (rew.*(reward)) - (effort.^2);
        end
        
    elseif contains(modelID, 'k')
        
        %%%% Model - devalue reward by effort
        
        if contains(modelID, 'linear')
            val = reward - (discount.*(effort));
        elseif contains(modelID, 'hyperbolic')
            val = reward ./ (1 + (discount.*(effort)));
        else
            val = reward - (discount.*(effort.^2));
        end
        
    end
    
end

prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
probOption = prob; % probability of choosing each option
prob(~chosen) =  1 - prob(~chosen); % probability of choosing the chosen option

if any(size(prob) == 1) && any(size(prob) == max(size(agent)))
    if size(prob,1) == max(size(agent))
        prob = prob(:,1);
    elseif size(prob,2) == max(size(agent))
        prob = prob(1,:);
    else
        error('Check dimensions of prob variable - should be 1*ntrials or ntrials*1');
    end
else
    error('Check dimensions of prob variable - should be 1*ntrials or ntrials*1');
end

% calculate neg-log-likelihood
f=-nansum(log(prob));

if outtype==2
    allout.all_V= val;
    allout.prob = prob;
    allout.probOption = probOption;
    f=allout;
    
end
