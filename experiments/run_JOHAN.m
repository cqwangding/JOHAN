clear;

%% load data
load("../data/model.mat");
load("../data/forecasts_tra_int_cell.mat");
load("../data/forecasts_y_coast.mat");
load("../data/predict.mat");
load("../data/predict_flag.mat");

load("coast");
coastal_res = 10;
[Z, R] = vec2mtx(lat, long, coastal_res, [0, 90], [-270, 90], 'filled');
opts{1}.Z = Z;
opts{1}.R = R;
opts{1}.coast_lat = lat;
opts{1}.coast_lon = long;

opts{1}.Y_info = Y_coast;

X{1}=X{1}(:,:,2:end,:);
Y{1}=Y{1}(:,2:end,:);

X{2}=X{2}(:,:,2:end,:);
Y{2}=Y{2}(:,2:end,:);

opts{1}.error_type = 1; % 1 distance, 2 L1, 3 L2
opts{1}.unit_change = 1.852;
opts{1}.use_predict = 1;
opts{1}.geo = 1;

para=[0.79983    0.83239    0.1053  151.2719    0.2699    0.1235];
opts{1}.rho=para(1);
opts{1}.gamma=para(2);
opts{1}.omega=para(3);
opts{1}.mu=para(4);
opts{1}.nu=para(5);
opts{1}.eta=para(6);

opts{1}.th = 34;
opts{1}.c = 13.6536; % (34-64)/log(1/0.9-1)

opts{2}.error_type = 2; % 1 distance, 2 L1, 3 L2
opts{2}.unit_change = 1;
opts{2}.use_predict = 0;
opts{2}.geo = 0;
opts{2}.cat_thresholds = [64 83 96 113 137];
opts{2}.cat = 1;

para = [0.97125   0.97531    938.39    20.923     492.5    140.56    44.061];
opts{2}.rho=para(1);
opts{2}.gamma=para(2);
opts{2}.omega=para(3);
opts{2}.mu=para(4);
opts{2}.nu=para(5);
opts{2}.eta=para(6);
opts{2}.epsilon=para(7);
opts{2}.r=1;

opts{2}.th = 300*1.852;
opts{2}.c = 84.2882; % (200*1.852-300*1.852)/log(1/0.9-1)

[m, d, T, N] = size(X{1});
W_init{1} = [1/m*ones((T+1)*m,1)];
[m, d, T, N] = size(X{2});
W_init{2} = [1/m*ones((T+1)*m,1)];
[W P] = back_tracking_joint(X, Y, time, W_init, opts, {@JOHAN_tra, @JOHAN_int}, {@predict_renorm, @predict_renorm}, {@predict_renorm, @predict_renorm});

predict(21).name = "JOHAN";
predict(21).tra = P{1};
predict(21).tra_W = W{1};
predict(21).coast = get_coast_data(P{1}, opts{1});
predict(21).int = P{2};
predict(21).int_W = W{2};

save('../data/predict.mat','predict');