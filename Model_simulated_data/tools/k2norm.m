function [ out ] = k2norm(in)

in2 = in / 1.5;

out = -log(1./in2 - 1);

end