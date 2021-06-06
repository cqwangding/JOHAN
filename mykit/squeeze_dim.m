function X = squeeze_dim(X, dim)
%SQUEEZE_DIM Summary of this function goes here
%   Detailed explanation goes here
s = size(X);
if sum(s(dim)~=1) >0
    return;
end
d = setdiff(1:length(s), dim);
X = squeeze(X);
X = reshape(X, s(d));
end
