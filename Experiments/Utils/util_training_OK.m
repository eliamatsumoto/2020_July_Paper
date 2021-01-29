%% OK = util_training_OK(Observed,Predicted)
%
function OK = util_training_OK(Observed,Predicted)

%% Confusion matrix
cm  = confusionmat(Observed,Predicted);

%% Accuracy
acc = trace(cm)/sum(cm(:));

%% OK
OK = acc > 0.5; % && cm(1,1) && cm(2,2);
