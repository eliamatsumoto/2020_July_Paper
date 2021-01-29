%%% Classification MLP
%
% function Model = Training_Cls_MLP(XTra,YTra,OptFlag)
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
function Model = Training_Cls_MLP(XTra,YTra,OptFlag)

%% Initialization
NNet    = 1;

%% Inputs & Targets
inputs  = XTra';
targets = util_sign_2_vec(YTra);

%% Optimization setting
if OptFlag
    HVal = [10 20 30];
else
    HVal = 20;
end

%% Model training
nH     = length(HVal);
models = cell(NNet+1,nH);
loss   = zeros(NNet+1,nH);
%% K-Folding
for i = 1:(NNet+1)
    %% HP sweeping
    for j = 1:nH
        [net,loss(i,j)] = train_MLP(HVal(j),inputs,targets);
        models{i,j}     = net;
    end
end

%% "Best" nH
id    = util_min_loss(loss,'MLP');
MODEL = models(:,id);

disp(['NH: ' num2str(HVal(id))]);

%% Create the result struct with predict function
Model.MLP = MODEL;
Model.predictFcn = @(x)Prediction_Cls_MLP(Model,x);
