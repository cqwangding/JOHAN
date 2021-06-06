function W_all = PA(X, Y, W_all, opts)
%Update U,V based on observations X,Y
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
    W = zeros(m,T);
    W(:) = W_all;
    for tau=1:T
        if ~idx_X2(tau) || ~idx_Y(tau)
            continue;
        end
        W_tau=W(:,tau);
        X_tau=X(:,:,tau);
        Y_tau=Y(:,tau);
        % geo data
        if opts.geo == 1
            X_tau(:,2)=X_tau(:,2)*cosd(Y_tau(1));
            Y_tau(2)=Y_tau(2)*cosd(Y_tau(1));
        end
        for f = 1:d
            err = Y_tau(f) - X_tau(:,f)'*W_tau;
            if abs(err) <= opts.epsilon
                continue;
            end
            W_tau = W_tau + sign(err)*(abs(err)-opts.epsilon)/sum(X_tau(:,f).^2)*X_tau(:,f);
        end
        W(:,tau) = W_tau;
    end
    W_all = W(:);
end

