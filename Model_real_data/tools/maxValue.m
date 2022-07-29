function [maximum] = maxValue(s, param, models)

% Get maximum values (parameter upper bounds) for parameters:
% k - effort discounting
% rew - reward sensitivity
% input "param" must match one of the above paramter names

% Jo Cutler March 2022

minEffort = min(s.PM.beh{1, 1}.effort); % minimum effort level
maxEffort = max(s.PM.beh{1, 1}.effort); % maximum effort level
minReward = min(s.PM.beh{1, 1}.reward); % minimum reward level
maxReward = max(s.PM.beh{1, 1}.reward); % maximum reward level

% maximum k calculated as the discount rate that means the
% maximum reward and minimum effort has a value of 0

% val = reward - (discount.*(effort.^2));
maxKp = round(maxReward - 0)/(minEffort^2); % parabolic
% val = reward - (discount.*(effort));
maxKl = (maxReward - 0)/(minEffort); % linear
% val = reward ./ (1 + (discount.*(effort)));
maxKh = (maxReward)/(minEffort*2); % hyperbolic

maxK = round(max([maxKp, maxKl, maxKh]),2);
    
% maximum rew calculated as the reward sensitivity rate that means the
% minimum reward, maximum effort and maximum k (for the relevant
% discount function) has a value of 2

%     val = (rew.*(reward)) - (discount.*(effort.^2));
maxPp = (2 + (maxKp*(maxEffort^2))) / minReward; % parabolic
%     val = (rew.*(reward)) - (discount.*(effort));
maxRl = (2 + (maxKl*maxEffort)) / minReward; % linear
%     val = (rew.*(reward)) ./ (1 + (discount.*(effort)));
maxRh = (2 + (2*maxKh*maxEffort)) / minReward; % hyperbolic

maxrew = round(max([maxPp, maxRl, maxRh]),2);

switch param
    case 'k'
        maximum = maxK;
    case 'rew'
        maximum = maxrew;
end

end

