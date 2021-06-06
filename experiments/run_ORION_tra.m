clear;

%% load data
load("../data/model.mat");
load("../data/forecasts_tra.mat");
load("../data/predict.mat");
load("../data/predict_flag.mat");

load("coast");
coastal_res = 10;
[Z, R] = vec2mtx(lat, long, coastal_res, [0, 90], [-270, 90], 'filled');
opts.Z = Z;
opts.R = R;
opts.coast_lat = lat;
opts.coast_lon = long;

opts.error_type = 1; % 1 distance, 2 L1, 3 L2
opts.unit_change = 1.852;
opts.use_predict = 0;
opts.geo = 1;

para =[0.94813    395.98    765.76    8.1655    8.32];
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
predict(12).tra = P;
predict(12).tra_W = W;
predict(12).coast = get_coast_data(P, opts);

save('../data/predict.mat','predict');

