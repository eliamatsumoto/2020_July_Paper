%%% Classification Logistic Regression
%
% function Model = Training_Cls_LOGREG(XTra,YTra,OptFlag)
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
function Model = Training_Cls_LOGREG(XTra,YTra,OptFlag)

%% Hyperparameter
if OptFlag
    Prop = length(find(YTra==1))/length(YTra);
else
    Prop = 0.5;
end

%% Convert [-1;1] => [0;1]
ybin = double(YTra == 1);

%% Link function
LinkFunction = 'logit';

%% Final model training
model = fitglm(XTra,ybin, ...
    'Link', LinkFunction, ...
    'Distribution', 'binomial');

%% Create the result struct with predict function
Model.LOGREG    = model;
Model.Threshold = Prop;
Model.predictFcn = @(x)Prediction_Cls_LOGREG(Model,x);
