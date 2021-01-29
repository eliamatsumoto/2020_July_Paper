%% OK = util_MLP_OK(Observed,Predicted)
%
function OK = util_MLP_OK(Observed,Predicted)

%% Confusion matrix
cm   = confusionmat(Observed,Predicted);

%% Threshold
Threshold = 0.2;
sum_col   = sum(cm);
nobs      = sum(cm(:));
prop_col  = sum_col/nobs;
PROP_OK   = all(prop_col > Threshold);

%% Accuracy
acc = trace(cm)/sum(cm(:));

%% OK
OK = acc > 0.5 && PROP_OK;
