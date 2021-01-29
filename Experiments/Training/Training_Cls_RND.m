%%% Random Binary (Bernoulli Distribution)
%
% function Model = Training_Cls_RND(XTra,YTra,OptFlag)
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
function Model = Training_Cls_RND(XTra,YTra,OptFlag)

%% Hyperparameter
% if OptFlag
%     NRND = length(YTra);
% else
%     NRND = 1;
% end
NRND = 0.5; % length(find(YTra<0))/length(YTra);

%% Create the result struct with predict function
Model.RND = NRND;
Model.predictFcn = @(x)Prediction_Cls_RND(Model,x);
