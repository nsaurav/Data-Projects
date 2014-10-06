Implementation of multinomial naive bayes mutliclass text classifier.
Used here for Text Classfication.

Format of training file. Starts with Label.
HAM subject : meeting today hi , could we have a meeting today . thank you . 

Script Description
python nblearn.py trainingfile modelfile -> will learn a model from training file and store this model in modelfile

python nbclassfiy.py modelfile testfile -> will classify new text document.

nbclassifier.py contains classifer class.

