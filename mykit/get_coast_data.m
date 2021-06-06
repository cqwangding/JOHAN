function P_coast = get_coast_data(P, opts)
%GET_COAST_INFO Summary of this function goes here

s = size(P);
N = prod(s(2:end));
P_coast = nan(4,N);
t1=clock;
P = reshape(P,[s(1),N]);
idx = ~isnan(P(1,:));
if sum(idx)~=0
    [coast_dis, coast_lat, coast_lon, is_land] = get_nearest_coast(P(1,idx)', P(2,idx)', opts);
    P_coast(1,idx) = coast_lat;
    P_coast(2,idx) = coast_lon;
    P_coast(3,idx) = is_land;
    P_coast(4,idx) = coast_dis;
end

P_coast = reshape(P_coast,[4,s(2:end)]);

end
