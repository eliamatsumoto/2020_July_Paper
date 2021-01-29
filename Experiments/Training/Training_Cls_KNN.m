%%% Classification NKK
%
% function Model = Training_Cls_KNN(XTra,YTra,OptFlag)
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
function Model = Training_Cls_KNN(XTra,YTra,OptFlag)

%% Initalization
CN    = [-1; 1];
NKF   = 10;
KNN   = 7;

%% Hyperparam
if OptFlag
    PVal = [7 9 11];
    nP   = length(PVal);
    OK   = false;
    %% HP sweeping
    while ~OK
        loss = zeros(NKF,nP);
        for i = 1:nP
            model = fitcknn(XTra,YTra, ...
                'ClassNames', CN, ...
                'Standardize',true, ...
                'KFold', NKF, ...
                'NumNeighbors',PVal(i));
            loss(:,i) = kfoldLoss(model,'mode','individual');
        end
        id  = util_min_loss(loss,'KNN');
        KNN = PVal(id);
        %% Final model training
        model = fitcknn(XTra,YTra, ...
            'ClassNames', CN, ...
            'Standardize',true, ...
            'NumNeighbors',KNN);
        YTrah = predict(model,XTra);
        OK    = util_training_OK(YTra,YTrah);
        if ~OK
            disp('retraining');
        end
    end
else
    %% Final model training
    model = fitcknn(XTra,YTra, ...
        'ClassNames', CN, ...
        'Standardize',1, ...
        'NumNeighbors',KNN);
end

disp(['KNN: ' num2str(KNN)]);

%% Create the result struct with predict function
Model.KNN = model;
Model.predictFcn = @(x)Prediction_Cls_KNN(Model,x);
