function [ bestC, bestGamma ] = findbestParameters( training_instance_matrix,training_label_vector)
%Finds best model(paramteres C,gamma) for a given M.
    [C,gamma]=meshgrid(1:.5:10,-20:2:10);
    iteration=numel(gamma);
    model_CVAccuracy=zeros(iteration,1); %% to store cvAccuracy for each combnation of C,gamma
    for i=1:iteration
  
        str_options=sprintf('-s %d -t % d -c %f -g %f -v %d -q',0,2,2^C(i),2^gamma(i),5);
        model_CVAccuracy(i)=svmtrain(training_label_vector,training_instance_matrix,str_options);
    end
    [~,max_index]=max(model_CVAccuracy);
    bestC=2^C(max_index);
    bestGamma=2^gamma(max_index);
end
