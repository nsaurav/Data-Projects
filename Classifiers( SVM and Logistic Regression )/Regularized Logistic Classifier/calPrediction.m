function [ prediction ] = calPrediction(X,w)
    %Calculate Prediction
    z = X*w; %N*10
    [~, prediction] = max(z,[],2); 
end

