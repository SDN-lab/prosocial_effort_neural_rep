
function [f] = two_k_two_beta_linear(p,chosen,effort,reward,agent,stim_props,outtype)% same as in models above in same order
% p(1) = self discount 
% p(2) = other discount
% p(3) = beta self
% p(4) = beta other

%%%%% 1. Assign free parameters and other stuff:
discount = (agent==1).*p(1) + (agent==2).*p(2);
beta = (agent==1).*p(3) + (agent==2).*p(4);

base = 1;

num_trials=stim_props(1);%24
num_conds=stim_props(2);%3



%%%% Model -linear devalue reward by effort. 2 discount parameters 

val = reward - (discount.*(effort));
prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

% calculate neg-log-likelihood
f=-nansum(log(prob));

if outtype==2,
    allout.all_V= val;
    allout.prob = prob;
    f=allout;

end


