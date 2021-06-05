addpath('mykit');
clear;

load("data/model.mat");
load("data/forecasts_tra_int_cell.mat");
load("data/forecasts_y_coast.mat")
load("data/predict.mat");
load("data/predict_flag.mat");

opts{1}.error_type = 1; % 1 distance, 2 L1, 3 L2, 4 L1 cat
opts{1}.unit_change = 1.852;
opts{1}.use_predict = 1;
opts{1}.geo = 1;

opts{2}.error_type = 2; % 1 distance, 2 L1, 3 L2, 4 L1 cat
opts{2}.unit_change = 1;
opts{2}.use_predict = 0;
opts{2}.geo = 0;
opts{2}.cat_thresholds = [64 83 96 113 137];

opts{1}.range = [time(splits(3,1),1), time(splits(3,2),2)];
opts{2}.range = [time(splits(3,1),1), time(splits(3,2),2)];

Y{1} = Y{1}(:,2:end,:);
Y{2} = Y{2}(:,2:end,:);
predict_flag{1} = predict_flag{1}(2:end,:);
predict_flag{2} = predict_flag{2}(2:end,:);

fprintf("***************** Experiment result tables *****************\n");
get_error_table(predict, Y, predict_flag, opts);

fprintf("***************** Experiment result tables (within 200 n mi) *****************\n");
distance_flag = squeeze(Y_coast(4,2:end,:))<=200*1.852;
predict_flag{1} = predict_flag{1} & distance_flag;
predict_flag{2} = predict_flag{2} & distance_flag;
get_error_table(predict, Y, predict_flag, opts);

fprintf("***************** Experiment result tables (within 200 n mi and >64 kt) *****************\n");
intensity_flag = squeeze(Y{2}(1,:,:))>=64;
predict_flag{1} = predict_flag{1} & intensity_flag;
predict_flag{2} = predict_flag{2} & intensity_flag;
get_error_table(predict, Y, predict_flag, opts);
