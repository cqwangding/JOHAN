function get_error_table(predict, Y, predict_flag, opts)
%GET_ERROR_TABLE Summary of this function goes here
%   Detailed explanation goes here
    fprintf('-------------------- Distance and intensity error for different lead times --------------------\n');
    for i=1:numel(predict)
        if isempty(predict(i).name)
            continue;
        end
        fprintf('%s & ',predict(i).name);
        [error_mean, errors] = get_error_leadtime(predict(i).tra, Y{1}, predict_flag{1}, opts{1});
        errors = errors(2:2:8);
        for j=1:length(errors)
            fprintf('%.2f',errors(j));
            fprintf(' & ');
        end
        opts{2}.error_type = 2;
        [error_mean, errors] = get_error_leadtime(predict(i).int, Y{2}, predict_flag{2}, opts{2});
        errors = errors(2:2:8);
%         fprintf('%.3f & ',error_mean);
        for j=1:length(errors)
            fprintf('%.3f',errors(j));
            if j < length(errors)
                fprintf(' & ');
            end
        end
        fprintf('\\\\ \\hline\n');
    end
    fprintf('-------------------- F1-scores for different category --------------------\n');
    for i=1:numel(predict)
        if isempty(predict(i).name)
            continue;
        end
        [d,T,N] = size(Y{2});
        p = predict(i).int;
        y = Y{2};
        p = squeeze(get_wind_category(p)-1);
        y = squeeze(get_wind_category(y)-1);
        idx = predict_flag{2}(:);
        if isempty(p)
            continue;
        end
        p = p(idx);
        y = y(idx);
        C = confusionmat(y,p);
        for j =1:size(C,1)
            precision(j)=C(j,j)/sum(C(:,j));
            recall(j)=C(j,j)/sum(C(j,:));
            fmeasure(j)=2*precision(j)*recall(j)/(precision(j)+recall(j));
        end
        w = sum(C,2);
        w = w/sum(w);
        fprintf('%s & ',predict(i).name);
        fprintf('%.3f & ',mean(fmeasure));
        for j=1:length(fmeasure)
            fprintf('%.3f',fmeasure(j));
            if j < length(fmeasure)
                fprintf(' & ');
            end
        end
        fprintf('\\\\ \\hline\n');
    end
end
