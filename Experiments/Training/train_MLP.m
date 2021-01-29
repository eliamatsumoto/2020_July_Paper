function [net,loss] = train_MLP(NH,inputs,targets)

%% Initialization
rng('shuffle'); % Random seed
MAX_FAIL = 100;
ytra = vec2ind(targets);
OK   = false;

%% Training
while ~OK
    net = patternnet(NH);
    net.trainParam.showWindow = 0;
    net.trainParam.max_fail   = MAX_FAIL;
    [net, tr] = train(net,inputs,targets,[],[],[],'useParallel','yes');
    outputs = net(inputs);
    ytrah   = vec2ind(outputs);
    cm = confusionmat(ytra,ytrah);
    sm = sum(cm);
    sp = cm(1,1)/sm(1);
    pr = cm(2,2)/sm(2);
    OK = (sp-0.5) > eps && (pr-0.5) > eps;    
end
%% Loss
loss =  tr.best_tperf;
