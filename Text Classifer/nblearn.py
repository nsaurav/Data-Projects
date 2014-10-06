import sys
from nbclassifier import classifier;

trainfile = sys.argv[1]
modelfile = sys.argv[2]
c = classifier()
x = int(c.calc_classes(trainfile))
c.create_dict(x)
c.read_from_file(trainfile)
c.save_model(modelfile)
print "Done!"
