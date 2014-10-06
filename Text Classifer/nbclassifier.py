import cPickle as pickle
import math

class classifier:
    
    dictlist = 0
    classes = 0
    def __init__(self):
        self.vocab_size = 0
        self.classes = {}
        self.dictlist = []
        self.sum_of_words = []

    # Get different classes    
    def calc_classes(self, fileName):
        fileObj = open(fileName, "r")
        
        for line in fileObj:
            line = line.strip()
            words = line.split(" ",1)
            if self.classes.has_key(words[0]):
                self.classes[words[0]] += 1
            else: 
                self.classes[words[0]] = 1
        
        return len(self.classes)
    
    #create list of dictionary. One dictionary for each class    
    def create_dict(self, class_count):
        self.dictlist = [{} for x in range(class_count)]
        #self.class_wc = [0 for x in range(class_count)]
    
    # read from file and populate dictionary of different class    
    def read_from_file(self, fileName):
        fileObj = open(fileName, "r")
        cls = self.classes.keys()
        for line in fileObj:
            line = line.strip();
            temp = line.split(" ", 1 )
            
            for index in range(len(cls)):
                if temp[0].startswith(cls[index]):
                    words = temp[1].split(" ")
                    # get vocab size and populate dictionary of class to which that document belongs
                    for word in words:
                        flag = 1
                        for ind in range(len(cls)):
                            if self.dictlist[ind].has_key(word):
                                flag = 0
                        if flag == 1:
                            self.vocab_size = self.vocab_size + 1
                                        
                        if self.dictlist[index].has_key(word):
                            self.dictlist[index][word] = self.dictlist[index][word]+1
                        else:
                            self.dictlist[index][word] = 1
                            
        
    
    def sum(self, index):
        wcs = self.dictlist[index].values()
        s = 0
        for x in wcs:
            s += x
        return s
    
    # calculate word probability using Laplace smmothing
    def wordProbability(self, word, forClass):
        if self.dictlist[forClass].has_key(word):
            num = self.dictlist[forClass].get(word) + 1
            den = self.sum_of_words[forClass] + self.vocab_size
        else:
            num = 1
            den = self.sum_of_words[forClass] + self.vocab_size
        
        #print word, " ", num*1.0/den
        return num*1.0/den
    
    # classift new data points
    def classify(self, sentence):
        p_list = []
        total = 0
        for index in range(len(self.classes)):
            total += self.classes.get(self.classes.keys()[index])
            self.sum_of_words.insert(index, self.sum(index))
        
        for index in range(len(self.classes)):
            p_list.insert(index,math.log(self.classes.get(self.classes.keys()[index]))-math.log(total))
            words = sentence.split(" ")
            for word in words: 
                p_list[index] += math.log(self.wordProbability(word, index))
        
        
        ans = max(p_list)
        ind = p_list.index(ans)
                
        return ind
            
    # save model i.e different probabilities    
    def save_model(self, fileName):
        modelFile = open(fileName,'wb')
        pickle.dump(self.dictlist, modelFile, protocol=2)
        pickle.dump(self.classes, modelFile, protocol=2)
        pickle.dump(self.vocab_size, modelFile, protocol=2)
        modelFile.close()
        
    def reload_model(self, fileName):
        testFile = open(fileName,'rb')
        self.dictlist = pickle.load(testFile)
        self.classes = pickle.load(testFile)
        self.vocab_size = pickle.load(testFile)
        testFile.close()
        
