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

para = [0.97125   0.97531    938.39    20.923     492.5    140.56    44.061];
opts.rho=para(1);
opts.gamma=para(2);
opts.omega=para(3);
opts.mu=para(4);
opts.nu=para(5);
opts.eta=para(6);
opts.epsilon=para(7);
opts.r=1;

xi = [0.5 0.6 0.7 0.8 0.9];

for i = 1:length(xi)
    opts_t{i} = opts;
    opts_t{i}.xi = xi(i);
end

parfor i = 1:length(xi)
    [m, d, T, N] = size(X);
    W_init = [1/m*ones(T*m,1)];
    [W P] = back_tracking(X(:,:,2:end,:), Y(:,2:end,:), time, W_init, opts_t{i}, @JOHAN_int, @predict_renorm, @predict_renorm);

    if i==1
        predict(30+i).name = sprintf("JOHAN-NQ",xi(i));
    else
        predict(30+i).name = sprintf("JOHAN-Q(\\xi=%.1f)",xi(i));
    end
    predict(30+i).int = P;
    predict(30+i).int_W = W;
end

save('../data/predict.mat','predict');
