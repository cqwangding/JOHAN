function predict_flag = get_predict_flag(X, Y, NHC)
%GET_ERRORS Summary of this function goes here
%   Detailed explanation goes here

X_flag = get_missing_flag(X, 2, 1);
X_flag2 = get_missing_flag(X_flag, 1, 2, false);
Y_flag = get_missing_flag(Y, 1, 1);
NHC_flag = get_missing_flag(NHC, 1, 1);
s = size(X);
predict_flag = false(s(3),s(4));

for t=1:s(4)
    for tau=1:s(3)
        if Y_flag(tau,t) && X_flag2(tau,t) && NHC_flag(tau,t)
            predict_flag(tau,t) = true;
        end
    end
end

end
