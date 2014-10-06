import cPickle as pickle

class Perceptron(object):
    
    classes = 0
    vocab = 0
    weights = 0
    sum_weights = 0
    accuracy = 0;

    def __init__(self):
        '''
        Constructor
        '''
        self.vocab = {}
        self.classes = {}
        self.weights = {}
        self.sum_weights = {}
    
    # takes a file->filename process it( extract features ) and make a new file outfile which can be passed to perceptron.
    # outfile has foramt as Tag feature1 feature2 ......
    def createfile(self, filename, outfile):
        fo = open(filename);
        of = open(outfile,"wb")
        for line in fo:
            line = line.split("\n")[0]
            line = line.split("\r")[0]
            line = "BOS/BOS BOS/BOS " + line + "EOS/EOS EOS/EOS"
            line.replace("#", "HASH")
            words = line.split(" ")
        
            for index in range(2,len(words)-2):
                word_tag = words[index].rsplit("/")
                if len(word_tag)!=2:
                    continue
                prevword1 = words[index-1].rsplit("/")[0]
                prevword2 = words[index-2].rsplit("/")[0]
                prevtag1 = words[index-1].rsplit("/")[1]
                prevtag2 = words[index-2].rsplit("/")[1]
                nextword1 = words[index+1].rsplit("/")[0]
                nextword2 = words[index+2].rsplit("/")[0]
                suffix = word_tag[0][-3:]
                prefix = word_tag[0][:3]
                psuffix1 = prevword1[-3:]
                pprefix1 = prevword1[:3]
                nsuffix1 = nextword1[-3:]
                nprefix1 = nextword1[:3]
                outline = word_tag[1] + " word:" + word_tag[0] +" suffix:" + suffix + " prefix:"+prefix + " prevword2:" + prevword2 + " prevtag2:" + prevtag2 + " prevword1:" + prevword1 + " prevtag1:" + prevtag1 + " nextword1:" + nextword1 + " nextword2:" + nextword2 + " psuffix:" + psuffix1 + " pprefix:"+pprefix1 + " nsuffix:" + nsuffix1 + " nprefix:"+nprefix1 
            
                outline +="\n"
                of.write(outlin

    # takes training file and initalize weight to be zero. There will be N different set of weight vector if there are N different classes.
    def initialize(self, fileName):
        fileObj = open(fileName,"rb")
        
        for line in fileObj:
            line = line.strip()
            line = line.split("\r")[0]
            line = line.split(" ",1)
            if not self.classes.has_key(line[0]):
                self.classes.setdefault(line[0],0)
            words = line[1].split(" ")
            for word in words:
                if not self.vocab.has_key(word):
                    self.vocab[word]=0
                    
        fileObj.close()
        for c in self.classes.keys():
            self.weights[c] = {}
            self.sum_weights[c] = {}
            self.weights[c] = self.weights[c].fromkeys(self.vocab.keys(),0)
            self.sum_weights[c] = self.sum_weights[c].fromkeys(self.vocab.keys(),0)
    
    # take training file and train perceptron    
    def train(self, fileName, iter):
        fileObj = open(fileName,"rb")
        for index in range(iter):
            fileObj.seek(0)
             
            for line in fileObj:
                line = line.strip()
                line = line.split("\r")[0]
                line = line.split(" ",1)
                ans = line[0]
                words = line[1].split(" ")
                self.classes = self.classes.fromkeys(self.classes.keys(),0)
                for word in words:
                    for c in self.classes:
                        self.classes[c] += self.weights[c][word]
                
                maxc = self.maxclass()
                
                if not ans.startswith(maxc):
                    for word in words:
                        self.weights[maxc][word] -= 1;
                        self.weights[ans][word] += 1;
            
               
            for c in self.classes:
                #print c + "->" + str(self.weights[c])
                for w in self.sum_weights[c]:
                    self.sum_weights[c][w] += self.weights[c][w]  
                
        fileObj.close()
        for c in self.classes:
            for w in self.sum_weights[c]:
                self.sum_weights[c][w] /= iter*1.0
                
            #print c + " "+ str(self.sum_weights[c])
    
    # used in one vs all classification.                    
    def maxclass(self):
        maxc = self.classes.keys()[0]
        max = self.classes[maxc]
        for c in self.classes:
            if max < self.classes[c]:
                maxc = c
                max = self.classes[c]
                
        return maxc
    
    # saves model
    def save_model(self, fileName):
        modelFile = open(fileName,'wb')
        pickle.dump(self.sum_weights, modelFile, protocol=2)
        modelFile.close()
    # reload model
    def reload_model(self, fileName):
        testFile = open(fileName,'rb')
        self.sum_weights = pickle.load(testFile)
        testFile.close()

    # classify
    def classify(self, fileName):
        count = 0
        fo = open(fileName)
        for line in fo:
            line = line.split("\n")[0]
            line = line.split("\r")[0]
            line = line.split(" ",1)
            ans = line[0]
            words = line[1].split(" ")
            self.classes = self.classes.fromkeys(self.sum_weights.keys(),0)
            for word in words:
                for c in self.sum_weights:
                    self.classes[c] += self.sum_weights[c][word]
            count += 1
            maxc = self.maxclass()
            print maxc + " " + ans
            if ans == maxc:
                self.accuracy += 1
            
        print (self.accuracy*1.0)/count
        
        

