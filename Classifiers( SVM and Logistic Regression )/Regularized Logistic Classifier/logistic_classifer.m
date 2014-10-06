%% main script for Regularized Logistic Regression 
    clear;
%% loading data
    data = load('USPS-split');
    temp_x = data.X.train; %% D*no of samples 
    temp_y = data.y.train; 
    temp_xTest = data.X.test;
    temp_yTest = data.y.test;
%d=dimensionality of feature space
    d = size(temp_x,1);
    X = [ones(size(temp_x,2),1),temp_x'];
    X_tran = X';
    y=temp_y';
    X_test = [ones(size(temp_xTest,2),1),temp_xTest'];
    y_test = temp_yTest';
%%initialie weight vector and lambda( regularization parameter to be zero )
    w = zeros(d+1,1);
    lambdaVal = zeros(1,10);
%get modified y matrix (1000*10)
    yModified = getModifiedy(y);

% Cross validation to tune hyperparameters value
    
    for k = 1:10
 	index = 0
        y = yModified(:,k);
        avAccuracy = 0;
        for j = 1:6     % it's big enough, when j=6 lambda = 1000.
            lambda = .001*(10.^(j-1));
            %lambda = .01 * j;
            accuracy = 0;
            for i = 1:50:951
                X_val = X_tran(:,i:i+49); %%validation set
                X_val = X_val';
                y_val = y(i:i+49);
                
		if(i == 1)
                    X_train = X_tran(:,50+i:end);
                    X_train = X_train';
                    y_train = y(50+i:end);
                else
                    X_train = [X_tran(:,1:i-1),X_tran(:,i+50:end)];
                    X_train = X_train';
                    y_train = [y(1:i-1);y(i+50:end)];
                end
                optW = newtonMethod(X_train,y_train,w,lambda,0);
                accuracy = accuracy+calAccuracy(X_val,y_val,optW);
                %fprintf('ACC_%d\t\n', accuracy);
            end
        %fprintf('%f\t%d\t%f\t%f\n', lambda, accuracy, optW(1), sum(optW));
            if(avAccuracy < (accuracy/20))
                avAccuracy = accuracy/20;
                index = j;
             end
        end
    lambdaVal(k) = .001*(10.^(index-1));

    end

    calculatedW = zeros(d+1,10); %% matrix whose ith col=weight vector for k=i
    for i = 1:10  % calculate w by training the model again using all training data and optimal lambda values.
        y = yModified(:,i);
        optLambda = lambdaVal(i);   
        optW = newtonMethod(X,y,w,optLambda,1);
        calculatedW(:,i) = calculatedW(:,i)+ optW;
    end
    fprintf('The resulting hypothesis W_DISC is:\n');

%%prediction
    predictionTrain = calPrediction(X,calculatedW);
    trainAccuracy = predictionTrain == temp_y';
    trainingAccuracy = (sum(trainAccuracy)/1000)*100; 
    trainingAccuracy
    predictionTest = calPrediction(X_test,calculatedW);   
    testAccuracy = predictionTest == y_test;
    testingAccuracy = (sum(testAccuracy)/2000)*100;


