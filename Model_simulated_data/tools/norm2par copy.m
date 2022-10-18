function [ qout,qbounds ] = norm2par(modelID,qin)
% Lookup table to transform gaussian parameters to real parameter values for all models;
%  
% columns are different free parameters, have to be in the order defined by the model
% MKW 2017 modified by PL 2019
%
%
% INPUT:    - qin: input parameters, observation x parameter
% OUTPUT:   - qout: output parameters qin, transformed
%           - qbounds: sensible bounds for the parameter, rows are min/max, cols are parameters

%% in case input is a vector

if size(qin,2)==1, qin = qin'; end                                           % transpose input if it has wrong dimension, but only if it is a n x 1 vector

if       strcmp(modelID,'ms_two_k_two_beta')   
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2k(qin(:,2)) norm2beta(qin(:,3)) norm2beta(qin(:,4))];  
   qbounds  = [0 1.5; 0 1.5; 0 100; 0 100]';
   
elseif       strcmp(modelID,'ms_two_k_one_beta')   
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2k(qin(:,2)) norm2beta(qin(:,3))];  
   qbounds  = [0 1.5; 0 1.5; 0 100;]';
   
elseif       strcmp(modelID,'ms_one_k_one_beta')
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2beta(qin(:,2))];
   qbounds  = [0 1.5; 0 100;]';
    
elseif       strcmp(modelID,'ms_one_k_two_beta')
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2beta(qin(:,2)) norm2beta(qin(:,2))];
   qbounds = [0 1.5; 0 100; 0 100;]';
   
elseif       strcmp(modelID,'ms_two_k_two_beta_linear')   
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2k(qin(:,2)) norm2beta(qin(:,3)) norm2beta(qin(:,4))];  
   qbounds  = [0 1.5; 0 1.5; 0 100; 0 100]';
   
elseif       strcmp(modelID,'ms_two_k_one_beta_linear')   
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2k(qin(:,2)) norm2beta(qin(:,3))];  
   qbounds  = [0 1.5; 0 1.5; 0 100;]';
   
elseif       strcmp(modelID,'ms_one_k_one_beta_linear')
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2beta(qin(:,2))];
   qbounds  = [0 1.5; 0 100;]';
    
elseif       strcmp(modelID,'ms_one_k_two_beta_linear')
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2beta(qin(:,2)) norm2beta(qin(:,2))];
   qbounds = [0 1.5; 0 100; 0 100;]';
   
   elseif       strcmp(modelID,'ms_two_k_two_beta_hyperbolic')   
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2k(qin(:,2)) norm2beta(qin(:,3)) norm2beta(qin(:,4))];  
   qbounds  = [0 1.5; 0 1.5; 0 100; 0 100]';
   
elseif       strcmp(modelID,'ms_two_k_one_beta_hyperbolic')   
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2k(qin(:,2)) norm2beta(qin(:,3))];  
   qbounds  = [0 1.5; 0 1.5; 0 100;]';
   
elseif       strcmp(modelID,'ms_one_k_one_beta_hyperbolic')
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2beta(qin(:,2))];
   qbounds  = [0 1.5; 0 100;]';
    
elseif       strcmp(modelID,'ms_one_k_two_beta_hyperbolic')
   if size(qin,2)~=get_npar(modelID), disp('ERROR'); keyboard; end
   qout     = [norm2k(qin(:,1)) norm2beta(qin(:,2)) norm2beta(qin(:,2))];
   qbounds = [0 1.5; 0 100; 0 100;]';
   
   
end

