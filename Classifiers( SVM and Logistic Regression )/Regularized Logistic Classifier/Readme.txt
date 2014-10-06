Aim: Implementaion of regularized logistic classifer using netwon's optimization.
Dataset : Hanwritten-digit dataset
Script description:
  calAccuracy.m  -> contains a function to calculate accuracy
  calFirstDer.m  -> contains a function to calculate first derivative
  calHessian.m   -> contains a function to calculate Hessian 
  getModified.m  -> contains a function to modify Y label for one vs all classification
  newtonMethod.m -> contains a function to calculate optimal parameter using newton's optimization
  objFunction.m  -> conatins a function to calculate cross entropy error function
  logistic_classifer.m -> main script . train data, tune hyperparametrs using cross validation anf make prediction
