addpath('../mykit');

clear;

%% load data
load("../data/model.mat");
load("../data/forecasts_int.mat");
load("../data/forecasts_y_coast.mat");
load("../data/predict.mat");
load("../data/predict_flag.mat");

unit_change = 1.852;
result=[];
count=0;
tau=8;

for h=1:splits(2,2)
    for t=time(h,1):time(h,2)
        if Y_coast(3,1,t)==0 && Y_coast(3,tau+1,t)==1
            count = count+1;
            result(count,:) = squeeze(Y_coast(4,:,t).*(1-2*Y_coast(3,:,t)));
            break;
        end
    end
end

result = result(:,8:-1:1);
result_mean = mean(result)./unit_change
result_std = std(result)./unit_change

x = 6:6:48;
y = result_mean;
err = result_std;
errorbar(x,y,err,'o-')

xlabel('Time before landfall (hours)');
ylabel('Distance to coastline (n mi)');
xticks(x)
tightfig;
