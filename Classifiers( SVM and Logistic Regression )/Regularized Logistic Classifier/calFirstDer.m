function [vecFirstDer] = calFirstDer(X,y,w,lambda)
    %Calculates first Derivative
    z = X*w; %N*1
    sigmoid = 1./(1+exp(-z)); %N*1
    error = sigmoid-y; %N*1
    regTerm = w(1:end);
    vecFirstDer = X'*error+2*lambda*regTerm;
end

