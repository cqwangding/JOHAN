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

para=[0.064624   0.25169];
opts.rho=para(1);
opts.epsilon = para(2);

X = impute_mean(X);
[m, d, T, N] = size(X);
W_init = 1/m*ones((T-1)*m,1);
[W P] = back_tracking(X(:,:,2:end,:), Y(:,2:end,:), time, W_init, opts, @PA, @predict_lr, @predict_lr);

predict(11).name = "PA";
predict(11).int = P;
predict(11).int_W = W;

save('../data/predict.mat','predict');
