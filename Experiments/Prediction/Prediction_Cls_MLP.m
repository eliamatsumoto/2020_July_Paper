%% MLP prediction
%
% function Class = Prediction_Cls_MLP(MODEL,X)
%
function Class = Prediction_Cls_MLP(MODEL,X)
%% Initialization
MLP     = MODEL.MLP;
NNet    = length(MLP);
NObs    = size(X,1);
inputs  = X';
outputs = zeros(2,NObs);

%% Outputs
for i = 1:NNet
    net     = MLP{i};
    outputs = outputs + net(inputs);
end

%% Class
Class = util_vec_2_sign(outputs);
