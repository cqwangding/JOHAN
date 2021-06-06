function [error_mean, errors, count] = get_error_leadtime(predict, Y, predict_flag, opts)
%GET_ERRORS Summary of this function goes here
%   Detailed explanation goes here

[d, T, N] = size(Y);
error_mean = 0;
errors = zeros(1,T);
count = zeros(1,T);
flag = get_missing_flag(predict, 1, 1);

if isempty(predict)
    return;
end

for t=opts.range(1):opts.range(2)
    for tau=1:T
        if predict_flag(tau,t) && flag(tau,t)
            p=predict(:,tau,t);
            y=Y(:,tau,t);
            if opts.error_type == 1
                errors(tau) = errors(tau) + get_distance(p, y);
            elseif opts.error_type == 2
                errors(tau) = errors(tau) + sum(abs(p - y));
            elseif opts.error_type == 3
                errors(tau) = errors(tau) + sum((p - y).^2);
            elseif opts.error_type == 4
                errors(tau) = errors(tau) + sum(abs(get_wind_category(p) - get_wind_category(y)));
            elseif opts.error_type == 5
                [~, dis_para] = get_distance2(p, y, opts.Y_info(1:2,tau,t));
                if isnan(dis_para)
                    continue;
                end
                errors(tau) = errors(tau) + dis_para;
            elseif opts.error_type == 6
                [~, ~, ~, dis_para] = get_distance2(p, y, opts.Y_info(1:2,tau,t));
                if isnan(dis_para)
                    continue;
                end
                errors(tau) = errors(tau) + dis_para;
            end
            count(tau) = count(tau) + 1;
        end
    end
end

error_mean = sum(errors)/sum(count);
errors2 = errors./count;
errors2(errors == 0) = 0;
error_mean = error_mean/opts.unit_change;
errors = errors2/opts.unit_change;

end
