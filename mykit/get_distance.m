function [dis, dis_lat, dis_lon] = get_distance(p1, p2)
%GET_DISTANCE Summary of this function goes here
%   Detailed explanation goes here
earth_rad = 6378.137;
radLat1 = deg2rad(p1(1,:));
radLat2 = deg2rad(p2(1,:));
a = radLat1 - radLat2;
b = deg2rad(p1(2,:)) - deg2rad(p2(2,:));

dis = 2 * asin(sqrt(power(sin(a/2),2) + cos(radLat1).*cos(radLat2).*power(sin(b/2),2)));
dis = dis * earth_rad;

dis_lat = earth_rad*(deg2rad(p1(1,:))-deg2rad(p2(1,:)));
lat_mid = deg2rad(deg2rad(p1(1,:))+deg2rad(p2(1,:)))/2;
dis_lon = earth_rad*(deg2rad(p1(2,:))-deg2rad(p2(2,:))).*cos(lat_mid);

end
