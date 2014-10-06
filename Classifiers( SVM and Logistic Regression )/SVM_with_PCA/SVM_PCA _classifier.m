%% loading data
    data = load('USPS-split');
    trainData = (data.X.train)'; %% no of samples*D=1000*256
    numRows = size(trainData,1);
    trainLabel = (data.y.train)'; %% 1000*1
    testData = (data.X.test)';  %% 2000*256
    testLabel = (data.y.test)'; %% 2000*1
%% Preprocessing step : Digonalize Data
    meanRowVector = mean(trainData);
    processed_TrainData = trainData-repmat(meanRowVector,numRows,1); %% mean of all training shld be zero

% Another preprocessing step : standardize
    temp1_standard = repmat([1/255],1,256);
    temp2_standard = sum(processed_TrainData.*processed_TrainData) ;
    temp3_standard = sqrt(temp1_standard.*temp2_standard);
    temp4_standard = 1./temp3_standard;
    temp5_standard = repmat(temp4_standard,numRows,1);
    temp6_standard = repmat(temp4_standard,size(testData,1),1);
    standard_TrainData = processed_TrainData.*temp5_standard;
    processed_TestData = testData-repmat(meanRowVector,size(testData,1),1);
    standard_TestData = processed_TestData.*temp6_standard;

%%Initializing 
    m = [5,20,40,60,100]; %% will project data on m-dimensional subspace
    modelMatrix_diagonalize = [m;zeros(3,numel(m))]'; %% model matrix stores paramter and accuracy values corr to each M
    modelMatrix_whiten = [m;zeros(3,numel(m))]'; %% model matrix stores paramter and accuracy values corr to each M

% arrays to store prediction 2000*m
    pca_diagonalize_predictionArray = zeros(size(testData,1),numel(m));
    pca_whiten_predictionArray = zeros(size(testData,1),numel(m));

    for i = 1:size(m,2)
         %% find top 'm(i)' eigen vectors of trainData'*traindata.
         [U,eigenValues] = eigs(processed_TrainData'*processed_TrainData,m(i));
         projectedData = processed_TrainData*U; %% 1000*m
         projectedTestData = processed_TestData*U;

         %% Call find best paramaters function to get optimal C and gamma value for Gaussian RBF Kernel
         [modelMatrix_diagonalize(i,2),modelMatrix_diagonalize(i,3)] = findbestParameters(projectedData,trainLabel);

         %%use the best parameters found corresponding to each m(i) to train over training dataset again
         model_diagonalize = svmtrain(trainLabel,projectedData,sprintf('-s %d -t % d -c %f -g %f -q',0,2,modelMatrix_diagonalize(i,2),modelMatrix_diagonalize(i,3)));
   
         %%use the model to make predictions
         [pca_diagonalize_predictionArray(:,i),accuracy_diagonalize,probEstimates] = svmpredict(testLabel,projectedTestData,model_diagonalize);
         modelMatrix_diagonalize(i,4) = accuracy_diagonalize(1);

         %% now whiten the data and try training model again using SVM
         new_eigenVal = sqrtm(eigenValues);
         eigenVal_whiten = inv(new_eigenVal);
         projectedData_whiten = projectedData*eigenVal_whiten; %% whitened data--covaraice matrix =I
         projectedTestData_whiten = projectedTestData*eigenVal_whiten;
         %find best parameters 
         [modelMatrix_whiten(i,2),modelMatrix_whiten(i,3)] = findbestParameters(projectedData_whiten,trainLabel);
         % train using SVM
         model_whiten = svmtrain(trainLabel,projectedData_whiten,sprintf('-s %d -t % d -c %f -g %f -q',0,2,modelMatrix_whiten(i,2),modelMatrix_whiten(i,3)));
         %%use the model to make predictions
         [pca_whiten_predictionArray(:,i),accuracy_whiten,probEstimates] = svmpredict(testLabel,projectedTestData_whiten,model_whiten);
         modelMatrix_whiten(i,4) = accuracy_whiten(1);
    end

    %Standardization PCA and SVM
    [U_Standard,eigenValues_standard] = eigs(standard_TrainData'*standard_TrainData,256);
    projectedData_standard = standard_TrainData*U; %% 1000*m
    projectedTestData_standard = standard_TestData*U;
    [standard_BestC,standard_BestGamma] = findbestParameters(projectedData_standard,trainLabel);
    model_standard = svmtrain(trainLabel,projectedData_standard,sprintf('-s %d -t % d -c %f -g %f -q',0,2,standard_BestC,standard_BestGamma));
    [standard_prediction,accuracy_standard,probEstimates] = svmpredict(testLabel,projectedTestData_standard,model_standard);
    %accuracy_standard(1)
 
    [maxAcc_diagonalize,bestModelindex_diagonalize] = max(modelMatrix_diagonalize(:,4));
    [maxAcc_whiten,bestModelindex_whiten] = max(modelMatrix_whiten(:,4));
    bestModel_diagonalize = modelMatrix_diagonalize(bestModelindex_diagonalize,1)
    %maxAcc_diagonalize
    bestModel_whiten = modelMatrix_whiten(bestModelindex_whiten,1)
    %maxAcc_whiten
    pca_diagonalize_prediction = pca_diagonalize_predictionArray(:,bestModelindex_diagonalize)
    pca_whiten_prediction = pca_whiten_predictionArray(:,bestModelindex_whiten)
    figure();
    plot(modelMatrix_diagonalize(:,1),modelMatrix_diagonalize(:,4),'--rs','LineWidth',2,...
                 'MarkerEdgeColor','k',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',10)
    xlabel('M->'), ylabel('ACCURACY->'), title('Accuracy results for different M after Diagonalizing the data')
    text(bestModel_diagonalize, maxAcc_diagonalize, 'M*', ...
    'HorizontalAlign','left', 'VerticalAlign','top')
    figure();
    plot(modelMatrix_whiten(:,1),modelMatrix_whiten(:,4),'--rs','LineWidth',2,...
                 'MarkerEdgeColor','k',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',10);
    xlabel('M->'), ylabel('ACCURACY->'), title('Accuracy results for different M after Whitening the data')
    text(bestModel_whiten,  maxAcc_whiten, 'M*', ...
    'HorizontalAlign','left', 'VerticalAlign','top')
