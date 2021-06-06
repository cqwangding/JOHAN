function category = get_wind_category(wind_speed, range)
    s = size(wind_speed);
    idx_missing = isnan(wind_speed);
    category=zeros(s);
    if nargin < 2
        range=[64 83 96 113 137]; % kt
    end
    for i=1:length(range)
        idx=wind_speed>=range(i);
        category(idx)=category(idx)+1;
    end
    category(idx_missing) = NaN;
end
