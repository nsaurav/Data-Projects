function [ optW ] = newtonMethod(X_train,y,w_old,lambda,flag)
   %Implementing optimal w
   % get Hessian and firstDerivative
   gamma = 0.5;
   j = 0;
   epsilon = 10^(-5);
   crossEntropy = objFunction(X_train,y,w_old,lambda);
   hessian = calHessian(X_train,w_old,lambda);
   firstDer = calFirstDer(X_train,y,w_old, lambda);
   crossEntropyAsIteration = zeros(1,51);
   
   for i = 0:50
       optW = w_old-(gamma.^j)*(hessian\firstDer);
       crossEntropy_new = objFunction(X_train,y,optW,lambda);
       crossEntropyAsIteration(i+1) = crossEntropy_new;
       %if((abs(crossEntropy_new-crossEntropy)/crossEntropy)<epsilon) 
       if((abs(crossEntropy_new-crossEntropy))<epsilon) 
           %fprintf('A%d\t', ii);
           break;
       end

       if(crossEntropy_new < crossEntropy) 
         crossEntropy = crossEntropy_new;
         %fprintf('tE_%.8f\t', crossEntropy);
         %we'll renew w_old with optW and update hessian and firstDer
         w_old = optW; 
         hessian = calHessian(X_train,w_old,lambda);
         firstDer = calFirstDer(X_train,y,w_old, lambda);
       else
          if (j < 15)
              j = j+1;
          else       %if j>=15, the step is small enough, we can finish.
              break;
          end
            
       end
    end

    if(flag == 1)
        figure
        plot(crossEntropyAsIteration,'-b');
        title('Cross Entropy v/s iterations');
        xlabel('Iterations');
        ylabel('Cross Entropy');
    end
%fprintf('CE_%f\t', crossEntropy);
end

