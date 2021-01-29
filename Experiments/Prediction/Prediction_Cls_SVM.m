%% SVM
%
% function Class = Prediction_Cls_SVM(MODEL,X)
%
function Class = Prediction_Cls_SVM(MODEL,X)

%% Prediction
SVM   = MODEL.SVM;
Class = predict(SVM,X) ;

