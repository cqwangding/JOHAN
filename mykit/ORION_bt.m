function W_all = ORION_bt(X, Y, W_all, opts)
% This function is used for online multi-task learning in PA way
    [m, d, T] = size(X);
    idx_X = get_missing_flag(X, 2, 1);
    idx_X2 = get_missing_flag(idx_X, 1, 2, false);
    idx_model = get_missing_flag(idx_X, 2, 2, false);
    idx_Y = get_missing_flag(Y, 1, 1);
    idx = idx_X2 & idx_Y;
    % if there is no data or ground truth, W,U will not change
    if sum(idx) == 0
        return;
    end
    S = zeros(T, T);
    for i = 1:T
        for j = 1:T
            if i==j+1 || i==j-1
                S(i,j) = 1;
            elseif i == j
                S(i,j) = -1;
            end
        end
    end
    S(1,1) = 0;
    S(T,T) = 0;
    W = zeros(m,T);
    U = zeros(m,1);
    W(:) = W_all(1:m*T);
    U(:) = W_all(m*T+1:end);
    V = (W-U)';
    for f=1:d
        X_f = squeeze(X(:,f,:))';
        Y_f = squeeze(Y(f,:))';
        L = idx';
        X_f(isnan(X_f))=0;
        Y_f(~idx)=NaN;
        [U, V]=ORION(U, V, L, X_f, Y_f, opts.mu, opts.lambda, opts.beta, opts.epsilon, S);
    end
    W = V' + U;
    W_all = [W(:); U(:)];
end
