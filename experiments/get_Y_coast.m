process = "Get projections on coastline";

%% load data
load("../data/forecasts_tra.mat");

load("coast");
coastal_res = 10;
[Z, R] = vec2mtx(lat, long, coastal_res, [0, 90], [-270, 90], 'filled');
opts.Z = Z;
opts.R = R;
opts.coast_lat = lat;
opts.coast_lon = long;

[m d T N] = size(X);
Y_coast = nan(4,T,N);
t1=clock;
for t=1:N
    if mod(t, 500)==0
        t2=clock;
        fprintf('%s / Runs:%d/%d / Timeleft:%s\n', process, t, N, get_timeleft(t,N,t1,t2));
    end
        Y_tau = Y(:,:,t);
        idx = ~isnan(Y_tau(1,:));
        if sum(idx)==0
            continue;
        end
        [coast_dis, coast_lat, coast_lon, is_land] = get_nearest_coast(Y_tau(1,idx)', Y_tau(2,idx)', opts);
        Y_coast(1,idx,t) = coast_lat;
        Y_coast(2,idx,t) = coast_lon;
        Y_coast(3,idx,t) = is_land;
        Y_coast(4,idx,t) = coast_dis;
end

save('../data/forecasts_y_coast.mat','Y_coast');
