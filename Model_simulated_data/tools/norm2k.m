function [ out ] = norm2k(in)
% transformation from gaussian space to alpha space, as suggested in Daw 2009 Tutorial
% MKW October 2017

%out = 2*(logsig(in)-.5); 

out = logsig(in).*(1.5);

%pat = logsig(x).*(1.5);

end

