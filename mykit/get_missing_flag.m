function X_flag = get_missing_flag(X, dim, type, missing_value)
%GET_MISSING_FLAG Summary of this function goes here
%   Detailed explanation goes here
    dim_X = ndims(X);
    if dim <= dim_X
        if nargin < 4
            X_flag = sum(isnan(X), dim);
        else
            X_flag = sum(X == missing_value, dim);
        end
        if ndims(X_flag) == dim_X && dim_X > 2
            X_flag = squeeze_dim(X_flag, dim);
        end
    else
        if nargin < 4
            X_flag = isnan(X);
        else
            X_flag = X == missing_value;
        end
    end
    if type == 1
        X_flag = ~(X_flag>0);
    elseif type == 2
        X_flag = ~(X_flag == size(X,dim));
    else
        fprintf("get_missing_flag: Type not defined!\n")
    end
end
