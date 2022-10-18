function [ beta_out ] = norm2beta_logsig(beta)
% transformation from gaussian space to alpha space, as suggested in Daw 2009 Tutorial
% MKW October 2017

beta_out = logsig(beta)*5;%./2;%+.01;%+.01; %.02 
beta_out = logsig(beta)*10;%./2;%+.01;%+.01; %.02 

end

