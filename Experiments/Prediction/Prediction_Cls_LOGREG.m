%% Logistic Regression
%
% function Class = Prediction_Cls_LOGREG(LOGREG,X)
%
function Class = Prediction_Cls_LOGREG(MODEL,X)

%% Model
model = MODEL.LOGREG;
th    = MODEL.Threshold;

%% Prediction
val = predict(model,X) ;

%% Convert to class
nObs  = size(X,1);
Class = ones(nObs,1);
idx = val < th;
Class(idx) = -1;


