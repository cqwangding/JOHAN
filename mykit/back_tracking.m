function [W, P] = back_tracking(X, Y, time, W_init, opts, algo_update, algo_predict, algo_use_predict)
%   Detailed explanation goes here
    process = 'Online back tracking and restart';
    fprintf('---------- %s / Begin ----------\n', process);
    
    [m, d, T, N] = size(X);
    num = length(W_init);
    W = zeros(num, N);
    W_t = W;
    W_g = W_init;
    P = nan(d,T,N);
        
    t1=clock;
    h = 1;
    for t = 1:N
        if mod(t, 500)==0
            t2=clock;
            fprintf('%s / Runs:%d/%d / Timeleft:%s\n', process, t, N, get_timeleft(t,N,t1,t2));
        end
        if t == time(h,1)
            W(:,t) = W_g;
            W_t(:,t) = W_g;
        else
            for t_b = max(time(h,1), t-T):t-1
                X_t = X(:,:,:,t_b);
                Y_t = nan(d, T);
                taus = 1:t-t_b;
                Y_t(:,taus) = Y(:,taus,t_b);
                if opts.use_predict == 1
                    Y_predict = algo_use_predict(X(:,:,:,t),W_t(:,t-1));
                    taus = t-t_b+1:T;
                    if numel(taus)>0
                        Y_t(:,taus) = Y_predict(:,t_b+taus-t);
                    end                 
                end
                if isfield(opts, 'Y_info')
                    opts_t = opts;
                    opts_t.Y_info = opts.Y_info(:,2:end,t_b);
                    W_t(:,t_b+1) = algo_update(X_t, Y_t, W_t(:,t_b), opts_t);
                else
                    W_t(:,t_b+1) = algo_update(X_t, Y_t, W_t(:,t_b), opts);
                end
            end
            W(:,t) = W_t(:,t);
            if t == time(h,2)
                W_g = W_g*(1-opts.rho) + W(:,t)*opts.rho;
                h = h+1;
            end
        end
        P(:,:,t) = algo_predict(X(:,:,:,t),W(:,t));
    end
end
