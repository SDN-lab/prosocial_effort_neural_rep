
function [f, allout] = all_simulate(effort, reward, agent, p, model)% same as in models above in same order

params = get_params(['ms_', model]);

%%%%% 1. Assign free parameters and other stuff:

if contains(model, 'one_k')
    discount = p(1);
    rew1 = 2;
elseif contains(model, 'two_k')
    discount = (agent==1).*p(1) + (agent==2).*p(2);
    rew1 = 3;
elseif ~contains(model, 'k')
    rew1 = 1;
else
    error(['Cant`t determine number of k parameters from model name: ', model])
end

if contains(model, 'one_rew')
    rew = p(rew1);
    beta1 = rew1 + 1;
elseif contains(model, 'two_rew')
    rew = (agent==1).*p(rew1) + (agent==2).*p(rew1+1);
    beta1 = rew1 + 2;
elseif ~contains(model, 'rew')
    beta1 = rew1;
else
    error(['Cant`t determine number of rew parameters from model name: ', model])
end

if contains(model, 'one_beta')
    beta = p(beta1);
elseif contains(model, 'two_beta')
    beta = (agent==1).*p(beta1) + (agent==2).*p(beta1+1);
else
    error(['Cant`t determine number of beta parameters from model name: ', model])
end

base = 1;

if contains(model, 'k') && contains(model, 'rew')
    
    %%%% Model - devalue reward by effort & include reward sensitivity
    
    if contains(model, 'linear')
        val = (rew.*(reward)) - (discount.*(effort));
    elseif contains(model, 'hyperbolic')
        val = (rew.*(reward)) ./ (1 + (discount.*(effort)));
    else
        val = (rew.*(reward)) - (discount.*(effort.^2));
    end
    
else
    
    if contains(model, 'diff')
        
        val = discount.* (reward - effort);
        
    elseif contains(model, 'rew')
        
        %%%% Model - reward sensitivity
        
        if contains(model, 'linear')
            val = (rew.*(reward)) - effort;
        elseif contains(model, 'hyperbolic')
            val = (rew.*(reward)) ./ (1 + effort);
        else
            val = (rew.*(reward)) - (effort.^2);
        end
        
    elseif contains(model, 'k')
        
        %%%% Model - devalue reward by effort
        
        if contains(model, 'linear')
            val = reward - (discount.*(effort));
        elseif contains(model, 'hyperbolic')
            val = reward ./ (1 + (discount.*(effort)));
        else
            val = reward - (discount.*(effort.^2));
        end
        
    end
    
end

prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));

for t = 1:length(prob)
    chosen(t,1) = double(rand < (prob(t)));
end

prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

% calculate neg-log-likelihood
f=-nansum(log(prob));

allout.all_V= val;
allout.prob = prob;
allout.data = chosen;
allout.choice = chosen;
allout.agent = agent;
allout.effort = effort;
allout.reward = reward;

end
