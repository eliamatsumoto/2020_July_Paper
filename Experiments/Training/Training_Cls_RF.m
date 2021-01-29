%%% Classification NKK
%
% function Model = Training_Cls_KNN(XTra,YTra,OptFlag)
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
function Model = Training_Cls_RF(XTra,YTra,OptFlag)

%% Initalization
CN    = [-1; 1];
NKF   = 10;
MTH   = 'LogitBoost';
RF    = 19;
ttree = templateTree();

%% Hyperparam
if OptFlag
    PVal = [17 19 21];
    nP   = length(PVal);
    OK   = false;
    %% HP sweeping
    while ~OK
        loss = zeros(NKF,nP);
        for i = 1:nP
            model = fitcensemble(XTra,YTra, ...
                'Learners',ttree, ...
                'Method',MTH, ...
                'KFold', NKF, ...
                'NumLearningCycles',PVal(i));
            loss(:,i) = kfoldLoss(model,'mode','individual');
        end
        id  = util_min_loss(loss,'RF');
        RF  = PVal(id);
        %% Final model training
        model = fitcensemble(XTra,YTra, ...
            'Learners',ttree, ...
            'Method',MTH, ...
            'ClassNames', CN, ...
            'NumLearningCycles',RF);
        YTrah = predict(model,XTra);
        OK    = util_training_OK(YTra,YTrah);
        if ~OK
            disp('retraining');
        end
    end
else
    %% Final model training
    model = fitcensemble(XTra,YTra, ...
        'Learners',ttree, ...
        'Method',MTH, ...
        'ClassNames', CN, ...
        'NumLearningCycles',RF);
end

disp(['RF: ' num2str(RF)]);

%% Create the result struct with predict function
Model.RF = model;
Model.predictFcn = @(x)Prediction_Cls_RF(Model,x);
