function [ beta_out ] = beta_logsig2norm(beta)

beta2 = beta / 5;
beta2 = beta / 10;

beta_out = -log(1./beta2 - 1);

end