import sys
from nbclassifier import classifier;

modelfile = sys.argv[1]
testfile = sys.argv[2]

required_class = 1
correct = 0
classified_class = 0
correct_class = 0
count_class = 0

nb = classifier()
nb.reload_model(modelfile)
print nb.classes
required_class_name = nb.classes.keys()[required_class]
fileObj = open(testfile, "r")
i=0
for line in fileObj:
    i+=1
    line = line.split('\n')[0];
    temp = line.split(" ", 1 )
    val = nb.classify(temp[1])
    className = nb.classes.keys()[val]
    if temp[0].startswith(required_class_name):
        count_class +=1
        if temp[0].startswith(className):
            correct_class +=1
    if className.startswith(required_class_name):
        classified_class +=1
   
#accuracy = correct*100/1363.0
precision = correct_class*1.0/classified_class
recall = correct_class*1.0/count_class
fscore = 2 * precision * recall / (precision + recall)

#print "Accuracy: " , accuracy
print "Precision: " , precision
print "Recall: " , recall
print "F-score: " , fscore
