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

para=[ 0.83636    160.16    166.23    0.042208    0.7596  ];
opts.rho=para(1);
opts.mu=para(2);
opts.lambda=para(3);
opts.beta=para(4);
opts.epsilon=para(5);

X = impute_mean(X);
[m, d, T, N] = size(X);
W_init = 1/m*ones(T*m,1);
[W P] = back_tracking(X(:,:,2:end,:), Y(:,2:end,:), time, W_init, opts, @ORION_bt, @predict_lr, @predict_lr);

predict(12).name = "ORION";
predict(12).int = P;
predict(12).int_W = W;

save('../data/predict.mat','predict');
