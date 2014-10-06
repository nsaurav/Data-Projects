function [ matrixHessian ] = calHessian( X,w,lambda )
    %Calculate Hessian Matrix
    z = X*w; %N*1
    sigmoid = 1./(1+exp(-z));
    alpha = sigmoid.*(1-sigmoid); %N*1
    X_temp = X'*diag(alpha); %X_temp is D*N matirx with alpha(i) multiplied to x(i) input

   regTerm = [zeros(size(X_temp,1),1),[zeros(1,size(X_temp,1)-1);eye(size(X_temp,1)-1)]];
   matrixHessian = X_temp*X +2*lambda*regTerm;
end

