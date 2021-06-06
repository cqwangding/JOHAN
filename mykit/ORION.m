function [w0, V]=ORION(w0, V, L, X, Y, mu, lambda, beta, epsilon, S)
% This function is used for online multi-task learning in PA way
% Input: w0 and V are the parameters in previous round
%        L is the available task set, 0 for missing, 1 for not missing
%        X, Y are the input feature space and output for each task
%        S is the adjacency matrix of the tasks 
%        If task i is missing, then Y(i) = NaN (L will indicate which Y is NaN anyway)


[T, d] = size(V);
Lap = eye(T) - S;
LapNew = Lap + mu*eye(T);

[T,d] = size(V);
index = find(L);
x = X(index, :);
y = Y(index);
Olength = length(index);

Wt = repmat(w0', [T,1]) + V;
Yhat = sum(X.*Wt,2);

%% construct matrix: Z, R Q B M P Xi Yi
% Zstar: old Z
% Zstar = [w0; zeros(T*d,1)];
Vtmp = V';
Zstar = [w0; Vtmp(:)];
% R: online learning time constraints
Id = eye(d);
% R = [lambda*eye(d) zeros(d,T*d); zeros(T*d,d) kron(LapNew, eye(d))];
tmpR = beta*eye(T+1); tmpR(1,1) = lambda;
R = kron(tmpR, Id);

% Q: task relationship matrix
Q = [zeros(d,d) zeros(d,T*d); zeros(T*d,d) kron(LapNew, eye(d))];

% M
M = inv(R + Q);

% % M: linear coefficient matrix
% tmpM = repmat(eye(d), 1, T);
% M = [tmpM; eye(T*d)];

% P: indicator of whether this task is available and has error: Indicator function for Yhat - Y
I = zeros(T,1);
I(abs(Yhat-Y)>epsilon) = 1; % NaN value will not be processed so only tasks in L will count
P = diag(I);
% P = kron(tmpP, eye(d));
% S: sign function for Yhat - Y
signY = sign(Yhat - Y);
signY(isnan(Y))=0;
Y(isnan(Y)) = 0;
S = diag(signY);
% S = kron(tmpS, eye(d));

% Xi: X_tilda
tmpX = X';
Xi = zeros(d*T, T);
for i = 1:T
    Xi((i-1)*d+1:i*d,i) = tmpX(:,i);
end
Xi = [tmpX; Xi];

% Yi: vectorized Y
Yi = Y;

% XPS
XPS = Xi * S * P;

zhat = M' * R' * Zstar; 

losszhat = ((zhat'*Xi - Yi')*S - epsilon*ones(1,T))*P;
%% compute Z
AA = (XPS' * M' * XPS);
BB = losszhat'; 
Gamma = zeros(T, 1);
Gamma(find(I)) = AA(find(I), find(I)) \ BB(find(I)); 
Z = M*(R*Zstar - Xi * S * P * Gamma);

w0 = Z(1:d);
Z(1:d) = [];
Vtmp = reshape(Z, [d, T]);
V = Vtmp';

%Wt = repmat(w0', [T,1]) + V;
%Yhat = sum(X.*Wt,2);
%err = sum(max([abs(Yhat(index)-y)-epsilon, zeros(Olength,1)], [], 2))/Olength;

end
