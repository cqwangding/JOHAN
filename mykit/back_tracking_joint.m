function [W, P] = back_tracking_joint(X, Y, time, W_init, opts, algo_update, algo_predict, algo_use_predict)
%   Detailed explanation goes here
    process = 'Online back tracking and restart for joint learning';
    fprintf('---------- %s / Begin ----------\n', process);
    
    [m, d(1), T, N] = size(X{1});
    num = length(W_init{1});
    W{1} = zeros(num, N);
    W_t{1} = W{1};
    W_g{1} = W_init{1};
    P{1} = nan(d(1),T,N);
    [m, d(2), T, N] = size(X{2});
    num = length(W_init{2});
    W{2} = zeros(num, N);
    W_t{2} = W{2};
    W_g{2} = W_init{2};
    P{2} = nan(d(2),T,N);
        
    t1=clock;
    h = 1;
    for t = 1:N
        if mod(t, 500)==0
            t2=clock;
            fprintf('%s / Runs:%d/%d / Timeleft:%s\n', process, t, N, get_timeleft(t,N,t1,t2));
        end
        if t == time(h,1)
            W{1}(:,t) = W_g{1};
            W_t{1}(:,t) = W_g{1};
            W{2}(:,t) = W_g{2};
            W_t{2}(:,t) = W_g{2};
        else
            for t_b = max(time(h,1), t-T):t-1
                X_t{1} = X{1}(:,:,:,t_b);
                Y_t{1} = nan(d(1), T);
                taus = 1:t-t_b;
                Y_t{1}(:,taus) = Y{1}(:,taus,t_b);
                if opts{1}.use_predict == 1
                    Y_predict = algo_use_predict{1}(X{1}(:,:,:,t),W_t{1}(:,t-1));
                    taus = t-t_b+1:T;
                    if numel(taus)>0
                        Y_t{1}(:,taus) = Y_predict(:,t_b+taus-t);
                    end                 
                end
                X_t{2} = X{2}(:,:,:,t_b);
                Y_t{2} = nan(d(2), T);
                taus = 1:t-t_b;
                Y_t{2}(:,taus) = Y{2}(:,taus,t_b);
                if opts{2}.use_predict == 1
                    Y_predict = algo_use_predict{2}(X{2}(:,:,:,t),W_t{2}(:,t-1));
                    taus = t-t_b+1:T;
                    if numel(taus)>0
                        Y_t{2}(:,taus) = Y_predict(:,t_b+taus-t);
                    end                 
                end
                P_t = algo_predict{2}(X{2}(:,:,:,t),W{2}(:,t));
                xi=nan(1,T);
                xi(P_t>opts{1}.th)=1./(1+exp((opts{1}.th-P_t(P_t>opts{1}.th))/opts{1}.c));
                xi(P_t<=opts{1}.th)=0.5;
                if isnan(xi(1))
                    xi(1)=0.5;
                end
                xi=impute_forward(xi);
                opts{1}.xi=xi;
                P_t = [Y{1}(:,1,t), algo_predict{1}(X{1}(:,:,:,t),W{1}(:,t))];
                P_coast = get_coast_data(P_t, opts{1});
                P_coast = (1-P_coast(3,:)*2).*P_coast(4,:);
                xi=nan(1,T);
                xi(P_coast<opts{2}.th)=1./(1+exp((P_coast(P_coast<opts{2}.th)-opts{2}.th)/opts{1}.c));
                xi(P_coast>=opts{2}.th)=0.5;
                if isnan(xi(1))
                    xi(1)=0.5;
                end
                xi=impute_forward(xi);
                opts{2}.xi=xi;
                opts_t = opts{1};
                opts_t.Y_info = opts{1}.Y_info(:,2:end,t_b);
                W_t{1}(:,t_b+1) = algo_update{1}(X_t{1}, Y_t{1}, W_t{1}(:,t_b), opts_t);
                W_t{2}(:,t_b+1) = algo_update{2}(X_t{2}, Y_t{2}, W_t{2}(:,t_b), opts{2});
            end
            W{1}(:,t) = W_t{1}(:,t);
            W{2}(:,t) = W_t{2}(:,t);
            if t == time(h,2)
                W_g{1} = W_g{1}*(1-opts{1}.rho) + W{1}(:,t)*opts{1}.rho;
                W_g{2} = W_g{2}*(1-opts{2}.rho) + W{2}(:,t)*opts{2}.rho;
                h = h+1;
            end
        end
        P{1}(:,:,t) = algo_predict{1}(X{1}(:,:,:,t),W{1}(:,t));
        P{2}(:,:,t) = algo_predict{2}(X{2}(:,:,:,t),W{2}(:,t));
    end
end
