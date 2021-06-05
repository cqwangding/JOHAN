addpath('../mykit');

clear;

%% load data
load("best_track.mat");

load("coast");
coastal_res = 10;
[Z, R] = vec2mtx(lat, long, coastal_res, [0, 90], [-270, 90], 'filled');
opts.Z = Z;
opts.R = R;
opts.coast_lat = lat;
opts.coast_lon = long;

unit_change = 1.852;
int=[];
dis=[];

for h=1:numel(best_track)
    latlon = best_track{h}(:,2:3);
    int_t = best_track{h}(:,4);
    dis_t = get_coast_data(latlon',opts);
    dis_t = dis_t(4,:).*(1-2*dis_t(3,:))/unit_change;
    int=[int;int_t];
    dis=[dis;dis_t'];
end

stat=zeros(22,30);
for i=1:length(dis)
    if dis(i)>=-400 && dis(i)<1800 && int(i)>=0 && int(i)<150
        x=floor(dis(i)/100)+5;
        y=floor(int(i)/5)+1;
        stat(x,y)=stat(x,y)+1;
    end
end
imagesc(flipud(stat))
colorbar
set(gca, 'XTick', [2:2:30], 'XTickLabel', [2:2:30]*5) % 10 ticks 
set(gca, 'YTick', [1:2:21], 'YTickLabel', [18:-2:-2]*100) % 20 ticks

xlabel('Hurricane intensity (kt)')
ylabel('Distance to land (n mi)');
