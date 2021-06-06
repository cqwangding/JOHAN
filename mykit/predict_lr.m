function predict = predict_lr(X, W)
%LR_RENORM Summary of this function goes here
%   Detailed explanation goes here
    [m, d, T, N] = size(X);
    W = W(1:m*T,:);
    W = reshape(W, m, T, N);
    predict = nan(d, T, N);
    for t = 1:N
        for tau = 1:T
            x = X(:,:,tau,t);
            w = W(:,tau,t);
            idx = get_missing_flag(x, 2, 1);
            if sum(idx) == 0
                continue;
            else
                predict(:,tau,t) = x'*w;
            end
        end
    end
end
