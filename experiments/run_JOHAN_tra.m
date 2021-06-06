clear;

%% load data
load("../data/model.mat");
load("../data/forecasts_tra.mat");
load("../data/forecasts_y_coast.mat");
load("../data/predict.mat");
load("../data/predict_flag.mat");

opts.error_type = 1; % 1 distance, 2 L1, 3 L2
opts.unit_change = 1.852;
opts.use_predict = 1;
opts.geo = 1;

para=[0.79983    0.83239    0.1053  151.2719    0.2699    0.1235];
opts.rho=para(1);
opts.gamma=para(2);
opts.omega=para(3);
opts.mu=para(4);
opts.nu=para(5);
opts.eta=para(6);

opts.Y_info = Y_coast;

load("coast");
coastal_res = 10;
[Z, R] = vec2mtx(lat, long, coastal_res, [0, 90], [-270, 90], 'filled');
opts.Z = Z;
opts.R = R;
opts.coast_lat = lat;
opts.coast_lon = long;

xi = [0.5 0.6 0.7 0.8 0.9];

for i = 1:length(xi)
    opts_t{i} = opts;
    opts_t{i}.xi = xi(i);
end

parfor i = 1:length(xi)
    [m, d, T, N] = size(X);
    W_init = [1/m*ones(T*m,1)];
    [W P] = back_tracking(X(:,:,2:end,:), Y(:,2:end,:), time, W_init, opts_t{i}, @JOHAN_tra, @predict_renorm, @predict_renorm);
    
    if i==1
        predict(30+i).name = sprintf("JOHAN-NQ",xi(i));
    else
        predict(30+i).name = sprintf("JOHAN-Q(\\xi=%.1f)",xi(i));
    end
    predict(30+i).tra = P;
    predict(30+i).tra_W = W;
    predict(30+i).coast = get_coast_data(P, opts);
end

save('../data/predict.mat','predict');