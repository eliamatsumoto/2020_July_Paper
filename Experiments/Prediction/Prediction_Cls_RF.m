%% RF
%
% function Class = Prediction_Cls_RF(MODEL,X)
%
function Class = Prediction_Cls_RF(MODEL,X)

%% Prediction
RF = MODEL.RF;
Class = predict(RF,X) ;



