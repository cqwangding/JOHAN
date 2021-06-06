function predict = predict_renorm(X, W)
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
            elseif  sum(w(idx)) == 0
                predict(:,tau,t) = mean(x(idx,:),1)';
            else
                x(~idx,:) = 0;
                predict(:,tau,t) = x'*w*sum(w)/sum(w(idx));
            end
        end
    end
end
