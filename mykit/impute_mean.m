function X = impute_mean(X)
%IMPUTE_MEAN Summary of this function goes here
%   Detailed explanation goes here
    s = size(X);
    X = reshape(X, s(1), []);
    N = size(X,2);
    for n = 1:N
        x = X(:,n);
        idx = ~isnan(x);
        if sum(idx) == 0
            continue;
        end
        x(~idx) = mean(x(idx));
        X(:,n) = x;
    end
    X = reshape(X,s);
end
