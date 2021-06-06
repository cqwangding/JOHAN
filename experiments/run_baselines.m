clear;

%% load data
load("../data/forecasts_tra_int_cell.mat");

load("coast");
coastal_res = 10;
[Z, R] = vec2mtx(lat, long, coastal_res, [0, 90], [-270, 90], 'filled');
opts.Z = Z;
opts.R = R;
opts.coast_lat = lat;
opts.coast_lon = long;

%% get predict flags
for i = 1:numel(X)
    predict_flag{i} = get_predict_flag(X{i}, Y{i}, NHC{i});
end
save("../data/predict_flag.mat", "predict_flag");

%% get baselines
[m,d,T,N] = size(X{1});
predict(1).name = "Ens Mean";
predict(1).tra = nan(d,T-1,N);
predict(2).name = "Persistance";
predict(2).tra = nan(d,T-1,N);
predict(3).name = "NHC";
predict(3).tra = nan(d,T-1,N);

X_flag = get_missing_flag(X{1}, 2, 1);
Y_flag = get_missing_flag(Y{1}, 1, 1);
h=1;
for t=1:N
    for tau=2:T
        if predict_flag{1}(tau,t)
            x=X{1}(:,:,tau,t);
            nhc=NHC{1}(:,tau,t);
            idx=X_flag(:,tau,t);
            predict(1).tra(:,tau-1,t)=mean(x(idx,:),1)';
            predict(3).tra(:,tau-1,t)=nhc;
            if t>time(h,2)
                h=h+1;
            end
            if t>time(h,1) && Y_flag(1,t-1)
                speed = Y{1}(:,1,t) - Y{1}(:,1,t-1);
                pers = Y{1}(:,1,t) + speed*(tau-1);
                predict(2).tra(:,tau-1,t)=pers;   
            end
        end
    end
end

for n=1:3
    predict(n).coast = get_coast_data(predict(n).tra, opts);
end

[m,d,T,N] = size(X{2});
predict(1).name = "Ens Mean";
predict(1).int = nan(d,T-1,N);
predict(2).name = "Persistance";
predict(2).int = nan(d,T-1,N);
predict(3).name = "NHC";
predict(3).int = nan(d,T-1,N);

X_flag = get_missing_flag(X{2}, 2, 1);
Y_flag = get_missing_flag(Y{2}, 1, 1);
h=1;
for t=1:N
    for tau=2:T
        if predict_flag{2}(tau,t)
            x=X{2}(:,:,tau,t);
            nhc=NHC{2}(:,tau,t);
            idx=X_flag(:,tau,t);
            predict(1).int(:,tau-1,t)=mean(x(idx,:),1)';
            predict(3).int(:,tau-1,t)=nhc;
            predict(2).int(:,tau-1,t)=Y{2}(:,1,t);   
        end
    end
end

save('../data/predict.mat','predict');
