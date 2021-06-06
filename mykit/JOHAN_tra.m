function W_all = JOHAN_tra(X, Y, W_all, opts)
%Update U,V based on observations X,Y
    [m, d, T] = size(X);
    idx_X = get_missing_flag(X, 2, 1);
    idx_X2 = get_missing_flag(idx_X, 1, 2, false);
    idx_model = get_missing_flag(idx_X, 2, 2, false);
    idx_Y = get_missing_flag(Y, 1, 1);
    idx = idx_X2 & idx_Y;
    % if there is no data or ground truth, W,U will not change
    if sum(idx) == 0 || sum(idx_model) <= 1
        return;
    end
    W = zeros(m,T);
    U = zeros(m,1);
    W(:) = W_all(1:m*T);
    U(:) = W_all(m*T+1:end);
    E = zeros(2,T);

    X = X(idx_model,:,:);
    idx_X = idx_X(idx_model,:);
    m = sum(idx_model);
    U1 = U(idx_model);
    W1 = W(idx_model,:);
    sum_U1 = sum(U1);
    sum_U = sum(U);
    if sum_U1 == 0
        U1(:) = sum_U/size(U1,1);
    else
        U1 = U1/sum_U1*sum_U;
    end
    sum_W1 = sum(W1,1);
    sum_W = sum(W,1);
    for tau = 1:T
        if sum_W1(tau)==0
            W1(:,tau) = sum_W(tau)/size(W1,1);
        else
            W1(:,tau) = W1(:,tau)./sum_W1(tau).*sum_W(tau);
        end
    end
    V1 = W1-U1;
    
    delta = zeros(1,T);
    for tau=1:T
        if ~idx_X2(tau) || ~idx_Y(tau)
            continue;
        end
        X_flag=idx_X(:,tau);
        W1_tau=W1(:,tau);
        sum_W1_tau = sum(W1_tau);
        sum_W1_tau_flag = sum(W1_tau(X_flag));
        if sum_W1_tau_flag == 0
            continue;
        end
        delta(tau)=1;
        X_tau=X(:,:,tau);
        Y_tau=Y(:,tau);
        Y_info_tau = opts.Y_info(:,tau);
        % geo data
        if opts.geo == 1
            X_tau(:,2)=X_tau(:,2)*cosd(Y_tau(1));
            Y_tau(2)=Y_tau(2)*cosd(Y_tau(1));
            Y_info_tau(2)=Y_info_tau(2)*cosd(Y_tau(1));
        end
        if sum(~X_flag)>0
            X_tau(~X_flag,:) = repmat(W1_tau(X_flag)'*X_tau(X_flag,:)/sum_W1_tau_flag*sum_W1_tau,sum(~X_flag),1);
        end
        if Y_info_tau(3) == 1
            coast_n = Y_tau - Y_info_tau(1:2);
        else
            coast_n = Y_info_tau(1:2) - Y_tau;
        end
        if norm(coast_n)>0
            coast_n = coast_n / norm(coast_n);
            coast_v = [-coast_n(2); coast_n(1)];
            coast_matrix = [coast_n coast_v];
            X_tau = X_tau*coast_matrix;
            Y_tau = (Y_tau'*coast_matrix)';
        end
        X(:,:,tau) = X_tau;
        Y(:,tau) = Y_tau;
    end
    
    % H,f,A,b,Aeq,beq,lb,ub
    H=zeros(m*T+m+2*T);
    f=zeros(m*T+m+2*T,1);
    for tau = 1:T
        idx_W(tau,:) = (tau-1)*m+1:tau*m;
    end
    idx_U=m*T+1:m*T+m;
    for i = 1:T
        idx_E(i,:) = m*T+m+(i-1)*2+1:m*T+m+(i-1)*2+2;
    end
    % mu smooth
    H(idx_U,idx_U) = H(idx_U,idx_U) + opts.mu*eye(m);
    f(idx_U) = f(idx_U) - opts.mu*U1;
    for tau = 1:T
        if delta(tau)
            % loss term
            if length(opts.xi)==1
                H(idx_E(tau,1),idx_E(tau,1)) = (opts.gamma^(tau-1)-opts.gamma^tau)/(1-opts.gamma^T)*(1-opts.xi)*2;
                H(idx_E(tau,2),idx_E(tau,2)) = (opts.gamma^(tau-1)-opts.gamma^tau)/(1-opts.gamma^T)*opts.xi*2;
            else
                H(idx_E(tau,1),idx_E(tau,1)) = (opts.gamma^(tau-1)-opts.gamma^tau)/(1-opts.gamma^T)*(1-opts.xi(tau))*2;
                H(idx_E(tau,2),idx_E(tau,2)) = (opts.gamma^(tau-1)-opts.gamma^tau)/(1-opts.gamma^T)*opts.xi(tau)*2;
            end
            X_tau = X(:,2,tau);
            Y_tau = Y(2,tau)';
            XX = X_tau*X_tau';
            YX = Y_tau*X_tau';
            % loss term
            H(idx_W(tau,:),idx_W(tau,:)) = H(idx_W(tau,:),idx_W(tau,:)) + (opts.gamma^(tau-1)-opts.gamma^tau)/(1-opts.gamma^T)*XX;
            f(idx_W(tau,:)) = f(idx_W(tau,:)) - (opts.gamma^(tau-1)-opts.gamma^tau)/(1-opts.gamma^T)*YX';
        end
        if tau < T
            % lead time difference
            H(idx_W(tau,:),idx_W(tau,:)) = H(idx_W(tau,:),idx_W(tau,:)) + opts.omega*eye(m);
            H(idx_W(tau+1,:),idx_W(tau+1,:)) = H(idx_W(tau+1,:),idx_W(tau+1,:)) + opts.omega*eye(m);
            H(idx_W(tau,:),idx_W(tau+1,:)) = H(idx_W(tau,:),idx_W(tau+1,:)) - opts.omega*eye(m);
            H(idx_W(tau+1,:),idx_W(tau,:)) = H(idx_W(tau+1,:),idx_W(tau,:)) - opts.omega*eye(m);
        end
        % nu smooth
        H(idx_W(tau,:),idx_W(tau,:)) = H(idx_W(tau,:),idx_W(tau,:)) + opts.nu*eye(m);
        f(idx_W(tau,:)) = f(idx_W(tau,:)) - opts.nu*W1(:,tau);
        % nu reg
        H(idx_U,idx_U) = H(idx_U,idx_U) + opts.eta*eye(m);
        H(idx_W(tau,:),idx_W(tau,:)) = H(idx_W(tau,:),idx_W(tau,:)) + opts.eta*eye(m);
        H(idx_U,idx_W(tau,:)) = H(idx_U,idx_W(tau,:)) - opts.eta*eye(m);
        H(idx_W(tau,:),idx_U) = H(idx_W(tau,:),idx_U) - opts.eta*eye(m);
    end
    Aeq=zeros(tau+1,m*T+m+2*T);
    beq=ones(tau+1,1);
    for tau=1:T
        Aeq(tau,idx_W(tau,:))=1;
    end
    Aeq(tau+1,idx_U)=1;
    A=[];
    b=[];
    for tau = 1:T
        if delta(tau)
            X_tau = X(:,1,tau);
            Y_tau = Y(1,tau);
            A_t = zeros(1,m*T+m+2*T);
            A_t(idx_W(tau,:)) = X_tau;
            A_t(idx_E(tau,1)) = -1;
            A_t(idx_E(tau,2)) = 1;
            b_t = Y_tau;
            Aeq = [Aeq; A_t];
            beq = [beq; b_t];
        end
    end
    lb=zeros(m*T+m+2*T,1);
    ub=inf(m*T+m+2*T,1);
    options =  optimoptions('quadprog','MaxIterations',10000,'Display','off');
    res = quadprog(H,f,A,b,Aeq,beq,lb,ub,[],options);
    W2 = reshape(res(1:m*T),m,T);
    U2 = res(m*T+1:m*T+m);
    U2 = remove_weight_neg(U2);
    W2 = remove_weight_neg(W2);
    sum_U2 = sum(U2);
    sum_W2 = sum(W2,1);
    U(idx_model) = U2/sum_U2*sum_U1;
    W(idx_model,:) = W2./sum_W2.*sum_W1;
    U = U*sum_U2/sum_U;
    W = W.*sum_W2./sum_W;
    W_all = [W(:); U(:)];
end
