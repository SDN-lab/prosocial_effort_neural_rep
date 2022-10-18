function [ npar ] = get_npar( modelID)
% Lookup table to get number of free parameters per model
% MKW 2018


%%%%%
switch modelID % if adding new model functions also add the parameters here
    case 'ms_one_k_one_beta'
        params  = {'k','beta'};
    case 'ms_two_k_one_beta'
        params = {'k_self'; 'k_other'; 'beta'};
    case 'ms_two_k_two_beta'
        params = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
    case 'ms_one_k_two_beta'
        params = {'k'; 'beta_self'; 'beta_other'};
    case 'ms_one_k_one_beta_linear'
        params = {'k','beta'};
    case 'ms_two_k_one_beta_linear'
        params = {'k_self'; 'k_other'; 'beta'};
    case 'ms_two_k_two_beta_linear'
        params = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
    case 'ms_one_k_two_beta_linear'
        params = {'k'; 'beta_self'; 'beta_other'};
    case 'ms_one_k_one_beta_hyperbolic'
        params = {'k','beta'};
    case 'ms_two_k_one_beta_hyperbolic'
        params = {'k_self'; 'k_other'; 'beta'};
    case 'ms_two_k_two_beta_hyperbolic'
        params = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
    case 'ms_one_k_two_beta_hyperbolic'
        params = {'k'; 'beta_self'; 'beta_other'};
    case 'one_k_one_beta'
        params  = {'k','beta'};
    case 'two_k_one_beta'
        params = {'k_self'; 'k_other'; 'beta'};
    case 'two_k_two_beta'
        params = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
    case 'one_k_two_beta'
        params = {'k'; 'beta_self'; 'beta_other'};
    case 'one_k_one_beta_linear'
        params = {'k','beta'};
    case 'two_k_one_beta_linear'
        params = {'k_self'; 'k_other'; 'beta'};
    case 'two_k_two_beta_linear'
        params = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
    case 'one_k_two_beta_linear'
        params = {'k'; 'beta_self'; 'beta_other'};
    case 'one_k_one_beta_hyperbolic'
        params = {'k','beta'};
    case 'two_k_one_beta_hyperbolic'
        params = {'k_self'; 'k_other'; 'beta'};
    case 'two_k_two_beta_hyperbolic'
        params = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
    case 'one_k_two_beta_hyperbolic'
        params = {'k'; 'beta_self'; 'beta_other'};      
    otherwise
        error(['No parameters defined for model ', modelID, '. Check modelID parameter'])
end

npar = length(params);

end

