%%% Random Binary Prediction (Bernoulli Distribution)
%
% function Class = Prediction_Cls_RND(MODEL,X)
%
function Class = Prediction_Cls_RND(MODEL,X)
%% Initialization
Prop = MODEL.RND;
N    = size(X,1);
NRUN = 100;
%% Random number
rng('shuffle');
r = mean(rand(N,NRUN),2);
%% Class
Class = sign(r-Prop);
