function [coast_dis, coast_lat, coast_lon, is_land] = get_nearest_coast(lat, lon, opts)
%GET_NEAREST_COAST Summary of this function goes here
%   Detailed explanation goes here

val = ltln2val(opts.Z, opts.R, lat, lon);
is_land = val ~= 2;

num = numel(lat);
coast_dis = zeros(num,1);
coast_lat = zeros(num,1);
coast_lon = zeros(num,1);

lat_mean = mean(lat);
P = [opts.coast_lat, opts.coast_lon*cosd(lat_mean)];
PQ = [lat, lon*cosd(lat_mean)];
k = dsearchn(P,PQ);

for i=1:numel(k)
    if isnan(lat(i))
        continue;
    end
    idx = k(i);
    coast_lat(i) = opts.coast_lat(idx);
    coast_lon(i) = opts.coast_lon(idx);
    if idx<length(opts.coast_lat) && ~isnan(opts.coast_lat(idx+1))
        vec = P(idx+1,:) - P(idx,:);
        vec_norm = norm(vec);
        vec = vec/vec_norm;
        proj = (PQ(i,:) - P(idx,:))*vec'/vec_norm;
        if proj>=0 && proj<=1
            coast_lat(i) = (1-proj)*opts.coast_lat(idx) + proj*opts.coast_lat(idx+1);
            coast_lon(i) = (1-proj)*opts.coast_lon(idx) + proj*opts.coast_lon(idx+1);
        end
    end
    if idx>1 && ~isnan(opts.coast_lat(idx-1))
        vec = P(idx-1,:) - P(idx,:);
        vec_norm = norm(vec);
        vec = vec/vec_norm;
        proj = (PQ(i,:) - P(idx,:))*vec'/vec_norm;
        if proj>=0 && proj<=1
            coast_lat(i) = (1-proj)*opts.coast_lat(idx) + proj*opts.coast_lat(idx-1);
            coast_lon(i) = (1-proj)*opts.coast_lon(idx) + proj*opts.coast_lon(idx-1);
        end
    end
    coast_dis(i) = get_distance([lat(i); lon(i)], [coast_lat(i); coast_lon(i)]);
end

end
