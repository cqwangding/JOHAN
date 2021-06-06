function W = remove_weight_neg(W)
%REMOVE_WEIGHT_ZERO Summary of this function goes here
%   Detailed explanation goes here
sum_W = sum(W,1);
W(W<0) = 0;
sum_W2 = sum(W,1);
idx = (sum_W2~=0);
W(:,idx) = W(:,idx)./sum_W2(idx).*sum_W(idx);
end
