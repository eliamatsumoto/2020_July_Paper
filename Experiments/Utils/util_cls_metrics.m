%% Classifier metrics: Accuracy, Precision, Sensitivity (Recall), Specificity, EARN  and CM
%
function [Metrics,CM] = util_cls_metrics(Observed,Predicted,Ret)

%% Confusion matrix
CM  = confusionmat(Observed,Predicted);

%% Metrics
if numel(CM) > 1
    
    %% Accuracy
    Accuracy = trace(CM)/sum(CM(:));
    
    %% Precision (Positive Predictive Value)
    den = CM(1,2) + CM(2,2); % # Total positive predictions
    num = CM(2,2);           % # Correct positive predictions
    if den
        Precision = num / den;
    else
        Precision = 0;
    end
    
    %% Sensitivity (Recall)
    den = CM(2,1) + CM(2,2); % # Total positive observations
    num = CM(2,2);           % # Correct positive predictions
    if den
        Sensitivity = num / den;
    else
        Sensitivity = 0;
    end
    
    %% Specificity: Negative Predictive Value)
    den = CM(1,1) + CM(2,1); % # Total negative predictions
    num = CM(1,1);           % # Correct negative predictions
    if den
        Specificity = num / den;
    else
        Specificity = 0;
    end
    
else
    %% One class perfect match
    Accuracy    = 1;
    Precision   = 1;
    Sensitivity = 1;
    Specificity = 1;
end

%% Earnings
Earnings = util_sign_2_earn(Predicted,Ret);

%% Metrics
Metrics = [Accuracy Precision Sensitivity Specificity Earnings];
