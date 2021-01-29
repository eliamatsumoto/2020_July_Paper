%% K-NN
%
% function Class = Prediction_Cls_KNN(MODEL,X)
%
function Class = Prediction_Cls_KNN(MODEL,X)

%% Prediction
Class = predict(MODEL.KNN,X) ;


