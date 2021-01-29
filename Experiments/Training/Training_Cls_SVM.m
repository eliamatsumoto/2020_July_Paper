%%% Classification SVM
%
% function Model = Training_Cls_SVM(XTra,YTra,OptFlag)
%
% Autor: Elia Matsumoto
%
% Data: 2020
%
function Model = Training_Cls_SVM(XTra,YTra,OptFlag)

%% Prop_CV
Prop_CV = 0.2;
NKF     = 10;
CN      = [-1; 1];
NTra    = length(YTra);
KF      = 'gaussian';
BC      = 2;

%% Hyperparam
if OptFlag
    PVal =  [2 50 100 150 200];
    nP   = length(PVal);
    OK   = false;
    %% HP sweeping
    while ~OK
        loss = zeros(NKF,nP);
        % KFold
        for i = 1:NKF
            % CV partition
            cv    = cvpartition(NTra,'holdout',Prop_CV);
            xtra  = XTra(cv.training,:);
            ytra  = YTra(cv.training);
            xtes  = XTra(cv.test,:);
            ytes  = YTra(cv.test);
            % For NP
            for j = 1:nP
                model  = fitcsvm(xtra,ytra, ...
                    'KernelFunction', KF, ...
                    'Standardize', true, ...
                    'ClassNames', CN, ...
                    'BoxConstraint', PVal(j));
                ytesh   = predict(model,xtes);
                cmtes   = confusionmat(ytes,ytesh);
                acc     = trace(cmtes) / sum(cmtes(:));
                loss(i,j) = 1-acc;
            end
        end
        id  = util_min_loss(loss,'RF');
        BC  = PVal(id);
        %% Final model training
        model  = fitcsvm(XTra,YTra, ...
            'KernelFunction', KF, ...
            'Standardize', true, ...
            'ClassNames', CN, ...
            'BoxConstraint', BC);
        YTrah = predict(model,XTra);
        OK    = util_training_OK(YTra,YTrah);
        if ~OK
            disp('retraining');
        end
    end
else
    %% Final model training
    model  = fitcsvm(XTra,YTra, ...
        'KernelFunction', KF, ...
        'Standardize', true, ...
        'ClassNames', CN, ...
        'BoxConstraint', BC);
end

disp(['BC: ' num2str(BC)]);

%% Create the result struct with predict function
Model.SVM = model;
Model.predictFcn = @(x)Prediction_Cls_SVM(Model,x);
