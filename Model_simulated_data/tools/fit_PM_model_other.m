function [modelresults] = fit_PM_model(data, modelID, kbounds, betabounds)

% INPUT:     - data
%           - sample
%           - modelID: string identifying which model to run
% OUPUT:    - modelresults: fitted model including parameter values, fval, etc.


% some optional settings for fminsearch
max_evals       = 1000000;
options         = optimset('MaxIter', max_evals,'MaxFunEvals', max_evals*100);
%

% How many subjects are you modelling


%numsubs= 3;



num_trials    = 200; % how many trials in total
num_conds     = 2; % number of conditions: 1=self and 2=other
stim_props = [num_trials;num_conds];

modelresults={};


%% Loop through subjects.
for j = 1:length(data.PM.ID) % j indexs which subject it is, and each subjects data is stored in cell in the structure
    clear chosen
    clear effort
    clear reward
    clear agent
    
    %%% 0.) Load information for that subject:    % load in each subjects variables for the experiment
    chosen = data.PM.beh{1, j}.choice; %matrix of choices on each trial
    effort = data.PM.beh{1, j}.effort; %matrix of efforst levels for each trial
    reward = data.PM.beh{1, j}.reward; %matrix of reward levels for each trial
    agent  = data.PM.beh{1, j}.agent; %matrix of condition (self or other) for each trial
    
    for i=1:length(chosen)
        
        if chosen(i)==2 %% if its a missed trial chosen = 2 so remove thes trials
            
            chosen(i)=NaN;
            reward(i)=NaN;
            effort(i)=NaN;
            agent(i)=NaN;
            
        else
            chosen(i)=chosen(i);
            reward(i) =reward(i);
            effort(i) =effort(i);
            agent(i)  =agent(i);
            
        end
        
    end
    
    chosen = chosen(~isnan(chosen));
    reward = reward(~isnan(reward));
    effort = effort(~isnan(effort));
    agent  = agent(~isnan(agent));
    
    if strcmp(modelID, 'one_k_one_beta')  % compares the string for the model you are calling, e.g. this will run the model fitting for the one discount one beta model
        
        %%%constrain parameters:
        
        lb = [0 0];   %lower bounds on parameters
        ub = [1.5 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1];  % starting values for each parameter                                                                                                                          % the starting values of the free parameters
        [out.x, out.fval, ~] = fmincon(@one_k_one_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'discount';'beta';};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout = out;
        modelout=one_k_one_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
        
    elseif strcmp(modelID, 'two_k_one_beta')
        
        %%%constrain parameters:
        
        lb = [0 0 0];   %lower bounds on parameters
        ub = [1.5 1.5 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_one_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=two_k_one_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'two_k_two_beta')
        
        %%%constrain parameters:
        
        lb = [0 0 0 0 ];   %lower bounds on parameters
        ub = [1.5 1.5 100 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 .1];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_two_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta_self'; 'beta_other'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=two_k_two_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'one_k_two_beta'),
        
        %%%constrain parameters:
        
        lb = [0 0 0];   %lower bounds on parameters
        ub = [1.5 100 100]; %upper bounds on parameters
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@one_k_two_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k'; 'beta_self'; 'beta_other'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=one_k_two_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'one_k_one_beta_linear'),
        
        %%%constrain parameters:
        
        lb = [0 0];   %lower bounds on parameters
        ub = [1.5 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@one_k_one_beta_linear, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k'; 'beta'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=one_k_one_beta_linear(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'two_k_one_beta_linear'),
        
        %%%constrain parameters:
        
        lb = [0 0 0];   %lower bounds on parameters
        ub = [1.5 1.5 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_one_beta_linear, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=two_k_one_beta_linear(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'two_k_two_beta_linear'),
        
        %%%constrain parameters:
        
        lb = [0 0 0 0];   %lower bounds on parameters
        ub = [1.5 1.5 100 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_two_beta_linear, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta_self'; 'beta_other'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=two_k_two_beta_linear(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'one_k_two_beta_linear'),
        
        %%%constrain parameters:
        
        lb = [0 0 0];   %lower bounds on parameters
        ub = [1.5 100 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@one_k_one_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k'; 'beta_self'; 'beta_other'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=one_k_one_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'one_k_one_beta_hyperbolic'),
        
        %%%constrain parameters:
        
        lb = [0 0];   %lower bounds on parameters
        ub = [1.5 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@one_k_one_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k'; 'beta'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=one_k_one_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'two_k_one_beta_hyperbolic'),
        
        %%%constrain parameters:
        
        lb = [0 0 0];   %lower bounds on parameters
        ub = [1.5 1.5 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_one_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=two_k_one_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'two_k_two_beta_hyperbolic'),
        
        %%%constrain parameters:
        
        lb = [0 0 0 0];   %lower bounds on parameters
        ub = [1.5 1.5 100 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_two_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta_self'; 'beta_other'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=two_k_two_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'one_k_two_beta_hyperbolic')
        
        %%%constrain parameters:
        
        lb = [0 0 0];   %lower bounds on parameters
        ub = [1.5 100 100]; %upper bounds on parameters
        
        %%% I.) first fit the model:
        outtype=1;
        Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@one_k_two_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k'; 'beta_self'; 'beta_other'};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;
        modelout=one_k_two_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype);
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
        
        
    end
    
    
    
    
end
