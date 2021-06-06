clear;

%% load data
load("../data/model.mat");
load("../data/forecasts_int.mat");
load("../data/predict.mat");
load("../data/predict_flag.mat");

opts.error_type = 2; % 1 distance, 2 L1, 3 L2
opts.unit_change = 1;
opts.use_predict = 0;
opts.geo = 0;
opts.cat_thresholds = [64 83 96 113 137];

para = [0.72085    0.5094    951.17    971.38    21.698   31.248];
opts.rho=para(1);
opts.gamma=para(2);
opts.omega=para(3);
opts.mu=para(4);
opts.nu=para(5);
opts.eta=para(6);

[m, d, T, N] = size(X);
W_init = [1/m*ones(T*m,1)];
[W P] = back_tracking(X(:,:,2:end,:), Y(:,2:end,:), time, W_init, opts, @OMuLeT, @predict_renorm, @predict_renorm);

predict(13).name = "OMuLeT";
predict(13).int = P;
predict(13).int_W = W;

save('../data/predict.mat','predict');
