function x = impute_forward(x)
%IMPUTE_MEAN Summary of this function goes here
%   Detailed explanation goes here
    for i=2:length(x)
        if isnan(x(i))
            x(i)=x(i-1);
        end
    end
end

