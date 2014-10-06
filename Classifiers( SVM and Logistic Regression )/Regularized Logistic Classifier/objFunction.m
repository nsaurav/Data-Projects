function [ crossEntropy ] = objFunction( X,y,w,lambda )
    % Calculate Cross Entropy function
    z = X*w; %N*1
    sigmoid = 1./(1+exp(-z)); %N*1        
    crossEntropy = -(y'*log(sigmoid)+(1-y')*log(1-sigmoid))+ lambda*sum(w(2:end).^2); 
end

