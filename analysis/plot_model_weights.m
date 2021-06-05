addpath('../mykit');
clear;

load("../data/model.mat");
load("../data/forecasts_tra_int_cell.mat");
load("../data/forecasts_y_coast.mat");
load("../data/predict.mat");
load("../data/predict_flag.mat");

models=[2 3 8 9 10 11 15 17 22 23 25 26 47 50 52 59 67 71 72 76 77 80 106 107 108 109 111];
opts.model_id=[];
for i=1:length(models)
    opts.model_id{i}=model(models(i)).id;
end
plot_weights(predict(21).tra_W(length(models)*8+1:end,:), opts)

models=[2 3 9 10 11 15 17 22 47 50 52 59 71 72 76 77 106 107 108 109 111];
opts.model_id=[];
for i=1:length(models)
    opts.model_id{i}=model(models(i)).id;
end
plot_weights(predict(21).int_W(length(models)*8+1:end,:), opts);
