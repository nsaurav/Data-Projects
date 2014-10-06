function [ accuracy ] = calAccuracy( X,y,w )
    %Calculate Accuracy
   z = X*w; %N*1
   sigmoid = 1./(1+exp(-z));
   accuracy = sigmoid > 0.5;
   accuracy = accuracy == y;
   accuracy = sum(accuracy);

end

